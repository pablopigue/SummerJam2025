extends Node2D

func _ready():
	for gem in get_children():
		# Verificamos si es una gema por el nombre (opcional)
		if "Gem" in gem.name:
			# Buscamos el Area2D llamado "Gema2D" dentro de cada gema
			var area = gem.get_node("Gem2D")
			
			if area and area is Area2D:
				if area.has_signal("gemCollected"):
					if has_node("HUD"):
						# Conexión segura usando Callable
						var hud = $HUD
						if hud.has_method("_on_gem_collected"):
							area.connect("gemCollected", Callable(hud, "_on_gem_collected"))
						else:
							printerr("HUD no tiene el método _on_gem_collected")
					else:
						printerr("No se encontró el nodo HUD")
				else:
					printerr("El Area2D en ", gem.name, " no tiene la señal gemCollected")
			else:
				printerr(gem.name, " no tiene un nodo Area2D llamado Gema2D")
