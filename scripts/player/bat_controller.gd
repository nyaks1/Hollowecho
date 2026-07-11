extends CharacterBody2D
@onready var flap_sound: AudioStreamPlayer = $FlapSound 
@onready var sprite: AnimatedSprite2D = get_child(0) 
const SPEED = 4000
const flapStrength = -4000.0
const FLAP_SOUND_WINDOW = 0.25  # sound stays "armed" this long after last flap input
var flap = false
var flap_timer = 0.0
var left = false
var right = false
var hunger_bar
var hunger_percentage = 100

func _ready() -> void:
	sprite.frame_changed.connect(_on_animation_frame_changed)
	hunger_bar = $CanvasLayer/AnimatedSprite2D
	hunger_bar.set_frame_and_progress(0,0)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y = get_gravity().y * delta * 3

	handleInput(delta)

	if flap_timer > 0.0:
		flap_timer -= delta
		flap = true
	else:
		flap = false

	updateHungerBar(delta)
	updateAnimations()
	move_and_slide()

func handleInput(delta: float) -> void:
	left = Input.is_key_label_pressed(KEY_A)
	right = Input.is_key_label_pressed(KEY_D)

	if Input.is_action_pressed("ui_accept"):  # UNCHANGED — your original held control, restored
		velocity.y = flapStrength * delta
		flap_timer = FLAP_SOUND_WINDOW  # keeps re-topping-up while held, and lingers briefly after release

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED * delta
	elif !direction and (right or left):
		if left: velocity.x = -SPEED * delta
		else: velocity.x = SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/25)

func updateHungerBar(delta: float):
	
	hunger_percentage -= delta*2
	
	if hunger_percentage <= 1:
		hunger_bar.set_frame_and_progress(3,0)
	elif hunger_percentage <= 50:
		hunger_bar.set_frame_and_progress(2,0)
	elif hunger_percentage <= 75:
		hunger_bar.set_frame_and_progress(1,0)
	elif hunger_percentage > 75:
		hunger_bar.set_frame_and_progress(0,0)
	
func updateHungerPercentage(amount :float):
	hunger_percentage += amount
	

func updateAnimations() -> void:
	if flap:
		sprite.isFlapping = true
	else:
		sprite.isFlapping = false
	if velocity.x > 0:
		sprite.isMoving = true
		sprite.flipSprite = true
	elif velocity.x < 0: 
		sprite.isMoving = true
		sprite.flipSprite = false
	else:
		sprite.isMoving = false
	
	if is_on_floor():
		sprite.isOnFloor = true
	else:
		sprite.isOnFloor = false

# THIS RUNS EVERY TIME THE ANIMATION ADVANCES ONE FRAME
func _on_animation_frame_changed() -> void:
	# Only play sounds if the bat is actively playing its flapping animation
	if sprite.animation == "fly" or sprite.isFlapping:
		# CRITICAL: Replace '2' with the exact frame index where the wings strike down
		if sprite.frame == 2: 
			# Add subtle pitch variation so it sounds organic and natural
			flap_sound.pitch_scale = randf_range(0.95, 1.05)
			flap_sound.play()
