extends Node2D


var boid_scene = preload("res://scenes/boid.tscn")
onready var boids_list = $Boids

func _ready():
	add_boids(Flock.quantity)
	
	$Control/GridContainer/Separation.connect("value_changed", self, "_on_Separation_value_changed")
	$Control/GridContainer/Alignment.connect("value_changed", self, "_on_Alignment_value_changed")
	$Control/GridContainer/Cohesion.connect("value_changed", self, "_on_Cohesion_value_changed")
	
	$Control/GridContainer/Separation.value = Flock.separation * 100
	$Control/GridContainer/Alignment.value = Flock.alignment * 100
	$Control/GridContainer/Cohesion.value = Flock.cohesion * 100

# Signals

func _on_Separation_value_changed(value):
	Flock.separation = value / 100
	$Control/GridContainer/ValueSeparation.text = str(value)


func _on_Alignment_value_changed(value):
	Flock.alignment = value / 100
	$Control/GridContainer/ValueAlignment.text = str(value)


func _on_Cohesion_value_changed(value):
	Flock.cohesion = value / 100
	$Control/GridContainer/ValueCohesion.text = str(value)

# Methods

func add_boids(n=1):
	for i in n:
		var boid = boid_scene.instance()
		boid.set_random_position(Screen.width, Screen.height)
		boid.id = " ".join(["Boid", i])
		boids_list.add_child(boid)
