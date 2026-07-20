extends Node2D

@onready var move_t = $"TutorialUI/move turoral"
@onready var echo_t = $"TutorialUI/Echo tutorial"
@onready var fly_t = $"TutorialUI/second tutorial"
@onready var help_page = $"TutorialUI/Help page"
@onready var aim = $"TutorialUI/Goal page"

var scene_name = "tutorial_map"

var next_level = false
var scene_transition
var tutorial = true
var transition_timer = 5
var count = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TutorialUI.visible = true
	scene_transition = $Level_transition
	scene_transition.body_entered.connect(_on_level_transition_body_entered)

func _process(delta: float) -> void:
	count += delta * 2
	
	if tutorial and count > transition_timer:
		tutorial_transition()

func _on_level_transition_body_entered(body: CharacterBody2D) -> void:
	if body.ID == "player":
		next_level = true

func move_to_next_level() -> bool:
	return next_level

func tutorial_transition():
	var up = Input.is_key_label_pressed(KEY_SPACE) or Input.is_action_just_pressed("ui_up")
	var echo = Input.is_key_label_pressed(KEY_E)
	var left = Input.is_key_label_pressed(KEY_A) or Input.is_action_just_pressed("ui_left")
	var right = Input.is_key_label_pressed(KEY_D) or Input.is_action_just_pressed("ui_right")
	
	if help_page.visible:
		if count > 12:
			help_page.visible = false
			count = 0
		return
	
	if left or right:
		if move_t.visible:
			fly_t.visible = true
			count = 0
		move_t.visible = false
		aim.visible = false
		
	if up:
		if fly_t.visible:
			echo_t.visible = true
			count = 0
		fly_t.visible = false
		
	if echo:
		echo_t.visible = false
		tutorial = false
		count = 0
