extends DialogicSubsystem

## Stored as Unix timestamp in seconds
var timeline_start_time: float = -1.0

func clear_game_state(clear_flag:=DialogicGameHandler.ClearFlags.FULL_CLEAR):
	timeline_start_time = -1.0

func init_timeline():
	if timeline_start_time < 0:
		timeline_start_time = Time.get_ticks_msec() / 1000.0
		print("Timeline started at: ", timeline_start_time)

func get_elapsed_time() -> float:
	if timeline_start_time < 0:
		return 0.0
	return (Time.get_ticks_msec() / 1000.0) - timeline_start_time
