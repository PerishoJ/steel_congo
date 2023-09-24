extends CheckButton


# Called when the node enters the scene tree for the first time.
func _ready():
  _update_text()
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
  
func _update_text():
  if is_pressed():
    text = "Server"
  else:
    text = "Client"
    

func _on_toggled(button_pressed):
  _update_text()
  pass # Replace with function body.
