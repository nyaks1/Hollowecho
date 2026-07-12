extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var fly_speed: float = 80.0
# how far from start it can wander
@export var patrol_radius: float = 200.0
@export var attack_range: float = 40.0

var home_position: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var is_chasing: bool = false
var is_attacking: bool = false
var player: CharacterBody2D = null

func _ready() -> void:
	print(get_children())
	sprite.play("Flying")
	home_position = global_position
	pick_new_target()
	sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if is_chasing and player != null:
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= attack_range:
			start_attack()
			return

		var direction = (player.global_position - global_position).normalized()
		velocity = direction * fly_speed
	else:
		var direction = (target_position - global_position).normalized()
		velocity = direction * fly_speed

		if global_position.distance_to(target_position) < 10.0:
			pick_new_target()

	move_and_slide()

	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0


func pick_new_target() -> void:
	# Pick a random point within patrol_radius of the home position
	var random_angle = randf_range(0, TAU)
	var random_distance = randf_range(0, patrol_radius)
	var offset = Vector2(cos(random_angle), sin(random_angle)) * random_distance
	target_position = home_position + offset

func start_attack() -> void:
	is_attacking = true
	sprite.play("Attack")
	
func _on_animation_finished() -> void:
	if sprite.animation == "Attack":
		is_attacking = false
		sprite.play("Flying")

func _on_detection_area_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_chasing = true

func _on_detection_area_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		is_chasing = false
		player = null
