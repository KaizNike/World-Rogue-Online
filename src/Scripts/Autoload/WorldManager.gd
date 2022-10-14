extends Node

#var polarHeatMap = preload("res://src/Resources/PolarHeatMap.tscn").instance()
#var heatImage

export (float) var heat = 0
var heat_variation = 0.045
var height_variation = 0.015
var tiles_count  = 0

var rng = RandomNumberGenerator.new()

onready var noise_height = OpenSimplexNoise.new()
onready var forest_noise = OpenSimplexNoise.new()
onready var land_noise = OpenSimplexNoise.new()
onready var variation_noise = OpenSimplexNoise.new()
onready var river_noise = OpenSimplexNoise.new()

var heatSelect = "polar"
var heatChange = 0
var heightChange = 0

var OCEANTILES = [4, 5, 6, 7]
var RIVERSTARTTILES = [2, 3]
var CHILLTILES = [2, 12, 13, 14, 15]
var CENTRALTILES = [16, 17]
var MIDTILES = [0, 1, 3, 9, 10, 20, 21, 22]

var TILES = {
	"grass" : 0,
	"dirt" : 1,
	"mountain" : 2,
	"hill" : 3,
	"shallowwater" : 4,
	"medwater" : 5,
	"deepwater" : 6,
	"abyssalwater" : 7,
	"swamp" : 8,
	"brushland" : 9,
	"forest" : 10,
	"deepforest" : 11,
	"snow" : 12,
	"ice" : 13,
	"tundra" : 14,
	"tundraforest" : 15,
	"desert" : 16,
	"desertforest" : 17,
	"dryhills" : 18,
	"tundradeepforest" : 19,
	"lushgrass" : 20,
	"lushbrushland" : 21,
	"jungle" : 22,
	"deepjungle" : 23
}

var LOCATIONS = {
	"cave" : 0,
	"camp" : 1,
	"settlement" : 2,
	"town" : 3,
	"temple" : 4
}

var HUMANS = {
	"ffarlander" : 0,
	"nmidlander" : 1,
	"mmidlanderknight" : 2,
	"mcentral" : 3,
	"fcentralknight" : 4
}

var MONSTERS = {
	"blobkin" : 5,
	"forestslime" : 6,
	"goblinwarrior" : 9,
	"goblinmage" : 10,
	"zombiehuman" : 11,
	"zombiegoblin" : 12
}

var ANIMALS = {
	"smallfish" : 7,
	"largefish" : 8,
	"fox" : 13,
	"snowrabbit" : 14,
	"bear" : 15,
	"bee" : 16
}

func _ready():
	randomize()
	rng.randomize()
	_noise_height_init()
	_forest_noise_init()
	_land_noise_init()
	_variation_noise_init()
	_river_noise_init()
#	heatImage = polarHeatMap.get_texture().get_data()
#	print(heatImage)
	pass

func _noise_height_init():
	noise_height.seed = randi()
	noise_height.octaves = 5
	noise_height.period = 80.0
	noise_height.persistence = 0.3
	noise_height.lacunarity = 0.2

func _forest_noise_init():
	forest_noise.seed = randi()
	forest_noise.octaves = 9
	forest_noise.period = 19.0
	forest_noise.persistence = 0.2
	forest_noise.lacunarity = 2

func _land_noise_init():
	land_noise.seed = randi()
	land_noise.octaves = 9
	land_noise.period = 19.0
	land_noise.persistence = 0.2
	land_noise.lacunarity = 2
	
func _variation_noise_init():
	variation_noise.seed = randi()
	variation_noise.octaves = 9
	variation_noise.period = 3
	variation_noise.persistence = 0.2
	variation_noise.lacunarity = 2

func _river_noise_init():
	river_noise.seed = randi()
	river_noise.octaves = 1
	river_noise.period = 5
	river_noise.persistence = 1
	river_noise.lacunarity = 4

func reseed():
	noise_height.seed = randi()
	land_noise.seed = randi()
	forest_noise.seed = randi()
	variation_noise.seed = randi()

func genWorld(size, type, temp, height, isRound):
	heatChange = temp / 100
	heightChange = height / 100
	print(heatChange)
	var array = _create_square2d_array(size)
	tiles_count = 0
