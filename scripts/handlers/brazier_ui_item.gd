extends Node

var item_id:Enums.ItemId
var quantity:int
@export var label:Label
@export var texture_rect:TextureRect
signal item_clicked(item_id:int)


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", _on_button_pressed)

func _on_button_pressed():
	emit_signal("item_clicked", item_id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize_item(item:ItemResource)->void:
	label.text = item.name+" ("+str(quantity)+")"
	texture_rect.texture = item.icon
	
