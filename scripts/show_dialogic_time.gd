extends Label

var update_interval: float = 0.05  # Update every 0.1 seconds
var time_since_update: float = 0.0

func _ready() -> void:
	# Optional: Create a timer instead of using _process
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = update_interval
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

# Remove _process and use timer callback instead
func _on_timer_timeout() -> void:
	onShowText()

# func _process(_delta: float) -> void:
#	onShowText()

func onShowText() -> void:
	if Dialogic.has_subsystem("Waittime"):
		var elapsed = Dialogic.Waittime.get_elapsed_time()
		text = "Time Elapsed: %.1f s" % elapsed
	else:
		var timeline_start_time = -1.0
		if ("waittime_starttime" in Dialogic.current_state_info):
			timeline_start_time = Dialogic.current_state_info["waittime_starttime"]
		# Get the current timeline elapsed time
		var current_time = Time.get_ticks_msec() / 1000.0
		# initialized start time if not done (first time)
		var time_elapsed = current_time - timeline_start_time
		text = "Time Elapsed: %.1f s" % time_elapsed
