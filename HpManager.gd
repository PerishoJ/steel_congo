extends Node

@export var hp: int;
@export var totalHp: int;
var debug: bool = false;
@onready var _debug_label : Label3D = $_debug_lbl_Hp
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_hurtBox_signals()
	_init_debug()

func _connect_hurtBox_signals():
	var hurtBoxes = owner.find_children("","HurtBox",true, true)
	print("found "+str(len(hurtBoxes))+" hurtboxes. Connecting")
	for box in hurtBoxes:
		box.hurt.connect(hurt)
		
		
func _init_debug():
	debug = (get_parent() as RobotController).debug
	print("Hp manager is "+str(debug))
	_debug_label.visible = debug # hide if debug is off
	_updateHpLabel()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_debug_label.visible = debug 
	pass

func heal(health : int):
	hp = hp + health
	hp = clampi( hp , 0 , totalHp)
	_updateHpLabel()
	
func hurt(damage: int):
	hp = hp - damage
	hp = clampi( hp , 0 , totalHp)
	_updateHpLabel()
	
func _updateHpLabel():
	if(debug):
		_debug_label.text = "HP [ "+str(hp) + "/" +str(totalHp)+" ]"
