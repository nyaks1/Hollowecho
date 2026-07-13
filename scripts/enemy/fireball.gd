extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var rb = $RigidBody2D
@onready var collision = $CollisionShape2D
@onready var light = $LightAndShadow

var speed = 60
var direction: Vector2 = Vector2(1,1)
var collided: bool = false
var despawn_timer = 3
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play()
	body_entered.connect(on_body_entered)
	
func _process(delta: float) -> void:
	counter += delta
	update_position()
	despawn_fireball(delta)
	
func update_position() -> void:
	rb.linear_velocity = direction * speed
	sprite.position = rb.position
	light.position = rb.position
	collision.position = rb.position
	
func despawn_fireball(delta: float) -> void:
	if counter > despawn_timer:
		queue_free()
	
func on_body_entered(body: Node2D) -> void:
	queue_free()
