class_name HurtBox
extends Area3D

var debug_lbl: Label3D;
var lbl_reset_delay_millis = 2000;
var lbl_reset_time = 0;
var orig_lbl_text: String;
signal hurt
# Called when the node enters the scene tree for the first time.
func _ready():
    self.area_entered.connect(_on_area_entered)
    debug_lbl = owner.get_node("_debug_label_name");
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    if shouldResetLbl() and "OUCH!!!"==debug_lbl.text:
        debug_lbl.text = orig_lbl_text


func _on_area_entered( hitbox: HitBox):
    _debug()
    hurt.emit(hitbox.damage)

func _debug():
    print("hurt")
    if(debug_lbl!=null):
        if shouldResetLbl():
            orig_lbl_text = debug_lbl.text # use this to set the label back later
            print("Setting label to " + orig_lbl_text)
        debug_lbl.text = "OUCH!!!"
        lbl_reset_time = Time.get_ticks_msec() + lbl_reset_delay_millis;
func shouldResetLbl():
    return  Time.get_ticks_msec() > lbl_reset_time 
