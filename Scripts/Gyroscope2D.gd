extends Node2D

@export var debug_label: Label
@export var fpscounter: Label

func _physics_process(delta):
	#return - debug for testing with classic gravity
	#return
	var InputGravity: Vector3 = Input.get_gravity()
	if InputGravity != null :
		var debug_text: String = "X: " + str(roundf(InputGravity.x)) + " Y: " + str(roundf(InputGravity.y)) + " Z: "+ str(roundf(InputGravity.z))
		debug_label.text = debug_text
	
	var OutputGravity: Vector2 = Vector2(InputGravity.x,-InputGravity.y)
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, OutputGravity.normalized())
	
	var OutputGravityLength: Vector2# = OutputGravity.limit_length(9.8)
	OutputGravityLength = OutputGravity*100 #Convert m/s to px/s
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, OutputGravityLength.length())


func _process(delta):
	fpscounter.text = "FPS: %d" % Engine.get_frames_per_second()

func _on_reset_button_pressed():
	get_tree().reload_current_scene()
