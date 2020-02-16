extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in ["spray_green", "spray_red", "spray_blue", "press", "press", "press", "bin"]:
		var id = self.tile_set.find_tile_by_name(i)
		var x = randi()%32 + 4
		var y = randi()%16 + 4
		self.set_cell(x, y, id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
