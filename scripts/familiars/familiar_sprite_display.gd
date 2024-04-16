class_name FamiliarSpriteDisplay
extends Sprite2D

@export var Familiar_sprite_resource : FamiliarSpriteResource
@export var frame_time = 0.1
var time = 0
var _play : bool = true

func set_familiar_sprite(sprite_resource: FamiliarSpriteResource):
	Familiar_sprite_resource = sprite_resource
	display_sprite()
	
func display_sprite():
	texture = Familiar_sprite_resource.sprite_texture
	hframes = Familiar_sprite_resource.horizontal_frames
	vframes = Familiar_sprite_resource.vertical_frames

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if texture == null:
		return
	if !play:
		return
	
	time += delta
	
	if time < frame_time:
		return
	
	if frame >= hframes - 1:
		frame = 0
	else:
		frame += 1
	
	time = 0
	

func play():
	_play = true
	
func stop():
	_play = false
