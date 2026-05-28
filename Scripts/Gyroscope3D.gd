extends Node3D

@export var debug_label: Label
@export var fpscounter: Label

func _ready():
	return
	if Input.get_gravity() == Vector3(0,0,0):
		push_error("Gravity is null")
		set_physics_process(false)
 
func _physics_process(delta):
	var InputGravity: Vector3 = Input.get_gravity()
	var OutputGravity: Vector3
	OutputGravity.z = 0
	OutputGravity.y = -InputGravity.y #IMPORTANT inverse Y
	OutputGravity.x = InputGravity.x
	PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, OutputGravity.normalized())
	OutputGravity = OutputGravity.limit_length(9.8)
	PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY, OutputGravity.length())
	fpscounter.text = "X: " + str(roundf(InputGravity.x)) + " Y: " + str(roundf(InputGravity.y)) + " Z: "+ str(roundf(InputGravity.z))

func _process(delta):
	fpscounter.text = "FPS: %d" % Engine.get_frames_per_second()
