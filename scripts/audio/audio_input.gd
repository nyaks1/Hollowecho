extends AudioStreamPlayer

var effect
var recording


func _ready():
	# We get the index of the "Record" bus.
	var idx = AudioServer.get_bus_index("audio_capture")
	# And use it to retrieve its first effect, which has been defined
	# as an "AudioEffectRecord" resource.
	effect = AudioServer.get_bus_effect(idx, 0)
	effect.set_recording_active(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(effect)
