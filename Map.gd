extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var matMap = get_node("Material")
onready var fixMap = get_node("Fixtures")
var map = []
var boxes = []
var spawnTime = 10
var moveTime = 0
var stop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(38):
		map.append([])
		for y in range(21):
			map[x].append("blank")

func _getCell(x, y):
	return map[x][y]

func _updateMap(x, y, tile):
	if x < 2 or x > 37: return
	if y < 2 or y > 20: return	
	if _getCell(y, y) == "wall":
		return
	map[x][y] = tile
	set_cell(x, y, self.tile_set.find_tile_by_name(tile))
	
func setConveyor(x, y, dir):
	_updateMap(x, y, dir)
	
func moveBoxes():
	var oBoxes = boxes
	boxes = []
	var filledPos = []
	while oBoxes:
		var box = oBoxes.pop_front()
		var nBoxPos = Vector2(box.pos)
		var conveyor = _getCell(box.pos.x, box.pos.y)
		if conveyor == "up": nBoxPos.y -= 1
		elif conveyor == "down": nBoxPos.y += 1
		elif conveyor == "left": nBoxPos.x -= 1
		elif conveyor == "right": nBoxPos.x += 1
		if not nBoxPos in filledPos:
			box.pos = nBoxPos
		boxes.append(box)
		filledPos.append(nBoxPos)

func removceFor(name, desire, score, malus):
	var outId = self.tile_set.find_tile_by_name(name);
	var outputs = fixMap.get_used_cells_by_id(outId)
	
	var uBoxes = []
	for box in boxes:
		var remove = false
		for o in outputs:
			if box.pos == o:
				remove = true
		if not remove:
			uBoxes.append(box)
		else:
			if box.type == desire:
				get_owner().boxRemoved(score)
			else:
				get_owner().boxRemoved(malus)
	boxes = uBoxes

func doStop():
	stop = true

func removeBoxes():
	removceFor("out_red", "red", 100, -50)
	removceFor("out_blue", "blue", 100, -50)
	removceFor("out_green", "green", 100, -50)
	removceFor("bin", "foo", -10, -10)
	
func spawnForType(type, boxType):
	var inId = self.tile_set.find_tile_by_name(type)
	var inputs = fixMap.get_used_cells_by_id(inId)
	for i in inputs:
		if not i in boxes:
			boxes.append({"pos": i, "type": boxType})
			
func spawnBoxes():
	spawnForType("in", "poop")

func processBoxes():
	var processes = []
	processes.append(["spray_green", "ball", "green"])
	processes.append(["spray_red", "ball", "red"])
	processes.append(["spray_blue", "ball", "blue"])
	processes.append(["press", "poop", "ball"])
	for process in processes:
		var cell = process[0]
		var from = process[1]
		var to = process[2]
	
		for box in boxes:
			var id = self.tile_set.find_tile_by_name(cell)
			var machines = fixMap.get_used_cells_by_id(id)
			if box.pos in machines && box.type == from:
				box.type = to

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stop: return
	
	spawnTime += delta * 4
	moveTime += delta * 4
		
	if spawnTime > 10:
		spawnTime -= 10
		spawnBoxes()
	
	if moveTime > 1:
		moveTime -= 1
		matMap.clear()
		moveBoxes()
	
	removeBoxes()
	processBoxes()
		
	for box in boxes:
		var boxId = self.tile_set.find_tile_by_name(box.type)
		matMap.set_cell(box.pos.x, box.pos.y, boxId)
