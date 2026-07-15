extends AudioStreamPlayer

@export var loudness_threshold_db: float = -10.0

var mic_bus_index: int
var peak_db = -100

func _ready() -> void:
	mic_bus_index = AudioServer.get_bus_index("audio_capture")

func _process(_delta: float) -> void:
	# Continuously read the peak decibels
	peak_db = AudioServer.get_bus_peak_volume_left_db(mic_bus_index, 0)
	
	# Check if the volume is louder than your threshold
	if peak_db > loudness_threshold_db:
		print("Threshold breached! Current volume: ", peak_db, " dB")
		
		# Optional: Convert to linear if you still need a 0.0 to 1.0 value
		var linear_volume: float = db_to_linear(peak_db)
		print("Linear equivalent: ", linear_volume)
