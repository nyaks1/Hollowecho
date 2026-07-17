extends CharacterBody2D

@onready var flap_sound: AudioStreamPlayer = $FlapSound 
@onready var sprite: AnimatedSprite2D = get_child(0) 
@onready var health_bar: AnimatedSprite2D = $CanvasLayer/health_bar
@onready var screech_range: Area2D = $Screech_range

# --- Audio Input Nodes ---
@onready var audio_input: AudioStreamPlayer = $AudioInput
@onready var volume_bar: AnimatedSprite2D = $CanvasLayer/volume_bar

# --- ECHOLOCATION NODES ---
@onready var echo_light: PointLight2D = $EchoLight 
@onready var sonar_sound: AudioStreamPlayer2D = $SonarSound

# --- DYNAMIC MOVEMENT VARIABLES ---
# Exporting these lets your level designer tweak the max speeds directly in the editor
@export var max_speed: float = 4000.0
@export var max_flap_strength: float = -4000.0

@export var max_health: float = 100

var current_speed: float = 0.0
var current_flap_strength: float = 0.0

var current_health: float

# --- Emit a signal when the bat screeches ---

const FLAP_SOUND_WINDOW = 0.25 
var flap = false
var flap_timer = 0.0
var gravity_multiplyer = 3
var left = false
var right = false
var ID = "player"
var dead = false
var screeching = true

# --- HUNGER VARIABLES ---
var hunger_bar
var hunger_percentage = 100.0

# --- SONAR COOLDOWN VARIABLES ---
var current_sonar_cooldown = 0.0
const MAX_SONAR_COOLDOWN = 2.0 

func _ready() -> void:
	sprite.frame_changed.connect(_on_animation_frame_changed)
	current_health = max_health
	hunger_bar = $CanvasLayer/hunger_bar
	hunger_bar.set_frame_and_progress(0,0)
	if echo_light:
		echo_light.energy = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y = get_gravity().y * delta * gravity_multiplyer
	
	if dead:
		sprite.isDead = true
		velocity.x = 0
		move_and_slide()
		return
		
	# 1. Update the hunger drain first
	updateHungerBar(delta)
	
	updateVolumeBar()
	
	# 2. Recalculate physics strength based on the new hunger level
	calculate_dynamic_speed()
	
	# 3. Process inputs with the newly calculated speeds
	handleInput(delta)
	
	if screeching:
		for body in screech_range.get_overlapping_bodies():
			if body is CharacterBody2D and body != self:
				body.screeching(position)
				
	screeching = false
	
	if flap_timer > 0.0:
		flap_timer -= delta
		flap = true
	else:
		flap = false

	if current_sonar_cooldown > 0.0:
		current_sonar_cooldown -= delta

	updateAnimations()
	move_and_slide()

# --- THE DYNAMIC SPEED ENGINE ---
func calculate_dynamic_speed() -> void:
	# Convert 100% hunger to a 1.0 multiplier. 
	# The max() function ensures the bat never completely freezes (stops at 30% speed minimum).
	var stamina_multiplier = max(0.2, hunger_percentage / 100.0)
	
	current_speed = max_speed * stamina_multiplier
	current_flap_strength = max_flap_strength * stamina_multiplier

func handleInput(delta: float) -> void:
	left = Input.is_key_label_pressed(KEY_A)
	right = Input.is_key_label_pressed(KEY_D)

	if Input.is_action_pressed("ui_up") or Input.is_key_label_pressed(KEY_W) or Input.is_action_pressed("ui_accept"): 
		# Now using dynamic flap strength instead of the static constant
		velocity.y = current_flap_strength * delta
		flap_timer = FLAP_SOUND_WINDOW 

	# The Echolocation Trigger (E Key)
	if Input.is_key_pressed(KEY_E) and current_sonar_cooldown <= 0.0:
		trigger_sonar()
		updateHungerBar(5)
		screeching = true
		
	if Input.is_action_pressed("ui_down") or Input.is_key_label_pressed(KEY_S):
		gravity_multiplyer = 4
	else:
		gravity_multiplyer = 3

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * current_speed * delta
	elif !direction and (right or left):
		if left: velocity.x = -current_speed * delta
		else: velocity.x = current_speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed/25)

# --- THE ECHOLOCATION LOGIC ---
func trigger_sonar() -> void:
	current_sonar_cooldown = MAX_SONAR_COOLDOWN
	
	if sonar_sound:
		sonar_sound.pitch_scale = randf_range(0.9, 1.1)
		sonar_sound.play()
	
	if echo_light:
		var tween = get_tree().create_tween()
		tween.tween_property(echo_light, "energy", 1.5, 0.05)
		tween.tween_property(echo_light, "energy", 0.0, 1.5).set_trans(Tween.TRANS_SINE)

func updateVolumeBar():
	
	var db = audio_input.peak_db
	
	var frame = (
		0 if db < -60 else
		1 if db < -50 else
		2 if db < -40 else
		3 if db < -30 else
		4 if db < -20 else
		5 if db < -10 else 
		6
	)
	volume_bar.set_frame_and_progress(frame,0)

func updateHungerBar(delta: float):
	var hunger_reduction = delta * 0.5
	hunger_percentage = clamp(hunger_percentage - hunger_reduction, 0.0, 100.0)
	
	var frame = (
		4 if hunger_percentage < 2 else
		3 if hunger_percentage <= 25 else
		2 if hunger_percentage <= 50 else
		1 if hunger_percentage <= 75 else
		0
	)
	hunger_bar.set_frame_and_progress(frame, 0)

func updateHealth(amount: float):
	var updated_health = current_health + amount
	current_health = clamp(updated_health, 0, 100)
	if current_health == 0:
		dead = true
	updateHealthBar()

func updateHealthBar():
	var frame = (
	0 if current_health == 0 else
	1 if current_health <= 25 else
	2 if current_health <= 50 else
	3 if current_health <= 75 else
	4
	)
	health_bar.set_frame_and_progress(frame, 0)

func updateHungerPercentage(amount :float):
	# Clamp ensures the percentage never exceeds 100
	hunger_percentage = clamp(hunger_percentage + amount, 0.0, 100.0)

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

func _on_animation_frame_changed() -> void:
	if sprite.animation == "fly" or sprite.isFlapping:
		if sprite.frame == 2: 
			if flap_sound:
				flap_sound.pitch_scale = randf_range(0.95, 1.05)
				flap_sound.play()
