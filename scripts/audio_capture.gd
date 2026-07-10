extends Node2D
 
var effect
var recording

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index = AudioServer.get_bus_index("record")
	effect = AudioServer.get_bus_effect(index, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
