class_name ActionButton
extends Button

var lbl
signal action_description(string:String)
signal action_pressed(action:ActionResource)
var _action: ActionResource

func set_up_action(action : ActionResource):
	lbl = get_child(0)
	lbl.text = action.name
	_action = action
	mouse_entered.connect(emit_action_description)
	button_up.connect(emit_action_pressed)
	
func emit_action_description():
	action_description.emit(_action.description)

func emit_action_pressed():
	action_pressed.emit(_action)
