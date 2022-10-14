extends Node

onready var overworldMenu = $OverworldLayer/OverworldMenu

func _input(event):
	if event.is_action_pressed("debug"):
		print(WorldManager.find_distance(Vector2(3,2), Vector2(7,8)))
	elif event.is_action_pressed("version_info"):
		print(Main.version)
	pass

func _ready():
	overworldMenu.version = Main.version
	
func _unhandled_input(event):
#	if event is InputEventMouseButton:
#		$MenuUI/PanelContainer.release_focus()
	pass
