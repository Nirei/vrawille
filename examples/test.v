import nirei.vrawille

fn main() {
  width, height := 48, 48
  mut canvas := vrawille.Canvas.new(width, height)

	canvas.set(22,22)
	canvas.set(23,23)
	canvas.set(24,24)
	canvas.set(25,25)
	canvas.set(26,26)
	canvas.set(27,27)

	canvas.set(27,22)
	canvas.set(26,23)
	canvas.set(25,24)
	canvas.set(24,25)
	canvas.set(23,26)
	canvas.set(22,27)
	
	println(*canvas)
}