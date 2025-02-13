@tool
extends DialogicIndexer

func _get_events() -> Array:
	return [this_folder.path_join('event_waittime.gd')]

func _get_subsystems() -> Array:
	return [{'name':'Waittime', 'script':this_folder.path_join('subsystem_waittime.gd')}]
