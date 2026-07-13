extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var fly_speed: float = 50.0
# how far from start it can wander
@export var patrol_radius: float = 200.0
@export var attack_range: float = 100.0

var ID = "enemy"
var fireball: PackedScene
var home_position: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var is_chasing: bool = false
var is_attacking: bool = false
var player: CharacterBody2D = null
var fireball_timer = 2
var count = 1

func _ready() -> void:
	print(get_children())
	sprite.play("Flying")
	home_position = global_position
	pick_new_target()
	sprite.animation_looped.connect(_on_animation_looped)
	fireball = preload("res://scenes/enemy/fireball.tscn")

func _physics_process(delta: float) -> void:
	
	if is_attacking:
		count += delta
		velocity = Vector2.ZERO
		if count > fireball_timer:
			fireball_speed_and_direction()
			count = 0
			
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
	
func _on_animation_looped() -> void:
	if sprite.animation == "Attack":
		is_attacking = false
		sprite.play("Flying")

func fireball_speed_and_direction() -> void:
	if player != null:
		var fb = fireball.instantiate()
		var direction = (player.global_position - global_position).normalized()
		fb.rotation = direction.angle()
		fb.direction = direction
		add_child(fb)
		if !sprite.flip_h:
			fb.position.x -= 120

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.ID == "player":
			player = body
			is_chasing = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.ID == "player":
			is_chasing = false
			player = null
		
