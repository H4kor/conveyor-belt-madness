extends Node2D

onready var map = get_node("Map")
var mousePos = Vector2(0,0)
var dir = null
var score = 0
var timer = 100
var stop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dir != null:
		var tile = pos2tile(mousePos)
		map.setConveyor(tile.x, tile.y, dir)
	get_node("Score").set_text(str(score))
	if not stop:
		timer -= delta
	get_node("Timer").set_text(str(int(timer)))
	if timer < 0 and not stop:
		ProjectSettings.set("score", score)
		var s = ResourceLoader.load("Highscore.tscn").instance()
		get_tree().get_root().add_child(s)
		map.doStop()
		stop = true
		timer = 0
		
	
	
func boxRemoved(s):
	score += s

func _input(event):
	if event is InputEventMouseMotion:
		mousePos = event.position
	elif event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_W: dir = "up"
			if event.scancode == KEY_A: dir = "left"
			if event.scancode == KEY_S: dir = "down"
			if event.scancode == KEY_D: dir = "right"
		else:
			dir = null

func pos2tile(pos):
	var nPos = pos #- Vector2(64,64)
	var tile = (nPos / 32).floor()
	return tile
