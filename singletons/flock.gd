extends Node

var quantity :int = 200

## Rate at which the boid get away from the others
var separation :float = 0.8
## Rate at which the boid align with the others
var alignment :float = 0.8
## Rate at which the boid stay close to the others
var cohesion :float = 0.8

var _id_current :int = 0

## Returns the next id when a boid is created
func next_id() -> int:
	_id_current += 1
	return _id_current
