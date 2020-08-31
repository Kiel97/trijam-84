extends Node2D

export var goal_scene = preload("res://Goal.tscn")

onready var move_tween: Tween = $MoveTween

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var command_node: Node2D = $CommandNode
onready var command: Label = $CommandNode/Command
var move_speed: float = 0.5

var commands: Array = ["Move here", "Follow me", "Come here", "Go here"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

func move_and_place(caller: Node2D, pos: Vector2) -> void:
	anim_player.stop()
	command_node.visible = false
	
	move_tween.interpolate_property(self, "position", position, pos, move_speed)
	move_tween.start()
	
	yield(move_tween, "tween_completed")
	place_new_goal(caller, pos)

func place_new_goal(caller: Node2D, pos: Vector2) -> void:

	var goal = goal_scene.instance()
	goal.position = pos
	self.position = pos
	goal.connect("collected", caller, "_on_Goal_collected")
	caller.call_deferred("add_goal_to_tree", goal)
	
	anim_player.play("click")
	display_random_command()

func display_random_command() -> void:
	command.text = commands[randi() % commands.size()]
	command_node.visible = true
