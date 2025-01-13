extends Node

@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# new_game()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func new_game() -> void:
	_reset()
	_start()
	
	
func _reset():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$HUD.update_score(score)
	
	
func _start():
	$Music.play()
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	
func game_over():
	$DeathSound.play()
	$Music.stop()
	$HUD.show_game_over()
	$ScoreTimer.stop()
	$MobTimer.stop()


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_mob_timer_timeout() -> void:
	add_child(_get_mob())
	
	
func _get_mob() -> Node:
	var mob: RigidBody2D = mob_scene.instantiate()
	
	var mob_spawn_location = _get_random_mob_spawn_location()
	mob.position = mob_spawn_location.position
	
	var rotation: float = _get_mob_rotation(mob_spawn_location)
	mob.rotation = rotation
	mob.linear_velocity = _get_mob_velocity(rotation)

	return mob


func _get_random_mob_spawn_location() -> PathFollow2D:
	var mob_spawn_location: PathFollow2D = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	return mob_spawn_location


func _get_mob_rotation(mob_location: PathFollow2D) -> float:
	# Set the mob's direction perpendicular to the path direction.
	var rotation: float = mob_location.rotation + PI / 2
	var randomness: float = randf_range(-PI / 4, PI / 4)
	return rotation + randomness


func _get_mob_velocity(direction: float) -> Vector2:
	var velocity: Vector2 = Vector2(randf_range(150.0, 250.0), 0.0)
	return velocity.rotated(direction)
