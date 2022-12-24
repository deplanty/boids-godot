extends Node2D


var boid_scene = preload("res://scenes/boid.tscn")
onready var boids_list = $Boids

export (int) var quantity :int = 50


func _ready():
	print("Board ready")
	add_boids(quantity)


func add_boids(n=1):
	for i in n:
		var boid = boid_scene.instance()
		boid.set_random_position(Screen.width, Screen.height)
		boid.id = " ".join(["Boid", i])
		boids_list.add_child(boid)
