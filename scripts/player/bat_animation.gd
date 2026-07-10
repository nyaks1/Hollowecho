extends AnimatedSprite2D

var flipSprite = false
var landed = false
var isFlapping:bool = false
var isOnFloor = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play("fly")
	self.set_frame_and_progress(1,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if flipSprite:
		self.flip_h = true
	else:
		self.flip_h = false
	
	
	
	if isFlapping:
		self.speed_scale = 2.5
		landed = false
		if flip_v:
			flip_v = false
		self.play("fly")
	elif isOnFloor and !landed:
		self.speed_scale = 2
		self.flip_v = true
		self.play("land")
	elif landed and isOnFloor:
		self.speed_scale = 0.7
		self.play("idle")
	else:
		landed = false
		self.speed_scale = 1
		self.play("fly")
		


		
func _on_animation_finished() -> void:
		pass


func _on_animation_looped() -> void:
	if isOnFloor:
		landed = true
		speed_scale = 2
