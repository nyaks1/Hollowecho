extends PointLight2D

@onready var original_scale: float = texture_scale
var is_active: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("my_action") and not is_active:
		is_active = true
		
		# Create a single sequential tween chain
		var tween = create_tween()
		
		# 1. Smoothly scale up over 0.5 seconds
		tween.tween_property(self, "texture_scale", original_scale * 2.0, 1.5)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			
		# 2. Wait at the expanded size for 5 seconds inside the tween itself
		tween.tween_interval(5.0)
		
		# 3. Smoothly shrink back to original size over 0.5 seconds
		tween.tween_property(self, "texture_scale", original_scale, 1.5)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			
		# 4. Safely reset the flag only after the whole animation chain finishes
		await tween.finished
		is_active = false
