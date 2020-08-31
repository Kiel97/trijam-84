extends Area2D

signal collected

onready var appear_tween: Tween = $AppearTween
onready var collision: CollisionShape2D = $CollisionShape2D
onready var anim_player: AnimationPlayer = $AnimationPlayer

var appear_time: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision.disabled = true
	anim_player.stop()
	appear_tween.interpolate_property($Sprite, "modulate", Color(1,1,1,0), Color(1,1,1,1), appear_time)
	appear_tween.start()


func _on_Goal_body_entered(body: Node) -> void:
	if body.name == "Player":
		emit_signal("collected")
		self.queue_free()


func _on_AppearTween_tween_completed(object: Object, key: NodePath) -> void:
	collision.disabled = false
	anim_player.play("rotate")
