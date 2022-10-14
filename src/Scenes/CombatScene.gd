extends Node

var sceneLen = 60
var tilesize = 8
onready var tiles = $SceneTiles
onready var outline = $OutlineTiles
onready var player = $Player

func _ready():
	for y in range(sceneLen):
		for x in range(sceneLen):
			tiles.set_cell(x, y, 20)
			outline.set_cell(x, y, 0)
			
	player.position = Vector2(sceneLen/2*tilesize,sceneLen/2*tilesize)
	$Enemy.position = Vector2(((sceneLen/2)+3)*tilesize, ((sceneLen/2)+3)*tilesize)
	$Enemy2.position = Vector2(((sceneLen/2)-2)*tilesize, ((sceneLen/2)+1)*tilesize)
