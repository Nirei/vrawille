import nirei.vrawille

/**
 * This example draws a five point star using canvas.line()
 */
fn main() {
  width, height := 49, 49
  mut canvas := vrawille.Canvas.new(width, height)

  canvas.line(10,5,24,48)
  canvas.line(10,5,46,33)
  canvas.line(2,33,38,5)
  canvas.line(2,33,46,33)
  canvas.line(24,48,38,5)
	
	println(canvas)
}