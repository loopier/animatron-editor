extends Control

var oscsnd
var oscrcv

var sndip = "localhost"
var sndport = 56101
var rcvport = 56102


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	oscsnd = load("res://addons/gdosc/gdoscsender.gdns").new()
#	sndip = "127.0.0.1"
#	sndport = 56101
	oscsnd.setup(sndip, sndport)
	oscsnd.start()
	
	# See: https://gitlab.com/frankiezafe/gdosc
	oscrcv = load("res://addons/gdosc/gdoscreceiver.gdns").new()
	# [optional] maximum number of messages in the buffer, default is 100
	oscrcv.max_queue( 256 )
	# [optional]  receiver will only keeps the "latest" message for each address
	oscrcv.avoid_duplicate( false )
	# [mandatory] listening to port 14000
	oscrcv.setup( rcvport )
	# [mandatory] starting the reception of messages
	oscrcv.start()

func _process(delta):
	# check if there are pending messages
	while( oscrcv.has_message() ):
		# retrieval of the messages as a dictionary
		var msg = oscrcv.get_next()
		var sender = [msg["ip"], msg["port"]]
#		if not $Config.allowRemoteClients and sender[0] != "127.0.0.1":
#			print("Skipping non-local OSC message from ", sender)
#			continue
		var address = msg["address"]
		var args = msg["args"]
		# printing the values, check console
		if false:
			print( "address:", address )
			print( "typetag:", msg["typetag"] )
			print( "from:" + str( msg["ip"] ) + ":" + str( msg["port"] ) )
			print( "arguments: ")
			for i in range( 0, msg["arg_num"] ):
				print( "\t", i, " = ", args[i] )

		processOscMsg(address, args, sender)

func sendMessage(oscAddress, oscArgs):
	if not oscAddress.begins_with("/"):
		print("ERROR: OSC address must have a leading slash. Did you mean: '/%s'" % [oscAddress])
		return
	print("sending: %s %s" % [oscAddress, oscArgs])
	oscsnd.msg(oscAddress)
	for arg in oscArgs:
		oscsnd.add(arg)
	oscsnd.send()

func processOscMsg(address, args, sender):
	print("osc received from %s:%s -> %s %s" % [sender[0], sender[1], address, args])

func _on_LoadBtn_pressed():
	$LoadFileDialog.popup()


func _on_SaveBtn_pressed():
	$SaveFileDialog.popup()


func _on_LoadFileDialog_file_selected(path):
	print("open: %s" % [path])
	var file = File.new()
	file.open(path, File.READ)
	$TextEdit.text = file.get_as_text()


func _on_SaveFileDialog_file_selected(path):
	print("open: %s" % [path])
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string($TextEdit.text)
