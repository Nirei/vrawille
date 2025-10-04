import nirei.vrawille

/**
 * Draws a five point star using `canvas.line()`
 * Maybe you'd like to star this repository? :^)
 */
fn main() {
  width, height := 47, 44
  mut canvas := vrawille.Canvas.new(width, height)

  p_1_x := 8
  p_1_y := 0

  p_2_x := 0
  p_2_y := 27

  p_3_x := 23
  p_3_y := 43

  p_4_x := 46
  p_4_y := 27

  p_5_x := 38
  p_5_y := 0

  canvas.line(p_1_x, p_1_y, p_3_x, p_3_y)
  canvas.line(p_1_x, p_1_y, p_4_x, p_4_y)
  canvas.line(p_2_x, p_2_y, p_5_x, p_5_y)
  canvas.line(p_2_x, p_2_y, p_4_x, p_4_y)
  canvas.line(p_3_x, p_3_y, p_5_x, p_5_y)
	
	println(*canvas)
}