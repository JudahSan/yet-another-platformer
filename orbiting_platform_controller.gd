@tool
extends Node2D

@export var radius: Vector2 = Vector2.ONE * 256
@export var rotation_duration: float = 4.0

var platforms: Array[Node2D] = []
var orbit_angle_offset: float = 0.0
var prev_child_count: int = 0


func _ready() -> void:
	_find_platforms()


func _physics_process(delta: float) -> void:
	# Check if new children were added or removed
	if prev_child_count != get_child_count():
		prev_child_count = get_child_count()
		_find_platforms()

	# Update orbit angle
	orbit_angle_offset += (TAU * delta) / rotation_duration
	orbit_angle_offset = wrapf(orbit_angle_offset, -PI, PI)

	# Update platform positions
	_update_platforms()


func _find_platforms() -> void:
	platforms.clear()
	for child in get_children():
		if child.is_in_group("platforms_orbit") and child is Node2D:
			platforms.append(child)


func _update_platforms() -> void:
	if platforms.is_empty():
		return

	var spacing := TAU / float(platforms.size())
	for i in range(platforms.size()):
		var angle := spacing * i + orbit_angle_offset
		var new_position := Vector2(
			cos(angle) * radius.x,
			sin(angle) * radius.y
		)
		platforms[i].position = new_position
