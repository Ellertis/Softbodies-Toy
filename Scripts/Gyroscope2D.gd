extends Node2D

@export var debug_label: Label
@export var fpscounter: Label

func _physics_process(delta):
	var gravity: Vector3 = Input.get_gravity()
	if gravity != null :
		var debug_text: String = "X: " + str(roundf(gravity.x)) + " Y: " + str(roundf(gravity.y)) + " Z: "+ str(roundf(gravity.z))
		debug_label.text = debug_text
		
		gravity.z = 0
		gravity.y = -gravity.y #IMPORTANT inverse Y
		gravity = gravity.normalized()
		PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, gravity)

func _process(delta):
	fpscounter.text = "FPS: %d" % Engine.get_frames_per_second()
