@tool
extends DialogicEvent
class_name DialogicWaitTimeEvent

# Define the event properties
@export var wait_until_time: float = 0.0

func _init() -> void:
	pass

# Return event name/identifier
func get_event_name() -> String:
	return "Wait Until Time"

# Return event icon (shown in the editor)
func get_icon() -> Resource:
	return load("res://addons/dialogic/Editor/Images/Pieces/closed-icon.svg")

# Return event category
func get_category() -> String:
	return "Flow"

# Return event shortcode (format in timeline file)
func get_shortcode() -> String:
	return "wait_time"

# Return event properties that can be exported
func get_shortcode_parameters() -> Dictionary:
	return {
		"time": {"property": "wait_until_time", "default": 0.0}
	}

# Execute the event
func _execute() -> void:
	# Get the current timeline elapsed time
	var current_time = dialogic.current_timeline.elapsed_time
	
	if current_time >= wait_until_time:
		# If we're already past the time, finish immediately
		finish()
	else:
		# Create a timer to wait for the remaining time
		var timer = dialogic.get_tree().create_timer(wait_until_time - current_time)
		timer.timeout.connect(finish)
