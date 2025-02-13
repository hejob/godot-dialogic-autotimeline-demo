@tool
extends DialogicEvent
class_name DialogicWaittimeEvent

# Define the event properties
var wait_until_time: float = 0.0

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
	if not Dialogic.has_subsystem("Waittime"):
		print("ERROR: No Waittime subsystem")
		finish()

	var Waittime = Dialogic.get_subsystem("Waittime")
	var elasped_time = Waittime.get_elapsed_time()

	push_warning("current_time is " + str(elasped_time) + " skipped: " + str(Waittime.skip_time))

	if elasped_time >= wait_until_time:
		# If we're already past the time, finish immediately
		finish()
	else:
		#timer.timeout.connect(on_timeout)
		Waittime.set_event_timer(wait_until_time, on_timeout)

func on_timeout() -> void:
	var Waittime = Dialogic.get_subsystem("Waittime")
	var elasped_time = Waittime.get_elapsed_time()
	var current_time = Time.get_ticks_msec() / 1000.0
	push_warning("timeout current_time is " + str(elasped_time) + " real: " + str(current_time))
	finish()
