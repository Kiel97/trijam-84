extends StaticBody2D

onready var appear_tween: Tween = $AppearTween
onready var collision: CollisionShape2D = $CollisionShape2D

var appearing_time = 1.0


func _on_Obstacle_ready() -> void:
	appear_tween.interpolate_property($Sprite, "modulate", Color(1,1,1,0),
			Color(1,1,1,1), appearing_time)
	appear_tween.start()
