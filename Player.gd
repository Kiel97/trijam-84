extends KinematicBody2D

const SPEED = 10

var is_playing: bool = false
var velocity: Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_playing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_playing:
		var hor = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
		var ver = -int(Input.is_action_pressed("up")) + int(Input.is_action_pressed("down"))
		
		velocity = move_and_slide(velocity + (Vector2(hor, ver).normalized() * SPEED))
		$Sprite.rotation = velocity.angle()
	
func start_playing() -> void:
	is_playing = true

func stop_playing() -> void:
	is_playing = false
