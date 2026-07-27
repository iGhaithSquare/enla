# ENLA (Export NES-Like Assembly)
ENLA is an aseprite extension that allows you to export your indexed sprite into a compact assembly format inspired by the NES.
## Primary usage
I made this for usage in making small sized pixel art games, where I want my graphics to take as little storage as possible.
The exported data can be directly included in an assembly project, and it is easily uploadable to a shader.
## Format
Exports 8 by 8,2 bit (including transparent pixels) sprites from an indexed spritesheet.

### Palettes

First 48 bytes contain 4 color palettes made up of 3 colors and transparency.
Note: currently only the first color palette is taken from the file, so make sure the colors used are from the first 4 colors.
Each pixel uses 2 bit
00 - transparent
01 - color 1
10 - color 2
11 - color 3

### Sprites

The bytes after the palettes data contain the sprites.

Each sprite byte contains 4 pixels
bits 0 and 1 - top left pixel
bits 2 and 3 - top right pixel
bits 4 and 5 - bottom left pixel
bits 6 and 7 - bottom right pixel

## Todo

Add the ability to include the 3 other 3 colored palettes, without the need to edit the assembly file.