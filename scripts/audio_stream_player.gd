extends AudioStreamPlayer

var effect: AudioEffect
var recording: AudioStreamWAV

func _ready() -> void:
	var bus_idx = AudioServer.get_bus_index("record")
	effect = AudioServer.get_bus_effect(bus_idx, 0)

func _process(delta: float) -> void:
	if Input.is_key_label_pressed(KEY_R):
		if effect.is_recording_active():
			start_recording()
		else:
			stop_recording()

func start_recording() -> void:
	effect.set_recording_active(true)

func stop_recording() -> void:
	effect.set_recording_active(false)
	recording = effect.get_recording()

func save_recording(path: String) -> void:
	if recording:
		recording.save_to_wav(path)
