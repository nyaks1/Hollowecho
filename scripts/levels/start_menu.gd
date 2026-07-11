extends CanvasLayer

var start = false
var exit = false
var start_button
var exit_button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button = $Control/button_container/button1
	exit_button = $Control/button_container2/button2


func _on_button_1_pressed() -> void:
	start = true


func _on_button_2_pressed() -> void:
	exit = true
