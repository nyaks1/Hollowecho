extends Node2D

var scene_name = "start_menu"
var start_scene: Node2D
var start_menu: CanvasLayer
var tutorial_level: Node2D
var level_1: Node2D
var level_2: Node2D

var new_scene: bool = false
var openning: bool = false
var menu: bool = true
var tutorial: bool = false
var lvl1: bool = false
var lvl2: bool = false

func _ready() -> void:
	start_scene = preload("res://scenes/levels/start_scene.tscn").instantiate()
	tutorial_level = preload("res://scenes/levels/toturial_map.tscn").instantiate()
	start_menu = preload("res://scenes/UI/start_menu.tscn").instantiate()
	level_1 = preload("res://scenes/levels/Level 1.tscn").instantiate()
	add_child(start_menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	change_scene()
	if menu:
		scene_transition(start_menu)
		menu = false
	elif openning:
		scene_transition(start_scene)
		openning = false
	elif tutorial:
		scene_transition(tutorial_level)
		tutorial = false
	elif lvl1:
		scene_transition(level_1)
		lvl1 = false
	elif lvl2:
		scene_transition(level_2)
	
func scene_transition(body: Object):
		if get_child(0) != null:
			remove_child(get_child(0))
		add_child(body)
		new_scene = false
	
func change_scene():
	var current_scene = get_child(0).scene_name
	match current_scene:
		"start_menu":
			openning = get_child(0).get_start()
			if openning:
				new_scene = true
		"start_scene":
			if get_child(0).get_finished():
				tutorial = true
				new_scene = true
		"tutorial_map":
			if get_child(0).move_to_next_level():
				lvl1 = true
				new_scene = true
