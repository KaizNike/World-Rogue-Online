extends Camera2D

var speed = Vector2(20,20)

onready var overworld = self.get_parent().get_node("OverworldLayer/OverworldMenu")


# Called when the node enters the scene tree for the first time.
func _ready():
	overworld.connect("center", self, "center")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var dir = _get_dir()
	self.position += dir * speed
	pass
	
	
func _get_dir():
	return Vector2(Input.get_action_strength("move_right")-Input.get_action_strength("move_left"), Input.get_action_strength("move_down")-Input.get_action_strength("move_up"))

func _input(event):
	if event.is_action_released("scroll_up"):
		zoom *= 0.8
		speed *= 0.8
	elif event.is_action_pressed("scroll_down"):
		zoom *= 1.2
		speed *= 1.2
		
func center():
#	print(overworld)
	var Size = overworld.Size / 2
	position = overworld.map_to_world(Vector2(Size, Size))
	pass
