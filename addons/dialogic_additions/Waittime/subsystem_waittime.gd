extends DialogicSubsystem

## Waittime subsystem for managing waittime tag events and timers

## Stored as timestamp in seconds
var timeline_start_time: float = -1.0 # clock time
var skip_time: float = 0.0
var skip_mode: bool = false

## Timer singleton
## TODO: is singleton timer enough?
var timer: Timer

var current_time: float:
	get(): # calculate from skip_time and curernt clock time
		var time = Time.get_ticks_msec() / 1000.0
		return time - timeline_start_time + skip_time
	set(value): # sets skip_time on the way
		var time = Time.get_ticks_msec() / 1000.0
		skip_time = value - (time - timeline_start_time)
		current_time = value


#region STATE
####################################################################################################

## We do not save any time information in global state
## Considers recalculation on load/save is enough for waittime events
func clear_game_state(clear_flag:=Dialogic.ClearFlags.FULL_CLEAR) -> void:
	timeline_start_time = -1.0

func load_game_state(load_flag:=LoadFlags.FULL_LOAD) -> void:
	pass

#endregion


#region MAIN METHODS
####################################################################################################

# You might want to connect to timeline start signal in _ready
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	# Connect to timeline start signal if available
	if not dialogic.timeline_started.connect(func(): init_timeline()):
		push_warning("Failed to connect to timeline start signal")
	# must start with a timer node: use init_timer() from callee
	# not work: timer = get_node("/root/DialogicNode")

func init_timer(ref: Timer):
	timer = ref
	timer.autostart = false
	timer.one_shot = true

func init_timeline():
	if timeline_start_time < 0:
		timeline_start_time = Time.get_ticks_msec() / 1000.0
		print("Subsystem Waittime: timeline started at ", timeline_start_time)

func get_elapsed_time() -> float:
	if timeline_start_time < 0:
		return 0.0
	return current_time

#################
## for waittime event handling

func set_event_timer(wait_until_time: float, callback: Callable) -> void:
	var timer_time = wait_until_time - current_time

	if skip_mode:
		skip(wait_until_time) # skip previous timer
		print("skips to " + str(wait_until_time))
		callback.call() # calls cb immediately
		return

	if timer:
		stop_pending()
	else:
		print("No timer node found")
		return
	print("wait until " + str(wait_until_time) + " length " + str(timer_time))
	timer.start(timer_time)
	timer.timeout.connect(callback)

##################
## for skip mode

func set_skip_mode(mode: bool) -> void:
	if mode:
		if not skip_mode: # kick in skip mode
			stop_pending() # if exists pending timer
	skip_mode = mode

func skip(target_time: float) -> void:
	# skips previous timer
	stop_pending()
	# skips timer
	current_time = target_time
	# skips music
	if Dialogic.Audio.current_music_player and Dialogic.Audio.current_music_player[0]:
		Dialogic.Audio.current_music_player[0].seek(target_time)
	else:
		push_warning("no music player found")

func stop_pending() -> void:
	# previous timer exists
	if timer:
		if not timer.is_stopped():
			timer.stop()
			timer.emit_signal("timeout")

#endregion
