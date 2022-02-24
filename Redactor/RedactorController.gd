extends Node2D

var elements = []

var isPlaying = false
var currentTime = 0.0
var currentTimeTimer = null

var currentMarginY = 0.0
var currentElement = null

var elementInfoController = null

func _ready():
	currentTimeTimer = get_node("Editor/Timer")
	elementInfoController = get_node("Editor/ElementInfo")
	var elementInfoConteroller = get_node("Editor/ElementInfo")
	if elementInfoConteroller:
		elementInfoConteroller.redactorController = self

func _process(delta):
	if isPlaying:
		currentTime = currentTime + delta
		currentTimeTimer.text = String(currentTime).substr(0, 4)

func _on_ButtonChooseMusic_pressed():
	var fileDialog = get_node("FileDialog")
	fileDialog.set_filters(PoolStringArray(["*.mp3"]))
	fileDialog.set_mode(0)
	fileDialog.popup()

func _on_FileDialog_file_selected(path):
	var fileDialog = get_node("FileDialog")
	fileDialog.visible = false
	var file = File.new()
	file.open(path, File.READ)
	var bytesArray = file.get_buffer(file.get_len())
	
	var mp3Stream = AudioStreamMP3.new()
	mp3Stream.set_data(bytesArray)
	
	var streamPlayer = get_node("AudioStreamPlayer2D")
	streamPlayer.set_stream(mp3Stream)
	
	if mp3Stream:
		var playlist = get_node("Playlist")
		var songNameLabel = get_node("Playlist/SongName")
		playlist.visible = true
		if songNameLabel:
			songNameLabel.text = path
			var chooseLabel = get_node("ChooseMusic")
			if chooseLabel:
				chooseLabel.visible = false

func onButtonPlayPressed():
	var streamPlayer = get_node("AudioStreamPlayer2D")
	if streamPlayer:
		streamPlayer.play()
		isPlaying = true
		currentTime = 0.0
		currentTimeTimer.text = "0.00"
		
		var buttonPlay = get_node("Playlist/SpritePlay")
		var buttonPause = get_node("Playlist/SpritePause")
		buttonPlay.visible = false
		buttonPause.visible = true

func onButtonPausePressed():
	var streamPlayer = get_node("AudioStreamPlayer2D")
	if streamPlayer:
		streamPlayer.stop()
		isPlaying = false
		
		var buttonPlay = get_node("Playlist/SpritePlay")
		var buttonPause = get_node("Playlist/SpritePause")
		buttonPlay.visible = true
		buttonPause.visible = false

func createNewElement():
	var elementInfo = {}
	elementInfo.id = elements.size() + 1
	elementInfo.type = "single"
	
	if elementInfoController.getChooseType() == "Appear":
		elementInfo.time_appear = currentTime
		elementInfo.time_use = currentTime + 1.0
	elif elementInfoController.getChooseType() == "Use":
		elementInfo.time_appear = currentTime - 1.0
		elementInfo.time_use = currentTime
	
	elementInfo.doc_string = String(elementInfo.id) + "|single"
	
	var panelElementInfo = load("res://Prefab/ScrollElement.tscn")
	var panelElement = panelElementInfo.instance()
	var scroll = get_node("Editor/ScrollContainer/VBoxContainer")
	if scroll && panelElement:
		panelElement.setInfo(elementInfo)
		scroll.add_child(panelElement)
		elements.push_back(panelElement)
		var newPosition = Vector2(0, currentMarginY)
		panelElement.set_position(newPosition)
		currentMarginY = currentMarginY + panelElement.get_size().y * 1.05
		var button = panelElement.get_node("Label/ButtonPanelElement")
		button.connect("button_down", self, "onElementClicked", [elementInfo.id])

func onButtonAddNewClicked():
	createNewElement()

func onElementClicked(elementId):
	var targetElement
	for element in elements:
		if element.getId() == elementId:
			targetElement = element
			break
	if targetElement:
		var params = targetElement.getInfo()
		var editor = get_node("Editor/ElementInfo")
		if editor:
			editor.visible = true
			editor.setInfo(params)
			currentElement = targetElement

func saveElementInfo(params):
	if currentElement:
		var newSetParams = {}
		newSetParams.id = currentElement.getId()
		newSetParams.type = params.type
		newSetParams.time_appear = params.timeAppear
		newSetParams.time_use = params.timeUse
		newSetParams.doc_string = String(currentElement.getId()) + "|" + params.type
		
		currentElement.setInfo(newSetParams)
