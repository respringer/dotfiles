#!/usr/bin/env python3

import sys

from colorsys import hsv_to_rgb
from shutil import get_terminal_size

block = '█'

fg = '\033[38;2;{r};{g};{b}m'
fg_norm = '\033[39m'

def print_rainbow(saturation=1.):
	cols, lines = get_terminal_size()
	lines -= 1
	
	for lightness in range(lines):
		lightness /= lines - 1
		for hue in range(cols):
			hue /= cols - 1
			
			rgb = hsv_to_rgb(hue, saturation, lightness)
			r, g, b = [int(c*255) for c in rgb]
			print(fg.format(r=r, g=g, b=b), end=block)
		print(fg_norm)

if __name__ == '__main__':
	saturation = 1.
	if len(sys.argv) > 1:
		saturation = float(sys.argv[1])
	print_rainbow(saturation)
