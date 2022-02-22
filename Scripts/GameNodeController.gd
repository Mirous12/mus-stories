extends Node


var streamPlayer = null
var timerStart = null

var debugTimer = null
var timerGameEnd = null
var debugScoreNode = null
var score = 0

#session info
var currentTime = 0
var gameElements = []
var gameElementsInfos = []
var songName = ""

var gameStarted = false

func _ready():
	gameStarted = false
	debugTimer = get_node("DebugTimer")
	debugScoreNode = get_node("DebugScore")
	streamPlayer = self.get_node("MusicMain")
	timerStart = self.get_node("Rhytm/TimerToStart")
	timerGameEnd = get_parent().get_node("GameEndTimer")
	
	var startPosition1 = get_node("Rhytm/StartPosition1")
	var startPosition2 = get_node("Rhytm/StartPosition2")
	
	GlobalTypes.positionStart1 = startPosition1.get_position()
	GlobalTypes.positionStart2 = startPosition2.get_position()
	
	var endPositionNode1 = get_node("Rhytm/ButtonUp")
	var endPositionNode2 = get_node("Rhytm/ButtonDown")
	
	GlobalTypes.positionEnd1 = endPositionNode1.get_position()
	GlobalTypes.positionEnd2 = endPositionNode2.get_position()

func onStart():
	if timerStart:
		parseSongConfig("Heart")
		timerStart.start(2)

func _process(delta):
	if gameStarted:
		currentTime = String(float(currentTime) + delta)
		debugTimer.text = currentTime.substr(0, 4)
		if gameStarted && gameElementsInfos && gameElementsInfos.size() > 0:
			var element = gameElementsInfos[0]
			if element && element.time_appear != null:
				var timeToSet = element.time_appear as float
				if float(currentTime) >= timeToSet:
					createElement(element)
					gameElementsInfos.remove(0)
		
		for gameElement in gameElements:
			gameElement.proceed(float(currentTime))
			
		if gameElementsInfos.size() == 0 && timerGameEnd.is_stopped():
			if timerGameEnd:
				timerGameEnd.start(2)


func _on_TimerToStart_timeout():
	if !gameStarted:
		if streamPlayer:
			streamPlayer.play()
			startGame()
	
func startGame():
	currentTime = 0
	gameStarted = true

func parseSongConfig(songName):
	var file = File.new();
	var fileName = "";
	
	if( songName == "Heart" ):
		fileName = "heart_of_a_champion"
	
	file.open("res://Songs/" + fileName + ".json", File.READ)
	
	var content = file.get_as_text()
	file.close()
	
	var jsonData = JSON.parse(content)
	
	if jsonData.error == OK:
		songName = jsonData.result.name
		gameElementsInfos = jsonData.result.structure

func createElement(elementInfo):
	if elementInfo && elementInfo.type:
		if elementInfo.type == "single":
			var newObjectResource = load("res://Prefabs/PointToClick.tscn")
			var newObject = newObjectResource.instance();
			
			var rhytm = get_node("Rhytm")
			
			var placeToPut = null
			
			if elementInfo.place == "up":
				placeToPut = get_node("Rhytm/StartPosition1")
			elif elementInfo.place == "down":
				placeToPut = get_node("Rhytm/StartPosition2")
			
			if placeToPut != null && rhytm:
				rhytm.add_child(newObject)
				newObject.set_position(placeToPut.get_position())
				gameElements.push_back(newObject)
				
				newObject.setParams(float(elementInfo.time_appear), float(elementInfo.time_use), elementInfo.place, self)

func onReport(enumType, params):
	if enumType == GlobalTypes.EventType.CLICK_FAIL || enumType == GlobalTypes.EventType.TIME_FAIL:
		var obj = params.ref
		var type = params.type
		var findObj = gameElements.find(obj)
		if findObj != -1:
			obj.queue_free()
			gameElements.remove(findObj)
	elif enumType == GlobalTypes.EventType.CLICK_SUCCESS:
		var obj = params.ref
		var type = params.type
		var findObj = gameElements.find(obj)
		if findObj != -1:
			obj.queue_free()
			gameElements.remove(findObj)
			score += 1
			if self.debugScoreNode != null:
				self.debugScoreNode.text = String(score)


func _on_ButtonUpButton_button_down():
	print("Clicked!")
	var params = {}
	params.place = "up"
	params.currentTime = float(self.currentTime)
	
	var upSended = false
	var downSended = false
	
	for gameElement in gameElements:
		if gameElement.getPlace() == "up" && upSended == false:
			gameElement.onEvent(GlobalTypes.EventType.CLICK_DOWN, params)
			upSended = true
		elif gameElement.getPlace() == "down" && downSended == false:
			gameElement.onEvent(GlobalTypes.EventType.CLICK_DOWN, params)
			downSended = true
			
		if upSended && downSended:
			break

func endGame():
	streamPlayer.stop()
	var endGameScreen = get_parent().get_node("EndGameScreen")
	endGameScreen.visible = true
	endGameScreen.setEndScore(score)
	self.visible = false


func _on_GameEndTimer_timeout():
	endGame()
