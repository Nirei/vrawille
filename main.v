module vrawille

import stbi { Image, resize_uint8 }
import math { min, max, cos, sin, radians }

// Canvas.new creates a new canvas of the specified size
pub fn Canvas.new(width int, height int) &Canvas {
	return &Canvas { layers: create_buffer(width, height) }
}

// size returns a tuple with the dimensions of the canvas, first element
// represents width and second, height
pub fn (canvas Canvas) size() (int, int) {
	return canvas.layers[0].len, canvas.layers.len
}

// rows returns an array of the rows in this canvas as arrays of runes 
pub fn (canvas Canvas) rows() [][]rune {
	return buffer_to_braille(canvas.layers, dots_to_braille_rune_map)
}

// clear erases the canvas completely
pub fn (mut canvas Canvas) clear() {
	width, height := canvas.size()
	canvas.layers = create_buffer(width, height)
}

// get returns the status of the pixel in the given coordinates
pub fn (mut canvas Canvas) get(x int, y int) bool {
	if !canvas.valid_coordinates(x, y) { return false }
	return canvas.layers[y][x]
}

// set defines the status of the pixel in the given coordinates to active
pub fn (mut canvas Canvas) set(x int , y int) {
	if !canvas.valid_coordinates(x, y) { return }
	canvas.layers[y][x] = true
}

// unset defines the status of the pixel in the given coordinates to inactive
pub fn (mut canvas Canvas) unset(x int, y int) {
	if !canvas.valid_coordinates(x, y) { return }
	canvas.layers[y][x] = false
}

// toggle inverts the status of the pixel in the given coordinates
pub fn (mut canvas Canvas) toggle(x int, y int) {
	if !canvas.valid_coordinates(x, y) { return }
	canvas.layers[y][x] = !canvas.layers[y][x]
}

// line draws a line of pixels from and to specified points
pub fn (mut canvas Canvas) line(x1 int, y1 int, x2 int, y2 int) {
  xdiff := max(x1, x2) - min(x1, x2)
  ydiff := max(y1, y2) - min(y1, y2)
  xdir := if x1 <= x2 { 1 } else { -1 }
  ydir := if y1 <= y2 { 1 } else { -1 }

	r := max(xdiff, ydiff)

	for index in 0..r+1 {
		mut x := x1
		mut y := y1

		if ydiff != 0 { y += int((f32(index) * ydiff) / r * ydir) }
		if xdiff != 0 { x += int((f32(index) * xdiff) / r * xdir) }

		canvas.set(x, y)
	}
}

// draws a polygon with its conter in the given position, the given number of
// sides and the given radius of its circumcircle 
pub fn (mut canvas Canvas) polygon(center_x int, center_y int, sides int, radius int) {
	degree := f32(360) / sides

	for index in 0..sides {
		a := index * degree
		b := (index + 1) * degree
		x1 := int((center_x + cos(radians(a))) * (radius + 1) / 2)
		y1 := int((center_y + sin(radians(a))) * (radius + 1) / 2)
		x2 := int((center_x + cos(radians(b))) * (radius + 1) / 2)
		y2 := int((center_y + sin(radians(b))) * (radius + 1) / 2)

    canvas.line(x1, y1, x2, y2)
	}
}

// image draws an stbi Image in the canvas resized to fit the whole canvas
pub fn (mut canvas Canvas) image(image Image) ! {
	width, height := canvas.size()
	length := width * height
	resized := resize_uint8(image, width, height)!
	mut floating := []f64{len: length}
	unsafe {
		for index in 0..length { floating[index] = f64(resized.data[index]) / 255.0  }
	}

	for y in 0..height {
		for x in 0..width {
			index := y * width + x
			if floating[index] > 0.5 { canvas.set(x, y) }

			if y == height - 1 || x == 0 || x == 1 || x == width - 1 || x == width - 2 { continue }

			// Burkes dithering
			new_pixel := if floating[index] > 0.5 { 1.0 } else { 0.0 } 
			difference := floating[index] - new_pixel
			floating[index+1] 			+= 8.0/32.0 * difference
			floating[index+2] 			+= 4.0/32.0 * difference
			floating[index+width-2] += 2.0/32.0 * difference
			floating[index+width-1] += 4.0/32.0 * difference
			floating[index+width] 	+= 8.0/32.0 * difference
			floating[index+width+1] += 4.0/32.0 * difference
			floating[index+width+1] += 2.0/32.0 * difference
		}
	}
}

