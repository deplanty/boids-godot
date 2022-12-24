extends Node


var _id_current :int = 0

## Returns the next id when a boid is created
func next_id() -> int:
	_id_current += 1
	return _id_current
