extends CharacterBody2D


@export var batAnimation = AnimatedSprite2D
const SPEED = 150.0
const flapStrength = -200.0
var flap = false
var left = false
var right = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y = get_gravity().y * delta * 4
		
	handleInput(delta)
		
	if velocity.y < 0:
		flap = true
	else:
		flap = false
		
	updateAnimations()
	move_and_slide()


func handleInput(delta: float) -> void:
	
	left = Input.is_key_label_pressed(KEY_A)
	right = Input.is_key_label_pressed(KEY_D)
	
	if Input.is_action_pressed("ui_accept"):
		velocity.y = flapStrength
		
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and !is_on_floor():
		velocity.x = direction * SPEED
	elif !direction and (right or left) and !is_on_floor():
		if left: velocity.x = -SPEED 
		else: velocity.x = SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/25)


func updateAnimations() -> void:
	if flap:
		get_child(0).isFlapping = true
	else:
		get_child(0).isFlapping = false
		
	if velocity.x > 0:
		get_child(0).flipSprite = true
	elif velocity.x < 0: 
		get_child(0).flipSprite = false
		
	if is_on_floor():
		get_child(0).isOnFloor = true
	else:
		get_child(0).isOnFloor = false
