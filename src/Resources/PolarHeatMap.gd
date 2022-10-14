extends TextureRect

func _ready():
	self.texture.width = 3
	
	var image = self.get_texture().get_data()
#	print(image.get_pixel(200,0))
#	image.get_rect(Rect2(0, 0,2048, 2048))
	print(image.get_size())
#	image.lock()
#	print(image.get_pixel(200,0))
#	print(image.get_pixel(1024, 0))
##	print(image.get_data())
