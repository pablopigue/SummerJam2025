extends Node2D

const DIST1 = 100
const DIST2 = 400
const DIST3 = 800
const DIST4 = 1200
const DIST5 = 1500

var branch_quantity = randi_range(30, 50)
var grandma_quantity = randi_range(1, 3)
var fuel_quantity = randi_range(8, 15)
var funny_quantity = 1

#region enemigos data
const ENEMY_CIERVO_SCENE = preload("res://enemy.tscn")
const ENEMY_JABALI_SCENE = preload("res://enemigo_2.tscn")
const ENEMY_PALOMA_SCENE = preload("res://enemigo_3.tscn")

var enemy_data = {
	"ciervo": {
		"scene": ENEMY_CIERVO_SCENE,
		"max_quantity": 2,
		"current_quantity": 0
	},
	"jabali": {
		"scene": ENEMY_JABALI_SCENE,
		"max_quantity": 2,
		"current_quantity": 0
	},
	"paloma": {
		"scene": ENEMY_PALOMA_SCENE,
		"max_quantity": 2,
		"current_quantity": 0
	}
}
#endregion

# Asegúrate de que el nombre coincida con el nodo Timer que creaste
@onready var new_wave_timer = $Timer 
@onready var player = get_node("Player")

func _ready() -> void:
	$musicafondo.play()

	# Conectamos la señal del temporizador a la función que genera la oleada.
	new_wave_timer.timeout.connect(generate_new_wave)

	generar_objetos(branch_quantity, "res://object_branches.tscn", DIST1, DIST4)
	generar_objetos(grandma_quantity, "res://object_grandma.tscn", DIST2, DIST4)
	generar_objetos(fuel_quantity, "res://object_fuel.tscn", DIST3, DIST4)
	generar_objetos(funny_quantity, "res://object_plutonium.tscn", DIST4, DIST5)
	
	generate_new_wave()

#region Funciones de Spawning
func in_area(seccion0, seccion1, area1, area2, centro=Vector2(0.0,0.0)):
	var angulo = randf_range(seccion0, seccion1)
	var radio = sqrt(randf_range(pow(area1, 2), pow(area2, 2)))
	return Vector2(centro.x + radio*cos(angulo), centro.y + radio*sin(angulo))

func spawn_enemy(enemy_type: String, position: Vector2):
	var data = enemy_data[enemy_type]
	var enemy = data.scene.instantiate()
	enemy.died.connect(_on_enemy_died)
	enemy.global_position = position
	add_child(enemy)
	data.current_quantity += 1

func generate_new_wave():
	print("------ ¡COMIENZA UNA NUEVA OLEADA! ------")
	for type in enemy_data:
		var data = enemy_data[type]
		var quantity_to_spawn = randi_range(1, data.max_quantity)
		for i in range(quantity_to_spawn):
			var pos = in_area(0, 2*PI, DIST3, DIST5, player.global_position)
			spawn_enemy(type, pos)

#endregion

func _on_enemy_died(enemy_instance):
	# 1. Restamos el enemigo que acaba de morir
	for type in enemy_data:
		var data = enemy_data[type]
		if data.scene.resource_path == enemy_instance.scene_file_path:
			data.current_quantity -= 1
			break

	# 2. Contamos cuántos enemigos quedan VIVOS en total
	var total_enemies_alive = 0
	for type in enemy_data:
		total_enemies_alive += enemy_data[type].current_quantity
	
	# 3. Si era el último, iniciamos el temporizador para la siguiente oleada
	if total_enemies_alive == 0:
		print("¡OLEADA COMPLETADA! La siguiente oleada comenzará en 3 segundos...")
		new_wave_timer.start(3.0) # Inicia el temporizador con una espera de 3 segundos

# Esta función es para los objetos que no son enemigos
func generar_objetos(num, nodo, area1, area2, centro=Vector2(0.0,0.0)):
	var space_state = get_world_2d().direct_space_state
	var intentos_maximos = 50

	for n in range(num):
		var new = load(nodo).instantiate()
		var colocado = false
		for intento in range(intentos_maximos):
			var seccion0 = (n)*(2*PI)/num
			var seccion1 = (n+1)*(2*PI)/num
			var pos = in_area(seccion0, seccion1, area1, area2, centro)
			
			var shape := CircleShape2D.new()
			shape.radius = 16
			var transform := Transform2D(0, pos)
			var query = PhysicsShapeQueryParameters2D.new()
			query.shape = shape
			query.transform = transform
			query.collide_with_areas = false
			query.collide_with_bodies = true
			var result = space_state.intersect_shape(query, 1)
			
			if result.size() == 0:
				new.global_position = pos
				add_child(new)
				colocado = true
				break
