extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var light = $LightAndShadow

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
	despawn_fireball(delta)
	
func despawn_fireball(delta: float) -> void:
	if counter > despawn_timer:
		queue_free()
	
func on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.ID == "player":
			body.dead = true
			queue_free()
