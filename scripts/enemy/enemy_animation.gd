extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var fly_speed: float = 80.0
@export var point_a: Vector2 = Vector2(0, 0)
@export var point_b: Vector2 = Vector2(300, 0)

var flying_to_b: bool = true
var is_chasing: bool = false
var player: Node2D = null

func _ready() -> void:
	sprite.play("Flying")

func _physics_process(delta: float) -> void:
	if is_chasing and player != null:
		# Move toward the player
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * fly_speed
	else:
		# Patrol between point_a and point_b
		var target = point_b if flying_to_b else point_a
		var direction = (target - global_position).normalized()
		velocity = direction * fly_speed

		if global_position.distance_to(target) < 10.0:
			flying_to_b = not flying_to_b

	move_and_slide()

	# Flip sprite to face the direction it's moving
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_chasing = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_chasing = false
		player = null
