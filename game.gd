extends Node2D

const DIST1 = 10
const DIST2 = 40
const DIST3 = 80
const DIST4 = 140


var branch_quantity = randi_range(10, 15)
var grandma_quantity = randi_range(1, 3)
var fuel_quantity = randi_range(5, 10)
var funny_quantity = 1

func in_area(area1, area2):
	var cambio1=randi_range(0,1)
	var cambio2=randi_range(0,1)
	
	if cambio1:
		if cambio2:
			return Vector2(-1*randf_range(area1, area2),  randf_range(area1, area2))
		else:
			return Vector2(-1*randf_range(area1, area2),  -1*randf_range(area1, area2))
	else:
		if cambio2:
			return Vector2(randf_range(area1, area2),  randf_range(area1, area2))
		else:
			return Vector2(randf_range(area1, area2),  -1*randf_range(area1, area2))


func _ready() -> void:
	$musicafondo.play()
	
	for n in range(branch_quantity):
		var new = preload("res://object_branches.tscn").instantiate()
		new.global_position = in_area(DIST1,DIST4)
		add_child(new)
		print(new.global_position)
	for n in range(grandma_quantity):
		var new = preload("res://object_grandma.tscn").instantiate()
		new.global_position = in_area(DIST2,DIST4)
		add_child(new)
		print(new.global_position)
	for n in range(fuel_quantity):
		var new = preload("res://object_fuel.tscn").instantiate()
		new.global_position = in_area(DIST3,DIST4)
		add_child(new)
		print(new.global_position)
	for n in range(funny_quantity):
		var new = preload("res://object_plutonium.tscn").instantiate()
		new.global_position = in_area(DIST3,DIST4)
		add_child(new)
		print(new.global_position)
