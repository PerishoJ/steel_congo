extends Node

var game_controller : GameController 

var is_server : bool = false
# HTTPClient demo
# This simple class can do HTTP requests; it will not block, but it needs to be polled.
func _enter_tree():
  if not OS.is_debug_build():
    var _isServer = "--server" in OS.get_cmdline_args()
    start()
  #set_multiplayer_authority(id)
  #is_multiplayer_authority()

func set_server(_is_server : bool):
  self.is_server = _is_server

func start():
  if(is_server):
    _start_server()
  else:
    _start_client()
  
  
func _start_server():
  var network = WebSocketMultiplayerPeer.new();
  #var network = ENetMultiplayerPeer.new()
  network.create_server(9999)
  multiplayer.multiplayer_peer = network
  print("Starting Server")
  #setup connection/disconnect signal handlers
  network.peer_connected.connect(connect_client)
  network.peer_disconnected.connect(disconnect_client)
  pass
  
func _start_client():
  #var network = ENetMultiplayerPeer.new()
  var network = WebSocketMultiplayerPeer.new()
  
  network.create_client("localhost:9999")
  multiplayer.multiplayer_peer = network
  #var id = multiplayer.get_unique_id()
  print("Starting Client : "+str(multiplayer.get_unique_id()))
  pass

func set_game_controller (ctl : GameController):
  game_controller = ctl

func connect_client(id):
  print("Connecting Client: " + str(id))
  game_controller.add_player(id)

func disconnect_client(id):
  print("Disconnecting Client: " + str(id))
  game_controller.remove_player(id)
