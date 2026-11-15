
	
extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hurtbox":
		var player = area.get_parent()
		if player.has_method("die"):
			player.die()
