class_name Player extends CharacterBody2D


@export var speed : float = 100.0
@export_range(1,20,0.5) var decelerate_speed : float = 5.0
@onready var audio_attack: AudioStreamPlayer2D = $Audio/AudioStreamPlayer2D
@onready var sprite_2d : Sprite2D = $Sprite2D

@onready var animation_tree : AnimationTree = $AnimationTree


var direction : Vector2 = Vector2.ZERO

func _ready() -> void:
	animation_tree.active = true


func _process(delta: float) -> void:
	update_animation_parameters()

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	
	
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	

	
	if(Input.is_action_just_pressed("attack")):
		velocity = lerp(velocity, direction * 0, delta * 2.0)
		audio_attack.volume_db = randf_range(-10, -5)
		audio_attack.pitch_scale = randf_range(0.9, 1.1)
		audio_attack.play()
	move_and_slide()


func update_animation_parameters() -> void:
	if(velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	
	if(Input.is_action_just_pressed("attack")):
		velocity -= direction * decelerate_speed * speed
		animation_tree["parameters/conditions/attack"] = true
	else:
		animation_tree["parameters/conditions/attack"] = false
	if(direction != Vector2.ZERO):
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/attack/blend_position"] = direction
		animation_tree["parameters/walk/blend_position"] = direction