#	var heatImage
#	do stuff to array
	if type == "overworld":
		print("Generate overworld now!")
#		if heatSelect == "polar":
##			polarHeatMap.rect_size = Vector2(size, size)
##			polarHeatMap.rect_position.x = size
#			polarHeatMap.Gradient.width = size
##			print(polarHeatMap.rect_size)
#			heatImage = polarHeatMap.get_texture().get_data()
#			print(heatImage.get_size())
#			heatImage.lock()
#			print(heatImage.get_pixel(200, 0))
		for y in range(size):
			if heatSelect == "polar":
#				heat += 1
				if y < (size / 2):
					heat += 1.0 / float(size) * 2.0
				elif y > (size / 2):
					heat -= 1.0 / float(size) * 2.0
				if y % 10 == 0:
#					print(float(heat))
					pass
			for x in range(size):
				var heat_cell = heat + heatChange + (0.05* variation_noise.get_noise_2d(float(x), float(y))) # + rand_range(-heat_variation, heat_variation) 
				if not on_circle(x, y, size) and isRound:
					continue
				tiles_count += 1
				var cell = noise_height.get_noise_2d(float(x), float(y)) + heightChange + (0.05 * variation_noise.get_noise_2d(float(x), float(y))) #  + rand_range(-height_variation, height_variation)
				if cell < -0.1:
					if heat_cell < 0.15:
						array[y][x] = TILES.ice
					else:
						if cell < -0.55:
							array[y][x] = TILES.abyssalwater
						elif cell < -0.4:
							array[y][x] = TILES.deepwater
						elif cell < -0.25:
							array[y][x] = TILES.medwater
						else:
							array[y][x] = TILES.shallowwater
				elif cell > 0.5:
					array[y][x] = TILES.mountain
				elif cell > 0.4:
					if heat_cell < 0.3 or heat_cell > 0.85:
						array[y][x] = TILES.dryhills
					else:
						array[y][x] = TILES.hill
				else:
					var cell_forest = forest_noise.get_noise_2d(float(x), float(y))
					if cell_forest > 0.3 and heat_cell > 0.15:
						if heat_cell > 0.15 and heat_cell < 0.3:
							if cell_forest > 0.5:
								array[y][x] = TILES.tundradeepforest
							elif cell_forest > 0.3:
								array[y][x] = TILES.tundraforest
						elif heat_cell > 0.6 and heat_cell < 0.85:
							if cell_forest > 0.5:
								array[y][x] = TILES.deepjungle
							elif cell_forest > 0.4:
								array[y][x] = TILES.jungle
							elif cell_forest > 0.3:
								array[y][x] = TILES.lushbrushland
						elif heat_cell > 0.85:
#							if cell_forest > 0.3:
							array[y][x] = TILES.desertforest
						else:
							if cell_forest > 0.5:
								array[y][x] = TILES.deepforest
							elif cell_forest > 0.4:
								array[y][x] = TILES.forest
							elif cell_forest > 0.3:
								array[y][x] = TILES.brushland
					else:
						var cell_land = land_noise.get_noise_2d(float(x), float(y))
						if heat_cell < 0.15:
							array[y][x] = TILES.snow
						elif heat_cell > 0.85:
							array[y][x] = TILES.desert
						else:
							if cell_land < -0.25:
								array[y][x] = TILES.swamp
							elif cell_land < -0.1:
								array[y][x] = TILES.dirt
							else:
								if heat_cell > 0.6 and heat_cell < 0.85:
									array[y][x] = TILES.lushgrass
								elif heat_cell > 0.15 and heat_cell < 0.3:
									array[y][x] = TILES.tundra
								else:
									array[y][x] = TILES.grass
#				pass
	elif type == "aboveworld":
		print("Lets make aboveworld!")
	elif type == "underworld":
		print("Now for under world!")
	elif type == "warpworld":
		print("nOw lEts gEt wAckY!")
#	heatImage.unlock()
	return array


func genLocations(array, type, isRound):
	var size = len(array)
	var result = _create_square2d_array(size)
