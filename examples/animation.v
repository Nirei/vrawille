module main

import math { sin }
import term.ui as tui
import nirei.vrawille { Canvas }

struct App {
mut:
  tui &tui.Context = unsafe { nil }
  frame int
}

fn event(e &tui.Event, x voidptr) {
  if e.typ == .key_down && e.code == .escape {
    exit(0)
  }
}

fn frame(x voidptr) {
  mut app := unsafe { &App(x) }

  mut canvas := vrawille.Canvas.new(40, 24)
  for w in 0..40 {
    a := 12 * sin(math.tau * f64(app.frame) / 40)
    y := 12 + int(a * sin(f64(app.frame)/3 + w * 120 / math.tau))
    canvas.set(w, y-1)
    canvas.set(w, y)
    canvas.set(w, y+1)
  }

  app.tui.clear()
  app.tui.set_bg_color(r: 63, g: 81, b: 181)
  rows := canvas.rows()
  for index in 0..rows.len {
    text := rows[index].map(
				fn (r rune) string {
					return r.str()
				}
			).join('')
    app.tui.draw_text(20, 6+index, text)
  }
  app.tui.set_cursor_position(0, 0)

  app.tui.reset()
  app.tui.flush()
  app.frame += 1
}

/**
 * Draws an animated sine wave
 */
fn main() {
  mut app := &App{}
  app.tui = tui.init(
    user_data:   app
    event_fn:    event
    frame_fn:    frame
    hide_cursor: true
  )
  app.tui.run()!
}