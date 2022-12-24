extends KinematicBody2D

# Boid parameters
var id :int = 0
# Actual speed of the boid with direction
export (Vector2) var speed := Vector2(100, 0)  # pixel/???
# The target speed
export (int) var speed_target := 8000  # pixel/???
# The acceleration rate to the target speed
export (float, 0.01, 1) var speed_target_rate := 0.8  # %
# Scenes and objects
onready var detection_area = $DetectionArea
onready var protection_area = $ProtectionArea

# Magics

func _ready() -> void:
	randomize()
	id = Flock.next_id()
	speed = speed.rotated(rotation)


func _process(delta) -> void:
	var boids :Array
	
	# Detect boids in protection range and go far from them
	var closed_delta = Vector2(0, 0)
	boids = get_boids_in_protection()
	for boid in boids:
		closed_delta.x += position.x - boid.position.x
		closed_delta.y += position.y - boid.position.y
	
	# Detect boids in visual range, match their direction and move toward them
	var vel_average = Vector2(0, 0)
	var pos_average = Vector2(0, 0)
	boids = get_boids_detected()
	for boid in boids:
		vel_average += boid.speed
		pos_average += boid.position
	if boids.size() > 0:
		vel_average /= boids.size()
		pos_average /= boids.size()
	
	speed += closed_delta * 200 * delta * Flock.separation  # Separation
	speed += vel_average * 2 * delta * Flock.alignment  # Alignment
	speed += (pos_average - position) * 20 * delta * Flock.cohesion  # Cohesion
	
	# Adapt speed to match the target speed
	var speed_magnitude = speed.length()
	speed *= 1 + ((speed_target - speed_magnitude) / speed_magnitude) * speed_target_rate
	
	# Move the boids according to the calculated speed
	move_and_slide(speed * delta)
	look_at(position + speed)
	
	# Make the world as a donut for the boids
	world_is_a_donut()

# Methods

## Set a random position and rotation to the boid within a range.
func set_random_position(width:int, height:int, pad:int=5) -> void:
	position.x = rand_range(pad, width - pad)
	position.y = rand_range(pad, height - pad)
	rotation = deg2rad(rand_range(0, 360))
	speed = speed.rotated(rotation)

## Make the boid move in the board as if it is a donut.
func world_is_a_donut():
	if position.x > Screen.width:
		position.x = 0
	elif position.x < 0:
		position.x = Screen.width
	
	if position.y > Screen.height:
		position.y = 0
	elif position.y < 0:
		position.y = Screen.height

## Returns the list of boids contained in the protection area
func get_boids_in_protection() -> Array:
	var bodies = protection_area.get_overlapping_bodies()
	bodies.erase(self)
	return bodies

## Returns the list of boids conained in the detection area
func get_boids_detected() -> Array:
	var bodies = detection_area.get_overlapping_bodies()
	bodies.erase(self)
	return bodies
