extends Node

@onready var connect_check : Timer 

func _ready():
  _connect_client()
  pass
  
  
func _connect_client():
  var network = ENetMultiplayerPeer.new()
  network.create_client("localhost",20101)
  multiplayer.multiplayer_peer = network
  #var id = multiplayer.get_unique_id()
  print("Starting Client : "+str(multiplayer.get_unique_id()))
  _setup_connectivity_check()
  
  
func _setup_connectivity_check():
  connect_check = Timer.new();
  self.add_child(connect_check)
  connect_check.one_shot = true
  connect_check.start(randf_range(0.21,3.14))
  connect_check.timeout.connect(_timeout_handler)


func _timeout_handler():
  print("checking for connectivity")
  if(multiplayer.multiplayer_peer.get_connection_status()==MultiplayerPeer.CONNECTION_CONNECTED):
    print("Connected Successfully")
  else:
    print("...not connected")
    _connect_server()
    pass


func _connect_server():
  # try connecting to as the server
  var network = ENetMultiplayerPeer.new()
  network.create_server(20101)
  multiplayer.multiplayer_peer = network
  print("Starting Server")
  #setup connection/disconnect signal handlers
  network.peer_connected.connect(connect_client)
  network.peer_disconnected.connect(disconnect_client)
  pass


func connect_client(_id):
  print("Client Connected")
  pass
  
  
func disconnect_client(_id):
  print("Client Disconnected")
  pass
