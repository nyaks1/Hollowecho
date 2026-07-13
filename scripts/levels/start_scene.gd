extends Node2D

var scene_name = "start_scene"
var finished: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		finished = true
		print("finished")

func get_finished() -> bool:
	return finished


func _on_video_stream_player_finished() -> void:
	finished = true
