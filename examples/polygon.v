import nirei.vrawille

/**
 * Draws an heptagon X through `canvas.polygon()`
 */
fn main() {
  width, height := 80, 60
  mut canvas := vrawille.Canvas.new(width, height)

	canvas.polygon(1,1,7,50)
	
	println(*canvas)
}