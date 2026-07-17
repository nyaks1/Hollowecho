extends Node2D

var scene_name = "tutorial_map"

var next_level = false
var scene_transition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_transition = $Level_transition
	scene_transition.body_entered.connect(_on_level_transition_body_entered)

func _on_level_transition_body_entered(body: CharacterBody2D) -> void:
	if body.ID == "player":
		next_level = true

func move_to_next_level() -> bool:
	return next_level
