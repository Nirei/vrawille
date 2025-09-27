import nirei.vrawille
import stbi

fn draw_wolf() &vrawille.Canvas {
	width, height := 320, 180
  mut canvas := vrawille.Canvas.new(width, height)

	image := stbi.load("./spice-and-wolf.jpg", stbi.LoadParams{desired_channels: 1}) or { exit(1) }

	canvas.image(image) or { exit(1) }
	image.free()

	return canvas
}

fn main() {
  canvas := draw_wolf()

  output := canvas.output()
	for row in output {
		for character in row {
			print(character)
		}
		print('\n')
	}
}