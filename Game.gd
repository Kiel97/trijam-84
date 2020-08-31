extends Node2D

export var obstacle_scene = preload("res://Obstacle.tscn")

export var min_x : int = 30
export var max_x : int = 970
export var min_y : int = 30
export var max_y : int = 570

onready var game_ui: Control = $UI/GameUI
onready var menu_ui: Control = $UI/MenuUI

onready var score_label: Label = $UI/GameUI/Score
onready var time_label: Label = $UI/GameUI/TimeLeft

onready var player := $Player
onready var bot: Node2D = $Bot
onready var timer: Timer = $Timer
onready var obstacles: Node2D = $Obstacles
onready var particles := $Particles

onready var collected_sfx: AudioStreamPlayer = $CollectedSFX
onready var game_over_sfx: AudioStreamPlayer = $GameOverSFX
onready var music: AudioStreamPlayer = $BackgroundMusic

var is_playing: bool = false
var score: int setget set_score
var time_left: int setget set_time_left
var time_bonus: float = 0.0
var goal: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	show_menu()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("start") and not is_playing:
		start_game()

func start_game() -> void:
	is_playing = true
	menu_ui.visible = false
	game_ui.visible = true
	
	player.visible = true
	bot.visible = true
	
	particles.visible = true
	
	self.score = 0
	self.time_left = 50
	time_bonus = 0
	player.start_playing()
	
	bot.move_and_place(self, Vector2(rand_range(min_x, max_x),rand_range(min_y, max_y)))
	timer.start()
	
	music.play()

func show_menu() -> void:
	particles.visible = false
	is_playing = false
	
	game_ui.visible = false
	menu_ui.visible = true
	
	player.visible = false
	bot.visible = false
	
	if goal:
		goal.queue_free()
	
	for obstacle in obstacles.get_children():
		obstacle.queue_free()
	
	timer.stop()
	player.stop_playing()

	music.stop()

func set_score(value: int) -> void:
	score = value
	score_label.text = "Score " + str(score).pad_zeros(2)

func set_time_left(value: int) -> void:
	time_left = value
	time_label.text = str(time_left).pad_zeros(4)

func _on_Goal_collected() -> void:
	
	particles.position = goal.position
	particles.emitting = true
	$Particles/Alive.start()
	
	collected_sfx.play()
	self.score += 1
	if self.score % 5 == 0 and self.score > 0:
		place_new_obstacle()
		time_bonus += 0.25
	self.time_left += 3 + int(round(time_bonus))
	bot.move_and_place(self, Vector2(rand_range(min_x, max_x),rand_range(min_y, max_y)))

func place_new_obstacle() -> void:
	var obstacle = obstacle_scene.instance()
	obstacle.position = Vector2(rand_range(min_x, max_x),rand_range(min_y, max_y))
	obstacles.call_deferred("add_child", obstacle)

func add_goal_to_tree(node: Node2D) -> void:
	goal = node
	add_child(goal)

func _on_Timer_timeout() -> void:
	self.time_left -= 1
	if self.time_left <= 0:
		game_over_sfx.play()
		show_menu()

func _on_Alive_timeout() -> void:
	particles.emitting = false
