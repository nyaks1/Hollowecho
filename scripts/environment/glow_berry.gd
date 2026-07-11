extends Node2D

var berry_collision
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	berry_collision = $Area2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.updateHungerPercentage(25)
	queue_free()
