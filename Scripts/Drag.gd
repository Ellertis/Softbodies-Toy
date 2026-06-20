extends Node2D

@export var drag_strength:float = 4
@export var damping:float = 0.5
@export var rotation_damping_factor:float = 0.02

var last_mouse_pos:Vector2 = Vector2.ZERO
var mouse_velocity:Vector2 = Vector2.ZERO

var bones:Array[RigidBody2D]
var touchpos:Vector2 = Vector2.ZERO
var displacements:PackedVector2Array

func _physics_process(delta):
	mouse_velocity = (touchpos - last_mouse_pos) / delta
	last_mouse_pos = touchpos
	for i in bones.size():
		var bone:RigidBody2D = bones[i]
		var target:Vector2 = touchpos + displacements[i]
		var offset:Vector2 = target - bone.global_position
		var spring_force:Vector2 = offset * drag_strength
		var damping_force:Vector2 = -bone.linear_velocity * damping
		bone.apply_force(spring_force + damping_force, -mouse_velocity * rotation_damping_factor)

func _unhandled_input(event):
	#InputEventMouseButton
	#InputEventScreenTouch
	if event is InputEventMouseButton:
		if event.is_pressed():
			var body = get_body_under_mouse()
			if body is RigidBody2D && body.get_parent() is SoftBody2D:
				print("Clicked:", body.name)
				_get_displacements(body.get_parent(),body)
				touchpos = event.position
				set_physics_process(true)
		if not event.is_pressed():
			set_physics_process(false)
			for bone in bones:
				bone.apply_central_force(mouse_velocity)
			bones.clear()
			displacements.clear()
			print("Released")
	
	if event is InputEventMouse:
		touchpos = event.position

func get_body_under_mouse():
	var mouse_pos:Vector2 = get_global_mouse_position()
	var query:PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_bodies = true
	var result = get_world_2d().direct_space_state.intersect_point(query)
	if result.size() > 0:
		return result[0].collider
	else: print("fu")
	return null

func _get_displacements(sb: SoftBody2D,rg: RigidBody2D):
	for child in sb.get_children():
		if child is RigidBody2D:
			bones.append(child)
	var current_mainbone_pos = rg.get_global_transform().origin
	displacements.resize(bones.size())
	for i in bones.size():
		var bone:RigidBody2D = bones[i]
		displacements[i] = bone.get_global_transform().origin - current_mainbone_pos
