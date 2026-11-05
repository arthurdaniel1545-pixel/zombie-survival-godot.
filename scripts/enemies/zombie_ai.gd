class_name ZombieAI
extends CharacterBody3D

enum State { PATROL, CHASE, SEARCH, ATTACK, DEAD }
var state: State = State.PATROL
@export var max_health: float = 30.0
@export var speed_patrol: float = 1.2
@export var speed_chase: float = 3.5
@export var detection_range: float = 12.0
@export var attack_range: float = 1.5
@export var attack_damage: float = 8.0
@export var perception: float = 1.0
var health: float = 30.0
var target: Node3D = null
var last_known_pos: Vector3 = Vector3.ZERO
var search_timer: float = 0.0
var interest_timer: float = 0.0
const SEARCH_TIME := 6.0
const INTEREST_TIME := 12.0

func _ready() -> void:
	health = max_health

func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return
	match state:
		State.PATROL:
			_patrol(delta)
		State.CHASE:
			_chase(delta)
		State.SEARCH:
			_search(delta)
		State.ATTACK:
			_attack(delta)
	move_and_slide()

func _patrol(_delta: float) -> void:
	# placeholder: idle sway
	velocity = Vector3.ZERO

func detect(player: Node3D) -> void:
	if player == null:
		return
	var dist := global_position.distance_to(player.global_position)
	if dist <= detection_range * perception:
		target = player
		last_known_pos = player.global_position
		state = State.CHASE
		interest_timer = INTEREST_TIME

func _chase(delta: float) -> void:
	if target == null:
		state = State.PATROL
		return
	last_known_pos = target.global_position
	var dir := (target.global_position - global_position)
	dir.y = 0
	if dir.length() > 0.1:
		dir = dir.normalized()
		velocity = dir * speed_chase
		look_at(target.global_position, Vector3.UP)
	var dist := global_position.distance_to(target.global_position)
	if dist <= attack_range:
		state = State.ATTACK
	if dist > detection_range * 1.5:
		interest_timer -= delta
		if interest_timer <= 0:
			state = State.SEARCH
			search_timer = SEARCH_TIME

func _search(delta: float) -> void:
	var dir := (last_known_pos - global_position)
	dir.y = 0
	if dir.length() > 0.5:
		dir = dir.normalized()
		velocity = dir * speed_patrol
	else:
		velocity = Vector3.ZERO
	search_timer -= delta
	if search_timer <= 0:
		state = State.PATROL
		target = null

func _attack(_delta: float) -> void:
	velocity = Vector3.ZERO
	if target and global_position.distance_to(target.global_position) > attack_range:
		state = State.CHASE

func take_damage(amount: float) -> void:
	if state == State.DEAD:
		return
	health -= amount
	if health <= 0:
		state = State.DEAD
		velocity = Vector3.ZERO
