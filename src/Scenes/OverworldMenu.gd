extends TileMap

var version = []

#var TILES = {
#	"grass" : 0,
#	"dirt" : 1,
#	"mountain" : 2,
#	"hill" : 3,
#	"shallowwater" : 4,
#	"medwater" : 5,
#	"deepwater" : 6,
#	"abyssalwater" : 7
#}

signal center

onready var progressBar = self.get_parent().get_parent().get_node("GenerationProgress/GenerationProgress/PanelContainer/VSplitContainer/ProgressBar")
onready var menu = self.get_parent().get_parent().get_node("MenuUI")

var generating = false
var wait = false
var to_first_gen = false
var halt_generation = false

var save_vars = ["version", "noise_height_seed", "forest_noise_seed", "land_noise_seed", "variation_noise_seed", "isRound", "temp", "height", "size"]
var save_loc_test = "res://saves/menuOW.tres"
var Save_loc = "user://saves/menuOW.tres"

# size - 60 to 3500
export var Size = 250
var HeightChange = 0
var TempChange = 0
var IsRound = true
export (Resource) var tileMapSave
export (Script) var game_save_class

func _ready():
#	print(OS.get_system_time_msecs())
	to_first_gen = true
	pass

func _physics_process(delta):
	if generating == false and to_first_gen == true:
		if not load_world(Save_loc):
			print("no world :(")
#		generating = true
		to_first_gen = false
		yield(get_tree(), "idle_frame")
		prepare_generation(Size, TempChange, HeightChange, IsRound)
#	position += Vector2(1, 0)
	pass

func prepare_generation(size, temp, height, isRound):
#	progressBar.max_value = WorldManager.tiles_count
#	$TimeSpentO.start()
	save_world(Save_loc, size, temp, height, isRound, version)
#	generating = true
	emit_signal("center")
	generate(size, temp, height, isRound)

#func _process(delta):
#	pass
		
func generate(size, temp, height, isRound):
	clear()
	generating = true
	var array = WorldManager.genWorld(size, "overworld", temp, height, isRound)
	var arrayLoc = WorldManager.genLocations(array, "overworld", isRound)
	var arrayChar = WorldManager.generate_characters(array, arrayLoc)
	$OWLocation.generate(arrayLoc)
	$OWCharacters.generate(arrayChar)
	progressBar.max_value = WorldManager.tiles_count#	
#	for y in array:
#		for x in y:
#			if x != null:
#				print(x)
	for y in len(array):
		yield(get_tree(), "idle_frame")
		for x in len(array[y]):
			if halt_generation == true:
				print("Generation halted.")
				generating = false
				halt_generation = false
				yield(get_tree(), "idle_frame")
				return 1
#			yield(get_tree(), "idle_frame")
#			if wait:
#				yield(get_tree(), "idle_frame")
##				OS.delay_usec(15)
#				wait = false
			if array[y][x] != null:
				set_cellv(Vector2(x,y), array[y][x])
#				print(array[y][x])
#				if array[y][x] == "grass":
#					set_cellv(Vector2(x, y), TILES.abyssalwater)
#				elif array[y][x] == "dirt":
#					set_cellv(Vector2(x, y), 1)
				incrementProgress()
	generating = false
	return 0

func regen(temp, height, newSize, isRound, boole):
	if generating == true:
		halt_generation = true
		return
		
#	clear()
	progressBar.value = 0
	if boole:
		WorldManager.reseed()
		Size = newSize
		TempChange = temp
		HeightChange = height
	prepare_generation(newSize, temp, height, isRound)


#func _on_Timer_timeout():
#	if generating == false:
#		generating = true
#		prepare_generation(Size)
#	pass # Replace with function body.


#func _on_TimeSpentO_timeout():
#	wait = true
#	pass # Replace with function body.


## Save functions

func verify_save(world_save):
	for v in save_vars:
		var inside = world_save.get(v)
		print(v)
		print(inside)
		if v == "version" and inside == null:
			IsRound = true
			continue
		if inside == null:
			return false
		if v == "size" and (inside < 60 or inside > 1500):
			return false
	return true
#	pass
	
func load_world(loc):
	var dir = Directory.new()
	if not dir.file_exists(loc):
		return false
	
	var world_save = load(loc)
	if not verify_save(world_save):
		print("verify failed")
		return false
		
	WorldManager.noise_height.seed = world_save.noise_height_seed
	WorldManager.forest_noise.seed = world_save.forest_noise_seed
	WorldManager.land_noise.seed = world_save.land_noise_seed
	WorldManager.variation_noise.seed = world_save.variation_noise_seed
	TempChange = world_save.temp
	HeightChange = world_save.height
	Size = world_save.size
	menu.load_menu_ui(TempChange, HeightChange, Size)
#	Work done
	return true
	
func save_world(save, size, temp, height, isRound, version):
	var new_save = game_save_class.new()
	new_save.version = version
	new_save.noise_height_seed = WorldManager.noise_height.seed
	new_save.forest_noise_seed = WorldManager.forest_noise.seed
	new_save.land_noise_seed = WorldManager.land_noise.seed
	new_save.variation_noise_seed = WorldManager.variation_noise.seed
	new_save.isRound = IsRound
	new_save.temp = temp
	new_save.height = height
	new_save.size = size
	var dir = Directory.new()
	if not dir.dir_exists("user://saves"):
		dir.make_dir_recursive("user://saves")
	
	var error = ResourceSaver.save(save, new_save)
	if error != 0:
		print("Error saving!")
		print(error)
#	pass

func export_world():
#	var dir = Directory.new()
#	if not dir.file_exists("user://exports/OverWorld.tres"):
#		pass
		# SAVE RESOURCE
		
	var scene = PackedScene.new()
	$OWLocation.set_owner(self)
	$OWCharacters.set_owner(self)
	scene.pack(self)
	var dir = Directory.new()
	if not dir.dir_exists("user://exports"):
		dir.make_dir_recursive("user://exports")
	var error = ResourceSaver.save("user://exports/world" + str(OS.get_system_time_msecs()) + ".tscn", scene)


func save_to_file():
	var loc = "user://saves/world" + str(OS.get_system_time_msecs()) + ".tres"
	save_world(loc, Size, TempChange, HeightChange, IsRound, version)
	pass

func load_from_file(code):
	var result = "user://saves/world" + str(code) + ".tres"
	if !load_world(result):
		print("File not found " + result)
	regen(TempChange, HeightChange, Size, IsRound, false)
	
func export_to_file():
	export_world()
	
func incrementProgress():
	progressBar.value += 1