#	print(size)
	if type == "overworld":
		print("Genning overworld locations.")
		var caves = (size * size) / 1000
		for y in len(array):
			for x in len(array):
				if result[y][x] != null:
					continue
				if array[y][x] != null:
					if array[y][x] in OCEANTILES:
						continue
					else:
						var Rand = rand_range(-1, 1)
#						print(Rand)
						if Rand > 0.995:
							result[y][x] = LOCATIONS.cave
#							print("location added")
#							caves -= 1
							tiles_count += 1
						elif Rand < -0.997:
							var wealth = rng.randi_range(20, 25000)
							var anythingPlaced = false
							if isRound and on_circle(x,y,size-5):
								continue
							elif not isRound:
								if x < 5 or x > size - 5 or y < 5 or y > size - 5:
									continue
							while (wealth > 0):
								if wealth < 200 and !anythingPlaced:
									result[y][x] = LOCATIONS.camp
									wealth = 0
								elif wealth > 2200:
									anythingPlaced = true
									result[y][x] = LOCATIONS.temple
									wealth - 800
#									var Drange = 1
#									var displace = 1
#									while (wealth > 0):
#										var location = Vector2(0,0)
#										match displace:
#											1:
#												location.x = 0
#												location.y = -1 * Drange
#											2:
#												location.x = 0
#												location.y = 1 * Drange
#											3:
#												location.y = 0
#												location.x = -1 * Drange
#											4:
#												location.y = 0
#												location.x = 1 * Drange
#											5:
#												location.x = 1 * Drange
#												location.y = 1 * Drange
#											6:
#												location.x = 1 * Drange
#												location.y = -1 * Drange
#											7:
#												location.x = -1 * Drange
#												location.y = 1 * Drange
#											8:
#												location.x = -1 * Drange
#												location.y = -1 * Drange
#												Drange += 1
#												displace = 0
#
#										displace += 1
#										var Y = y + location.y
#										var X = x + location.x
#										if wealth > 2000:
#											result[Y][X] = LOCATIONS.town
#											wealth -= 500
#										elif wealth > 200:
#											result[Y][X] = LOCATIONS.settlement
#											wealth -= 200
#										else:
#											wealth = 0
									if wealth > 500 and result[y-1][x] == null and array[y-1][x] != null:
										result[y-1][x] = LOCATIONS.town
										wealth -= 500
									if wealth > 200 and result[y+1][x] == null and array[y+1][x] != null:
										result[y+1][x] = LOCATIONS.settlement
										wealth -= 200
									if wealth > 200 and result[y][x-1] == null and array[y][x-1] != null:
										result[y][x-1] = LOCATIONS.settlement
										wealth -= 200
									if wealth > 200 and result[y][x+1] == null and array[y][x+1] != null:
										result[y][x+1] = LOCATIONS.settlement
										wealth -= 200
									wealth = 0
									continue
								elif wealth > 600:
									anythingPlaced = true
									result[y][x] = LOCATIONS.town
									wealth = 0
								elif wealth > 200:
									anythingPlaced = true
									result[y][x] = LOCATIONS.settlement
									wealth = 0
								wealth = 0
								pass
#		generate_rivers(array)
		return result
#		print(result)

#func generate_rivers(array):
#	for y in len(array):
#		for x in len(array):
#			if array[y][x] == null:
#				continue
#			elif array[y][x] in HEIGHTTILES:
#				var cell = river_noise.get_noise_2d(float(x), float(y)) + noise_height.get_noise_2d(float(x), float(y))
#				var heightLast = noise_height.get_noise_2d(float(x), float(y)) + heightChange + (0.05 * variation_noise.get_noise_2d(float(x), float(y)))
#				if cell > 0.86:
#					while(true):
#						# subtract heightCurrent - HeightLast to find biggest negative number
#						var dir = Vector2(0,0)
#						var dirName = ""
#						var difference = 0
#						var differenceNext = 0
#						var heightLast = 0
#						for next in range(4):
#							match next:
#								0:
#									dirName = "up"
##									dir = Vector2(1,0)
#									difference = noise_height.get_noise_2d(float(x), float(y+1)) + heightChange + (0.05 * variation_noise.get_noise_2d(float(x), float(y+1))) - heightLast
#								1:
#
#									pass
#							pass
#						pass
#					pass
##					print(cell)	
##					var dir = Vector2(rand_three(),rand_three())
##
##					while (dir == Vector2(0,0)):
##						dir = Vector2(rand_three(), rand_three())
#				pass
#
#	return array
##	pass

