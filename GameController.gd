extends Node

@export var level : Node3D;
# Called when the node enters the scene tree for the first time.
func _ready():
	if(level==null):
		level = $Level
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
