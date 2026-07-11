extends Node2D

var start_scene
var start_menu
var tutorial_level
var level_1
var level_2

var new_scene: bool = true
var openning: bool = false
var menu: bool = true
var tutorial: bool = false
var lvl1: bool = false
var lvl2: bool = false

func _ready() -> void:
	tutorial_level = preload("res://scenes/levels/toturial_map.tscn").instantiate()
	start_menu = preload("res://scenes/UI/start_menu.tscn").instantiate()
	level_1 = preload("res://scenes/levels/Level 1.tscn")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_scene()
	
	if new_scene:
		if menu:
			if get_child(0) != null:
				remove_child(get_child(0))
			add_child(start_menu)
			new_scene = false
		elif tutorial:
			if get_child(0) != null:
				remove_child(get_child(0))
			add_child(tutorial_level)
			new_scene = false
		elif lvl1:
			if get_child(0) != null:
				remove_child(get_child(0))
			add_child(level_1)
			new_scene = false
		elif lvl2:
			if get_child(0) != null:
				remove_child(get_child(0))
			add_child(level_2)
			new_scene = false
		
func change_scene():
	if get_child(0).start != null:
		tutorial = get_child(0).start
		if menu:
			new_scene = true
	
