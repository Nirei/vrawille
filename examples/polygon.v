import nirei.vrawille

/**
 * Draws an heptagon X through `canvas.polygon()`
 */
fn main() {
  width, height := 80, 60
  mut canvas := vrawille.Canvas.new(width, height)

	canvas.polygon(30,30,7,50,3.1416/2)
	
	println(*canvas)
}