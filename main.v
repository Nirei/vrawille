module vrawille

import stbi

pub fn Canvas.new(width int, height int) &Canvas {
	return &Canvas { layers: create_buffer(width, height) }
}

pub fn (canvas Canvas) size() (int, int) {
	return canvas.layers[0].len, canvas.layers.len
}

pub fn (canvas Canvas) output() [][]rune {
	return buffer_to_braille(canvas.layers, dots_to_braille_rune_map)
}

pub fn (mut canvas Canvas) set(x int , y int) {
	canvas.layers[y][x] = true
}

pub fn (mut canvas Canvas) unset(x int, y int) {
	canvas.layers[y][x] = false
}

pub fn (mut canvas Canvas) toggle(x int, y int) {
	canvas.layers[y][x] = !canvas.layers[y][x]
}

pub fn (mut canvas Canvas) clear() {
	width, height := canvas.size()
	canvas.layers = create_buffer(width, height)
}

pub fn (mut canvas Canvas) image(image stbi.Image) ! {
	width, height := canvas.size()
	length := width * height
	resized := stbi.resize_uint8(image, width, height)!
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

pub fn (canvas Canvas) str() string {
	return canvas.output().map(
		fn (row []rune) string {
			return row.map(
				fn (r rune) string {
					return r.str()
				}
			).join()
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

fn create_buffer(width int, height int) [][]bool {
 return [][]bool{len: height, init: []bool{len: width}}
}
