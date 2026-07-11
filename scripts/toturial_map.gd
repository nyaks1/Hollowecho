extends Node2D

var effect
var recording

func _ready():
	# We get the index of the "Record" bus.
	var idx = AudioServer.get_bus_index("audio_capture")
	# And use it to retrieve its first effect, which has been defined
	# as an "AudioEffectRecord" resource.
	effect = AudioServer.get_bus_effect(idx, 0)

func _process(delta: float) -> void:
	if Input.is_key_label_pressed(KEY_Q):
		on_record_button_pressed()
		
	if Input.is_key_label_pressed(KEY_E):
		on_play_button_pressed()

func on_record_button_pressed():
	if effect.is_recording_active():
		recording = effect.get_recording()
		effect.set_recording_active(false)
	else:
		effect.set_recording_active(true)


func on_play_button_pressed():
	print(recording)
	print(recording.format)
	print(recording.mix_rate)
	print(recording.stereo)
	var data = recording.get_data()
	print(data.size())
	$AudioInput.stream = recording
	$AudioInput.play()
