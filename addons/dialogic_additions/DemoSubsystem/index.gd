@tool
extends DialogicIndexer

func _get_events() -> Array:
	return [this_folder.path_join('event_demo_subsystem.gd')]

func _get_subsystems() -> Array:
	return [{'name':'DemoSubsystem', 'script':this_folder.path_join('subsystem_demo_subsystem.gd')}]
