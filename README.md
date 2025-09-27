Vrawille is a free software V library for drawing in the terminal using Braille
characters. It's inspired in similar libraries in other languages like
[drawille](https://github.com/asciimoo/drawille) but it's a complete rewrite
from scratch.

```
⠀⠀⠀⠀⠀⣀⣤⣶⣶⣶⣶⣶⣶⣦⣄⡀⠀⠀⠀⠀
⠀⠀⢀⡴⠞⠋⠉⠉⠈⠉⠉⠛⠿⣿⣿⣿⣶⣄⠀⠀
⠀⠠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣦⠀
⠠⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣧
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿
⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⡿
⠀⠡⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⡿⠁
⠀⠀⠘⢦⣄⡀⠀⠀⠀⠀⠀⣀⣤⣾⣿⣿⣿⠟⠀⠀
⠀⠀⠀⠀⠈⠛⠿⣿⣾⣿⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀
```

## Installation

The easiest way to get vrawille is using vpm:

```bash
vpm install Nirei.vrawille
```

## Usage

The API is simple:

```v
// Create a Canvas struct
width, height := 48, 48
mut canvas := vrawille.Canvas.new(width, height)

// Set some pixels
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

// Draw your canvas
println(canvas)
```

The preceding code should produce this result:

```
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢄⠀⡠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠛⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
```