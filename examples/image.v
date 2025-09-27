import nirei.vrawille
import stbi

fn main() {
	width, height := 320, 180
  mut canvas := vrawille.Canvas.new(width, height)

	image := stbi.load("examples/spice-and-wolf.jpg", stbi.LoadParams{desired_channels: 1}) or { exit(1) }

	canvas.image(image) or { exit(1) }
	image.free()

  println(*canvas)
}