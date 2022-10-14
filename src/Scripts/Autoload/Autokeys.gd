extends Node

var ui_hidden = false

func _input(event):
	if event.is_action_pressed("hideUI_f"):
		if ui_hidden == false:
			for member in get_tree().get_nodes_in_group("ui"):
				member.visible = false
			ui_hidden = true
		else:
			for member in get_tree().get_nodes_in_group("ui"):
				member.visible = true
			ui_hidden = false
