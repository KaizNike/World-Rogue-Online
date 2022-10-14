extends Node2D

var tile = 8
var Speed = 15

func _ready():
	add_to_group("acting")
	pass

func _physics_process(delta):
	var dir = Vector2.ZERO
	dir = _get_direction()
#	position += dir
	if dir != Vector2.ZERO:
		position += dir * tile
	pass

func process_movement(dir):
	if Main.turn:
		if _find_interaction():
			return
		elif _find_enemy():
			return
	
func _get_direction():
	return Vector2(Input.get_action_strength("move_right")-Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	
	

func _find_interaction():
	return false


func _find_enemy():
	return false
