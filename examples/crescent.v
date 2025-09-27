import nirei.vrawille

fn draw_crescent() &Canvas {
  width, height := 48, 48
  mut canvas := vrawille.Canvas.new(width, height)

  minr := 16*16
  maxr := 20*20
	for y:=0; y<height; y+=1 {
		for x:=0; x<width; x+=1 {
      cy := y - 24
      big_cx := x - 20
      small_cx := x - 16
      big := (big_cx*big_cx) + (cy*cy)
      small := (small_cx*small_cx) + (cy*cy)
      if small > minr && big < maxr {
        canvas.set(x, y)
      }
		}
	}

	return canvas
}

fn main() {
  canvas := draw_crescent()

  output := canvas.output()
	for row in output {
		for character in row {
			print(character)
		}
		print('\n')
	}
}