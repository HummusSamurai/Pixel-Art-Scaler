extends Node

onready var viewSprite = get_node("ViewportSprite")
onready var viewPort = get_node("Viewport")

onready var textureFrame = get_node("BackBufferCopy/TextureFrame")
onready var textureFrameMat = textureFrame.get_material()

export (Vector2) var resolution
export(int, "keep", "keep-width", "keep-height", "expand") var stretch_mode = 0
export(int, "interger", "fill", "nearest-neighbour") var scaling_mode = 0

var current_scene = null

func _ready():
	update_view()
	get_tree().get_root().connect("size_changed", self, "update_view")


func update_view():
	
	var window_size = OS.get_window_size()
	
	if scaling_mode == 0:   # Interger Scaling Mode
		var sprite_scale = min(floor(window_size.x / resolution.x),floor(window_size.y / resolution.y))
		viewSprite.set_scale(Vector2(sprite_scale,sprite_scale))
		
		if stretch_mode == 0: # Keep
			viewPort.set_rect(Rect2(Vector2(),resolution))
		elif stretch_mode == 1: # Keep Width
			var c = window_size/sprite_scale + Vector2(2,2)
			viewPort.set_rect(Rect2(Vector2(),Vector2(resolution.x,ceil(c.y))))
		elif stretch_mode == 2: # Keep Height
			var c = window_size/sprite_scale + Vector2(2,2)
			viewPort.set_rect(Rect2(Vector2(),Vector2(ceil(c.x),resolution.y)))
		elif stretch_mode == 3: # Expand
			var c = window_size/sprite_scale + Vector2(2,2)
			viewPort.set_rect(Rect2(Vector2(),Vector2(ceil(c.x),ceil(c.y))))
		
		textureFrame.hide()

	elif scaling_mode == 1: # Fill (interger + bilinear) scaling mode
		var sprite_scale = min(floor(window_size.x / resolution.x),floor(window_size.y / resolution.y))
		viewSprite.set_scale(Vector2(sprite_scale,sprite_scale))
		
		textureFrame.show()
		textureFrame.set_pos(Vector2(-window_size.x/2,-window_size.y/2))
		textureFrame.set_size(window_size )
		
		var z = 1
		
		if stretch_mode == 0 or stretch_mode == 3	: # Keep
			viewPort.set_rect(Rect2(Vector2(),resolution))
			
			var ratio = (resolution * sprite_scale + Vector2(0,-1)) / window_size
			z = max(ratio.x,ratio.y)
		elif stretch_mode == 1: # Keep Width
			var r = window_size.y/window_size.x
			
			viewPort.set_rect(Rect2(Vector2(),Vector2(resolution.x + 2,resolution.x * r + 2)))
			var ratio = (resolution * sprite_scale + Vector2(0,-1)) / window_size
			z = ratio.x
			
		elif stretch_mode == 2: # Keep Height
			var r = window_size.x/window_size.y
			
			viewPort.set_rect(Rect2(Vector2(),Vector2(resolution.y * r + 2,resolution.y + 2)))
			
			var ratio = (resolution * sprite_scale) / window_size
			z = ratio.y
		
		textureFrameMat.set_shader_param("Zoom",z)
		textureFrameMat.set_shader_param("Screen_Size",window_size)
	
	elif scaling_mode == 2:  # Nearest neighbour
		textureFrame.hide()
		
		var sprite_scale = min(window_size.x / resolution.x,window_size.y / resolution.y)
		viewSprite.set_scale(Vector2(sprite_scale,sprite_scale))
		
		if stretch_mode == 0: # Keep
			viewPort.set_rect(Rect2(Vector2(),resolution))
		elif stretch_mode == 1: # Keep Width
			var c = window_size/sprite_scale + Vector2(2,2)
			viewPort.set_rect(Rect2(Vector2(),Vector2(resolution.x,ceil(c.y))))
		elif stretch_mode == 2: # Keep Height
			var c = window_size/sprite_scale + Vector2(2,2)
			viewPort.set_rect(Rect2(Vector2(),Vector2(ceil(c.x),resolution.y)))
		elif stretch_mode == 3: # Expand
			var c = window_size/sprite_scale + Vector2(2,2)
			viewPort.set_rect(Rect2(Vector2(),Vector2(ceil(c.x),ceil(c.y))))