import nirei.vrawille
import stbi

/**
 * Draws Holo from the show Spice and Wolf using `canvas.image()`
 * Image "Holo's Gaze" by Arata Lab is licensed under CC BY NC ND 3.0
 * https://www.deviantart.com/aratalab/art/Holo-s-Gaze-1154580455
 */
fn main() {
	width, height := 320, 180
  mut canvas := vrawille.Canvas.new(width, height)

	image := stbi.load("examples/spice-and-wolf.jpg", stbi.LoadParams{desired_channels: 1}) or { exit(1) }

	canvas.image(image) or { exit(1) }
	image.free()

  println(*canvas)
}