// str transforms this canvas contents to a multiline string
pub fn (canvas &Canvas) str() string {
	return canvas.rows().map(
		fn (row []rune) string {
			return row.map(
				fn (r rune) string {
					return r.str()
				}
			).join('')
		}
	).join_lines()
}

pub struct Canvas {
	mut:
		layers [][]bool
}

/* private code */

const grayscale_ratio_red = 0.2126
const grayscale_ratio_green = 0.7152
const grayscale_ratio_blue = 0.0722

/**
 * Maps each bit number in a dots byte (western reading order) to it's
 * corresponding bit number in the unicode Braille mapping.
 */
const dots_to_braille = [u8(0), 3, 1, 4, 2, 5, 6, 7]

/**
 * Maps each possible dots byte to an unicode rune.
 */
const dots_to_braille_rune_map = memoize_dots_to_braille_rune()

/**
 * dots_to_braille_rune returns the Unicode Braille character for a given 8-dot
 * mask. Dots are numbered in “Western reading order” (left→right, top→bottom):
 *     1 2
 *     3 4
 *     5 6
 *   	 7 8
 * The input byte’s most significant bit represents dot 1, and the least
 * significant bit dot 8.
 * See: https://en.wikipedia.org/wiki/Braille_Patterns
 *
 * Parameters:
 *   dots uint8 - 8-bit mask where each bit corresponds to a Braille dot.
 * 
 * Returns:
 *   rune - Unicode code point in the Braille block U+2800…U+28FF.
 */
fn dots_to_braille_rune(dots u8) rune {
  mut mask := 0
  for index in 0 .. 8 {
		if ((dots >> index) & 1) == 1 {
			mask |= 1 << dots_to_braille[index]
		}
  }
  
	return rune(0x2800 + mask)
}

fn memoize_dots_to_braille_rune() [256]rune {
  mut memo := [256]rune{}

  for index in 0..256 {
    memo[index] = dots_to_braille_rune(index)
  }

  return memo
}

/** 
 * Converts a 2D boolean buffer into a 2D grid of Braille runes.
 *
 * Each group of 2x4 pixels from the boolean buffer is mapped into a single
 * Braille character. The function iterates through the buffer, calculates which
 * Braille dots should be active, and converts them into runes using
 * `dots_to_braille_rune`.
 *
 * Parameters:
 *     buffer [][]bool - A 2D array of booleans representing pixels (true =
 *                       filled, false = empty). Dimensions are expected to be
 *                       multiples of 4 rows and 2 columns.
 * Returns:
 *     [][]rune - A 2D array of runes where each rune corresponds to one Braille
 *                character.
 */
fn buffer_to_braille(buffer [][]bool, braille_mapping [256]rune) [][]rune {
  out_rows := buffer.len/4
  out_cols := buffer[0].len/2
  mut output := [][]rune{len: out_rows, init: []rune{len: out_cols}}

  for row :=0; row < out_rows; row += 1 {
    row_offset := row * 4
    for column := 0; column < out_cols; column += 1 {
      col_offset := column * 2

      mut dots := u8(buffer[row_offset+0][col_offset+0])
      dots |= u8(buffer[row_offset+0][col_offset+1]) << 1
      dots |= u8(buffer[row_offset+1][col_offset+0]) << 2
      dots |= u8(buffer[row_offset+1][col_offset+1]) << 3
      dots |= u8(buffer[row_offset+2][col_offset+0]) << 4
      dots |= u8(buffer[row_offset+2][col_offset+1]) << 5
      dots |= u8(buffer[row_offset+3][col_offset+0]) << 6
      dots |= u8(buffer[row_offset+3][col_offset+1]) << 7

      output[row][column] = dots_to_braille_rune(dots)
    }
  }

  return output
}

/** Initialize an empty buffer */
fn create_buffer(width int, height int) [][]bool {
 return [][]bool{len: height, init: []bool{len: width}}
}

pub fn (mut canvas Canvas) valid_coordinates(x int, y int) bool {
	width, height := canvas.size()
	return x >= 0 && x < width && y >= 0 && y < height
}