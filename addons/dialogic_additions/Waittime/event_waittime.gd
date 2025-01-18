@tool
extends DialogicEvent
class_name DialogicWaittimeEvent

# Define the event properties
var wait_until_time: float = 0.0
var timeline_start_time: float = -1.0

#region INITIALIZE
################################################################################
# Set fixed settings of this event
func _init() -> void:
	event_name = "Waittime"
	event_category = "Flow"


#endregion

#region SAVING/LOADING
################################################################################
# Return event shortcode (format in timeline file)
func get_shortcode() -> String:
	return "wait_time"

# Return event properties that can be exported
func get_shortcode_parameters() -> Dictionary:
	return {
		"time": {"property": "wait_until_time", "default": 0.0}
	}

# You can alternatively overwrite these 3 functions: to_text(), from_text(), is_valid_event()
#endregion


#region EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	pass

#endregion

# Execute the event
func _execute() -> void:
	# initialize timeline start time if needed, in subsystem to persist
	# NOT WORK?: Dialogic.Waittime.init_timeline()
	if ("waittime_starttime" in Dialogic.current_state_info):
		timeline_start_time = Dialogic.current_state_info["waittime_starttime"]
	else:
		timeline_start_time = Time.get_ticks_msec() / 1000.0
		Dialogic.current_state_info["waittime_starttime"] = timeline_start_time

	# Get the current timeline elapsed time
	var current_time = Time.get_ticks_msec() / 1000.0

	# initialized start time if not done (first time)
	if timeline_start_time < 0.0:
		timeline_start_time = current_time
	var time_elapsed = current_time - timeline_start_time

	push_warning("current_time is " + str(current_time) + " elapsed: " + str(time_elapsed));

	if time_elapsed >= wait_until_time:
		# If we're already past the time, finish immediately
		finish()
	else:
		# Create a timer to wait for the remaining time
		var timer = dialogic.get_tree().create_timer(wait_until_time - time_elapsed)
		push_warning("wait until " + str(wait_until_time))
		timer.timeout.connect(on_timeout)

func on_timeout() -> void:
	var current_time = Time.get_ticks_msec() / 1000.0
	push_warning("timeout: current_time is " + str(current_time) + " elapsed:" + str(current_time - timeline_start_time));
	finish()
	

# Add method to reset timer (good practice to have this)
func reset_timer() -> void:
	timeline_start_time = 0.0

# You might want to connect to timeline start signal in _ready
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	# Connect to timeline start signal if available
	if dialogic.timeline_started.connect(func(): reset_timer()):
		push_warning("Failed to connect to timeline start signal")
		
