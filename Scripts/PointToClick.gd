extends Sprite


var timeAppear = 0.0
var timeUse = 0.0
var place = ""

var timeRangeLow = 0
var timeRangeHigh = 0

var reporter = null

var placeStart = null
var placeEnd = null
var currentTime = 0.0

# timeAppear - time element need to appear
# timeUse - time node need to be activated
# place - upper or lower row
# reporter - GameNodeController
func setParams(timeAppear, timeUse, place, reporter):
	self.timeAppear = timeAppear
	self.timeUse = timeUse
	self.place = place
	self.reporter = reporter
	
	if place == "up":
		self.placeStart = GlobalTypes.positionStart1
		self.placeEnd = GlobalTypes.positionEnd1
	elif place == "down":
		self.placeStart = GlobalTypes.positionStart2
		self.placeEnd = GlobalTypes.positionEnd2
	
	countTimeRange()

func proceed(currentTime):
	self.currentTime = float(currentTime)
	
	var newPosition = placeStart
	newPosition.x = placeStart.x + (placeEnd.x - placeStart.x) * ( float( currentTime - timeAppear ) / float( timeUse - timeAppear ) )
	
	self.set_position(newPosition)
	
	if currentTime / timeUse >= 1.0:
		var reportObj = {}
		reportObj.type = "single"
		reportObj.ref = self
		reporter.onReport(GlobalTypes.EventType.TIME_FAIL, reportObj)
	
func countTimeRange():
	timeRangeLow = timeUse - 0.12
	timeRangeHigh = timeUse + 0.12
	
func checkCurrentTime(time) -> bool:
	return time <= timeRangeHigh && time >= timeRangeLow
	
func onEvent(eventType, eventInfo):
	if eventType == GlobalTypes.EventType.CLICK_DOWN:
		var currentTime = eventInfo.currentTime
		var posClicked = eventInfo.place
		
		var reportObj = {}
		reportObj.type = "single"
		reportObj.ref = self
		
		if checkCurrentTime(currentTime) && posClicked == self.place:
			reporter.onReport(GlobalTypes.EventType.CLICK_SUCCESS, reportObj)
		elif abs(currentTime - timeUse) < 0.11:
			reporter.onReport(GlobalTypes.EventType.CLICK_FAIL, reportObj)

func getPlace() -> String:
	return self.place