func generate_characters(worldArray, locArray):
	var size = len(worldArray)
	var result = _create_square2d_array(size)
	for y in len(worldArray):
		for x in len(worldArray):
			var R = randf()
#			print(R)
			if R > 0.995:
				if worldArray[y][x] == null:
					continue
				if worldArray[y][x] in OCEANTILES:
					continue
				if locArray[y][x] != null:
					continue
#				print("Made it")
				if worldArray[y][x] in CENTRALTILES:
					R = randf()
					if R > 0.5:
						result[y][x] = HUMANS.fcentralknight
					else:
						result[y][x] = HUMANS.mcentral
				elif worldArray[y][x] in MIDTILES:
					R = randf()
					if R > 0.5:
						result[y][x] = HUMANS.mmidlanderknight
					else:
						result[y][x] = HUMANS.nmidlander
				elif worldArray[y][x] in CHILLTILES:
					result[y][x] = HUMANS.ffarlander
					
			elif R < 0.017:
				if worldArray[y][x] == 8:
					R = randf()
					if R > 0.5:
						result[y][x] = MONSTERS.zombiehuman
					else:
						result[y][x] = MONSTERS.zombiegoblin
				if worldArray[y][x] in OCEANTILES:
					R = randf()
					if R > 0.2:
						result[y][x] = ANIMALS.smallfish
					else:
						result[y][x] = ANIMALS.largefish
	#				continue
				elif worldArray[y][x] in CHILLTILES:
					result[y][x] = ANIMALS.snowrabbit
				elif worldArray[y][x] in MIDTILES:
					R = randf()
					if R > 0.4:
						R = randf()
						if R > 0.9:
							result[y][x] = ANIMALS.bear
						elif R > 0.8: 
							result[y][x] = ANIMALS.fox
						else:
							result[y][x] = ANIMALS.bee
					else:
						R = randf()
						if R > 0.4:
							R = randf()
							if R > 0.49:
								result[y][x] = MONSTERS.goblinwarrior
							else:
								result[y][x] = MONSTERS.goblinmage
						else:
							R = randf()
							if R < 0.2:
								result[y][x] = MONSTERS.blobkin
							else:
								result[y][x] = MONSTERS.forestslime
	return result
#				pass

func rand_three():
	var result = rand_range(-1,1)
	if result < -0.49:
		return -1
	elif result > 0.49:
		return 1
	else:
		return 0

func _create_2d_array(width, height, value):
	var a = []

	for y in range(height):
		a.append([])
		a[y].resize(width)

		for x in range(width):
			a[y][x] = value

	return a
	
func _create_square2d_array(size):
	var a = []
#	var noise_height_image = noise_height.get_image(size, size)
	for y in range(size):
		a.append([])
		a[y].resize(size)
		
		for x in range(size):
			a[y][x] = null
#			var cell = noise_height.get_noise_2d(float(x), float(y))
#			print(noise_height_image.get_pixel(x, y))
#			if cell < -0.1:
#				a[y][x] = type2
#			elif cell > -0.1:
#				a[y][x] = type
#			if x % 2:
#				a[y][x] = type2
#			else:
#				a[y][x] = type
#			a[y][x] = type
			
	return a
	
func on_circle(xpos, ypos, Size):
	if Size / 2 > sqrt(abs(xpos - Size / 2) * abs(xpos - Size / 2) + abs(ypos - Size / 2) * abs(ypos - Size / 2)):
		return true
	else:
		return false


func find_distance(pos: Vector2, loc: Vector2):
	var x = (loc.x - pos.x) * (loc.x - pos.x)
	var y = (loc.y - pos.y) * (loc.y - pos.y)
	var result = sqrt(float(x) + float(y))
	return result
#	pass
