extends CanvasLayer

var scene_name = "start_menu"
var start = false
var exit = false
var start_button
var exit_button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button = $Control/button_container/button1
	exit_button = $Control/button_container2/button2

func get_start() -> bool:
	return start

func get_exit() -> bool:
	return exit

func _on_button_1_pressed() -> void:
	print("start")
	start = true


func _on_button_2_pressed() -> void:
	exit = true


func _on_button_1_button_down() -> void:
	print("start")
	start = true


func _on_button_2_button_down() -> void:
	exit = true
