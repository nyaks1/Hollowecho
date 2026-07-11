extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var fly_speed: float = 80.0
@export var patrol_radius: float = 200.0  # how far from start it can wander

var home_position: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO


var is_chasing: bool = false
var player: Node2D = null

func _ready() -> void:
	sprite.play("Flying")
	home_position = global_position
	pick_new_target()

func _physics_process(delta: float) -> void:
	if is_chasing and player != null:
		# Move toward the player
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * fly_speed
	else:
		# Move toward the random target point
		var direction = (target_position - global_position).normalized()
		velocity = direction * fly_speed

		if global_position.distance_to(target_position) < 10.0:
			pick_new_target()


	move_and_slide()

	# Flip sprite to face the direction it's moving
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0

func pick_new_target() -> void:
	# Pick a random point within patrol_radius of the home position
	var random_angle = randf_range(0, TAU)
	var random_distance = randf_range(0, patrol_radius)
	var offset = Vector2(cos(random_angle), sin(random_angle)) * random_distance
	target_position = home_position + offset

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_chasing = true



func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_chasing = false
		player = null
