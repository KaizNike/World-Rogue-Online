extends TileMap

func _ready():
	clear()

func generate(array):
	clear()
	for y in len(array):
		for x in len(array):
			if array[y][x] != null:
				set_cellv(Vector2(x,y), array[y][x])
				get_parent().incrementProgress()
