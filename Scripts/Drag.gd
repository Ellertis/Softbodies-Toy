extends Node2D

@export var drag_strength:float = 4
@export var damping:float = 0.5

var last_mouse_pos:Vector2 = Vector2.ZERO
var mouse_velocity:Vector2 = Vector2.ZERO

var bones:Array[RigidBody2D]
var bdragging:bool = false 
var touchpos:Vector2 = Vector2.ZERO
var displacements:PackedVector2Array

func _physics_process(delta):
	mouse_velocity = (touchpos - last_mouse_pos) / delta
	last_mouse_pos = touchpos
	if bdragging:
		for i in bones.size():
			var bone = bones[i]
			var target = touchpos + displacements[i]
			var offset = target - bone.global_position
			var spring_force = offset * drag_strength
			var damping_force = -bone.linear_velocity * damping
			bone.apply_central_force(spring_force + damping_force)

func _unhandled_input(event):
	#InputEventMouseButton
	#InputEventScreenTouch
	if event is InputEventMouseButton:
		if event.is_pressed():
			var body = get_body_under_mouse()
			if body is RigidBody2D && body.get_parent() is SoftBody2D:
				print("Clicked:", body.name)
				_get_displacements(body.get_parent(),body)
			bdragging = true
			touchpos = event.position
		if not event.is_pressed():
			bdragging = false
			for bone in bones:
				bone.apply_central_force(mouse_velocity)
			print("Released")
	
	if bdragging && event is InputEventMouse:
		touchpos = event.position

func get_body_under_mouse():
	var mouse_pos = get_global_mouse_position()
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_bodies = true
	var result = get_world_2d().direct_space_state.intersect_point(query)
	if result.size() > 0:
		return result[0].collider
	else: print("fu")
	return null

func _get_displacements(sb: SoftBody2D,rg: RigidBody2D):
	bones.clear()
	displacements.clear()
	var i:int=0
	for child in sb.get_children():
		if child is RigidBody2D:
			bones.append(child)
			i+=1
	
	var current_mainbone_pos = rg.get_global_transform().origin
	i=0
	displacements.resize(bones.size())
	for bone in bones:
		displacements[i] = bone.get_global_transform().origin - current_mainbone_pos
		i+=1
