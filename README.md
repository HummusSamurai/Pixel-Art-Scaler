# Pixel-Art-Scaler
A godot example project implementing several pixel art scaling methods

You can choose the following modes:

* Interger - Image is scaled up by a whole number to below the final window size, it should also be relatively easy to add a high resolution border using this setup
* Interger + Bilinear - First the image is scaled using the previous approach then it is scaled a second time to fill the screen using a bilinear shader, this is a common solution that solves distortion issues inherent to nearest-neighbour
* Nearest Neighbour - Similar to godot's default method, included for completeness sake

You can also choose Keep, Keep-Width and Keep-Height stretch modes.

Note that I'm not very experienced in godot and shader writing so there is probably room for improvement in this code.
