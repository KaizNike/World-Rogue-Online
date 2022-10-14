extends PopupPanel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	gen_history()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HistoryButton_pressed():
	popup()
	pass # Replace with function body.


func gen_history():
	var start = "In the beginning, "
	var shaping = ""
	var R = randf()
#	if R > 0.66:
#		shaping = "the world was formed by "
#	elif R > 0.33:
#		shaping = "those known to shape this world were "
#	else:
#		shaping = "responsible for crafting the world was "
#	R = randf()
	var shaper = ""
	var shaperType = ""
	if R > 0.9:
		shaper = "the Force of Crafting, Azilmuth."
		shaperType = "force"
	elif R > 0.8:
		shaper = "the Keepers of Destiny, Lors."
		shaperType = "mult"
	elif R > 0.7:
		shaper = "the Eternal Bear, Kruggs."
		shaperType = "single"
	elif R > 0.6:
		shaper = "the one simply known as, Shaper."
		shaperType = "single"
	elif R > 0.5:
		shaper = "accidential circumstance."
		shaperType = "force"
	else:
		shaper = "itself."
		shaperType = "force"
		
	if shaperType == "force":
		shaping = "the world was formed by "
	elif shaperType == "mult":
		shaping = "those known to shape this world were "
	elif shaperType == "single":
		shaping = "responsible for crafting the world was "
		
	var beginningText = start + shaping + shaper
#	finished story crafting
	$HistoryText.text = beginningText
	
	
func load_history(text):
	$HistoryText.text = text
