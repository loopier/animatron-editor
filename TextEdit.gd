extends TextEdit

var oscsnd
var oscrcv

var sndip
var sndport
var rcvport

var regex


func _ready():
	regex = RegEx.new()
	
	oscsnd = load("res://addons/gdosc/gdoscsender.gdns").new()
	sndip = "127.0.0.1"
	sndport = 56101
	oscsnd.setup(sndip, sndport)
	oscsnd.start()
	
	# See: https://gitlab.com/frankiezafe/gdosc
	oscrcv = load("res://addons/gdosc/gdoscreceiver.gdns").new()
	rcvport = 56102
	# [optional] maximum number of messages in the buffer, default is 100
	oscrcv.max_queue( 256 )
	# [optional]  receiver will only keeps the "latest" message for each address
	oscrcv.avoid_duplicate( false )
	# [mandatory] listening to port 14000
	oscrcv.setup( rcvport )
	# [mandatory] starting the reception of messages
	oscrcv.start()

func _on_TextEdit_gui_input(event):
#	print(event)
#	accept_event()
	if event.is_action_pressed("eval_block", true):
		undo() # FIX: this is a hack to remove the inserted line on pressing ENTER
#		selectBlock()
		if get_selection_from_column() != get_selection_to_line():
			evalRegion()
		else:
			evalLine()

func evalRegion():
	print("eval region")
	textToOsc(get_selection_text())

func selectBlock():
	print("select block")

func evalLine():
	print("eval line")
	textToOsc(get_line(cursor_get_line()))

func textToOsc( msgString ):
	var cmds = []
	var lines = msgString.split("\n")
	for line in lines:
		var cmd = Array(line.split(" ")) # conver PoolStringArray to Array
		var addr = cmd[0].strip_edges()
		var args = cmd.slice(1,-1)
		sendMessage(addr, args)
#	sendMessage(cmds)

func sendMessage(oscAddress, oscArgs):
	print("sending: %s %s" % [oscAddress, oscArgs])
	oscsnd.msg(oscAddress)
	for arg in oscArgs:
		oscsnd.add(arg)
	oscsnd.send()
