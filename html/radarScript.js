//
// OPTIONAL CONFIG START
// You can change these:
//
var portionOfScreen = 0.25 // Small radar will take up this much of the screen in %. Default: 0.33
var portionOfScreenFirstPerson = 1.0 // Big radar (while in first person) will take up this much of the screen in %. Default: 1.0
var backgroundOpacity = 0.5 // Sets the opacity of the background. Default: 0.5
var speedUnit = "km/h" //Valid units are km/h, m/s, and mph. Radar will automatically convert as appropriate. Probably. Default: km/h

// Note: Colors take anything html would normally accept including #FFFFFF or "red" etc.
var radarColorPlane = "#00c000" // Sets the color of airplane and helicopter radar entries. Default: #89F6FF
var radarColorBoat = "#CCD39F" // Sets the color of boat and submersible radar & sonar entries. Default: #CCD39F
var sonarTargetColor = "rgba(0, 222, 67, 1)"

var circleDashSize = 5 // Adjusts the appearance of the dashed circle on the radar/sonar screen. Default: 4
var circleDashSpace = 9.5 // Adjusts the appearance of the dashed circle on the radar/sonar screen. Default: 9.5
var infoTextFont = "12px Courier" // Adjusts the appearance of the range & frequency text in the bottom left corner of the radar screen. Default: "18px Courier"

var playSonarSound = true //Active SONAR is not yet implemented, so this does nothing. Ignore for now.

//
// OPTIONAL CONFIG END
// Do not change anything below this unless you know what you're doing.
//

var releaseVersion = "v0.1"
var debug = false // Can be semi-safely enabled if you wish to test performance issues. Do not leave on in your production server.
var canvas = document.getElementById("radarBackground")
var canvaswrap = document.getElementById("canvas-wrap")
var ctx = canvas.getContext("2d")
var simulateResX = null
var simulateResY = null

var drawMarginX = 20
var drawMarginY = 20

var radarTargets = 0
var radarRange = 500
var radarUpdateFreq = 200
var radarType = 0
var radarName = "RADAR_NO_NAME_JS"
var yaw = 0
var isInFirstPerson = false

var localRadarData = []
var lastDataUpdate = 0
var testTimer = 0
var luaTime = -1

var numSonarPingSounds = 3
var sonarVolume = 0.75
var isActiveSonar = false

String.prototype.toTitleCase = function () {
    return this.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
};

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function getDrawableX() { // y
	return canvas.width - drawMarginX
}

function getDrawableY() { // y
	return canvas.height - drawMarginY
}

function getCanvasSize() { // y
	return Math.min(getDrawableX(), getDrawableY())
}

function getZeroX() { // y
	return (canvas.width - getCanvasSize()) / 2
}

function getZeroY() { // y
	return (canvas.height - getCanvasSize()) / 2
}

function getRealMidX() { // y (UNNEEDED?)
	return canvas.width / 2
}

function getRealMidY() { // y (UNNEEDED?)
	return canvas.height / 2
}
		
function getMidX() { // Y
	return getRealMidX()
}

function getMidY() { // Y
	return getRealMidY()
}

function getMiddle() {
	var midW = getMidX()
	var midH = getMidY()
	return [midW, midH]
}

function getPixelsPerMeter() { // Returns meters per pixel
	return getCanvasSize() / radarRange
}

function getDistance(dist) {
	return (dist * getPixelsPerMeter()) / 2
}

function getXCoord(x) {
	return getMidX() + getDistance(x)
}

function getYCoord(y) {
	return getMidY() + getDistance(y)
}

function getPortionOfScreenMultiplier() {
	if (isInFirstPerson) {
		return portionOfScreenFirstPerson
	}
	return portionOfScreen
}

function getResX() {
	return (simulateResX || window.innerWidth) * getPortionOfScreenMultiplier()
}

function getResY() {
	return (simulateResY || window.innerHeight) * getPortionOfScreenMultiplier()
}

function scaleCanvasToFitScreen() {
	canvas.width = getResX()
	canvas.height = getResY()
}

function resetStyles() {
	ctx.strokeStyle = null
	ctx.fillStyle = null
	ctx.lineWidth = null
	ctx.setLineDash([0,0])
	ctx.font = null
	ctx.globalAlpha = 1
}

function drawBackground() {
	ctx.clearRect(0, 0, canvas.width, canvas.height) //Is this needed?
	ctx.globalAlpha = backgroundOpacity
	ctx.fillStyle = "#000000"
	ctx.fillRect(0, 0, canvas.width, canvas.height)
	resetStyles()
}

function drawCircle(x, y, radius, fill, width, strokeStyle, fillStyle, dashSize, dashSpace) {
	fill = fill || false
	ctx.strokeStyle = strokeStyle || radarColorPlane
	ctx.fillStyle = fillStyle || radarColorPlane
	ctx.lineWidth = width || 2
	dashSize = dashSize || 0
	dashSpace = dashSpace || 0
	if (dashSize != 0 && dashSpace != 0) {
		ctx.setLineDash([dashSize, dashSpace])
	} else {
		ctx.setLineDash([0,0])
	}
	
	ctx.beginPath()
	ctx.arc(x, y, radius, 0, 2*Math.PI)
	if (fill) {
		ctx.fill()
	}
	else {
		ctx.stroke()
	}
	resetStyles()
}

function drawRect(x, y, size) {
	ctx.fillStyle = "#FFFFFF"
	x = x - (size / 2)
	y = y - (size / 2)
	ctx.fillRect(x, y, size, size)
	resetStyles()
}

function drawLine(fromX, fromY, toX, toY, strokeStyle, width, dashSize, dashSpace) {
	ctx.strokeStyle = strokeStyle || "#FFFFFF"
	ctx.lineWidth = width || 2
	dashSize = dashSize || 0
	dashSpace = dashSpace || 0
	if (dashSize != 0 && dashSpace != 0) {
		ctx.setLineDash([dashSize, dashSpace])
	} else {
		ctx.setLineDash([0,0])
	}
	
	ctx.beginPath()
	ctx.moveTo(fromX, fromY)
	ctx.lineTo(toX, toY)
	ctx.stroke()
	resetStyles()
}

function getRange(deltaX, deltaY) {
	return Math.sqrt(Math.pow(deltaX, 2) + Math.pow(deltaY, 2))
}

function drawRadarTarget(deltaX, deltaY, deltaZ, name, range, speed, color) {
	color = color || radarColorPlane
	if (range == null) {
		range = getRange(deltaX, deltaY)
	}
	if (deltaZ > 0) {
		deltaZ = "+" + deltaZ
	} else if (deltaZ < 0) {
		deltaZ = "-" + Math.abs(deltaZ)
	}
	var x = getXCoord(deltaX)
	var y = getYCoord(deltaY)
	
	if (speedUnit == "km/h") {
		speed = speed * 3.6		
	} else if (speedUnit == "mph") {
		speed = speed * 2.237
	}
	
	speed = speed.toFixed(0)
	
	drawCircle(x, y, 3, true, null, null, color)
	drawText(name, x+10, y-20, "bold 10px Arial", color)
	drawText(Math.round(range) + "m (" + Math.round(deltaZ) + "m)", x+10, y-10, null, color)
	drawText(speed + speedUnit, x+10, y, null, color)
	//drawText(yaw, x+10, y+10, null, color)
	resetStyles()
}

function drawSonarTarget(deltaX, deltaY) {
	var x = getXCoord(deltaX)
	var y = getYCoord(deltaY)
	var gradient = ctx.createRadialGradient(x, y, 1, x, y, 10)
	gradient.addColorStop(0, sonarTargetColor)
	gradient.addColorStop(1, "rgba(0, 0, 0, 0)")
	drawCircle(x, y, 10, true, null, null, gradient)
}

function drawText(txt, x, y, style, color, fill, lineWidth) {
	ctx.fillStyle = color || "#FFFFFF"
	ctx.strokeStyle = color || "#FFFFFF"
	ctx.font = style || "10px Arial"
	fill = (fill == false) ? false : true // Don't even ask
	if (fill) {
		ctx.fillText(txt, x, y)
	} else {
		ctx.lineWidth = lineWidth || 1
		ctx.strokeText(txt, x, y)
	}
	resetStyles()
}
		
function drawLogo() {
	drawText("Ino", canvas.width - 143, canvas.height-15, "40px Tahoma", "#FFDA85", false, 1)
	drawText("Tech", canvas.width - 90, canvas.height-15, "40px Tahoma", "#CFFFEB", false, 1)
	drawText(radarName.toTitleCase() + " Systems", canvas.width - 92, canvas.height-5, "10px Tahoma", "white", true, 1)
	drawText(releaseVersion, canvas.width - 25, canvas.height-5, "10px Tahoma", "gray", true, 1)
}

function drawRadarCircle(range) {
	var radius = getDistance(range)
	drawCircle(getMidX(), getMidY(), radius, false, 1, "#FFFFFF", null, circleDashSize, circleDashSpace)
}

function drawRadarMidpoint(size) {
	size = size || 8
	ctx.beginPath()
	ctx.moveTo(getMidX(), getMidY() - size / 2)
	ctx.lineTo(getMidX() - size / 2, getMidY() + size / 2)
	ctx.lineTo(getMidX() + size / 2, getMidY() + size / 2)
	ctx.fillStyle = "white"
	ctx.fill()
	resetStyles()
	// drawRect(getMidX(), getMidY(), 8) //MID
}

function getHz() {
	return (1000 / radarUpdateFreq).toFixed(2)
}

function drawInfoText(startTime, debugText) { //TODO clean this up, use measureText
	//spaceBetweenText = 17
	
	if (isSonar()) {
		if (isActiveSonar) {
			sonarStatusText = "Active"
			sonarStatusColor = "green"
			sonarStatusFont = "bold " + infoTextFont
		} else {
			sonarStatusText = "Passive"
			sonarStatusColor = "red"
			sonarStatusFont = "bold " + infoTextFont
		}
		tempTxt = "Sonar Status: "
		tempTxt.font = infoTextFont // Needed for width only
		drawText(tempTxt, 10, canvas.height - 44, infoTextFont)
		drawText(sonarStatusText, 10 + ctx.measureText(tempTxt).width, canvas.height - 44, sonarStatusFont, sonarStatusColor)
	}
	drawText("Erkennungen: " + radarTargets, 10, canvas.height - 44, infoTextFont)
	drawText("Reichweite: " + radarRange + " m", 10, canvas.height - 27, infoTextFont)
	drawText("Rate: " + getHz() + " Hz", 10, canvas.height - 10, infoTextFont)
	if (debugText || false) {
		drawText("CurTime: " + Date.now(), 10, canvas.height - 167, infoTextFont)
		drawText("FirstPerson: " + isInFirstPerson, 10, canvas.height - 150, infoTextFont)
		drawText("Yaw: " + yaw, 10, canvas.height - 133, infoTextFont)
		drawText("LData: " + lastDataUpdate, 10, canvas.height - 116, infoTextFont)
		drawText("PPM: " + getPixelsPerMeter().toFixed(3), 10, canvas.height - 99, infoTextFont)
		drawText("Width: " + getResX().toFixed(0), 10, canvas.height - 82, infoTextFont)
		drawText("Height: " + getResY().toFixed(0), 10, canvas.height - 65, infoTextFont)
		drawTime = Date.now() - startTime
		drawText("jsTime: " + drawTime + "ms", 0, 16, infoTextFont)
		drawText("luaTime: " + luaTime + "ms", 0, 33, infoTextFont)		
	}
}

function translateCoords(deltaX, deltaY, usingYaw) {
	usingYaw = usingYaw || yaw // Use globally defined yaw if one is not supplied
	var rangeToTarget = getRange(deltaX, deltaY)
	var angle = Math.atan2(-deltaY, deltaX) + yaw - Math.PI / 2
	var xMult = Math.cos(angle)
	var yMult = Math.sin(angle)
	return [rangeToTarget * xMult, rangeToTarget * yMult, rangeToTarget]
}

function drawRadarObjects() {
	if (debug) {
		// drawRadarTarget(-353.5, -353.5, 503, "Test Airplane -353,-353", null, 870)
		// drawRadarTarget(200, 380, -654, "Test Airplane 500,500", null, 0)
		// drawRadarTarget(0, 500, -654, "Test Airplane 0,500", null, 0)
		// drawRadarTarget(280, -300, -689, "Test Boat 1", null, 80, radarColorBoat)
		// drawRadarTarget(300, -350, -689, "Test Boat 1", null, 80, radarColorBoat)
	}
	for (var i=0; i<localRadarData.length; i++) {
		var deltaX = localRadarData[i].vehX
		var deltaY = localRadarData[i].vehY
		var deltaZ = localRadarData[i].vehZ
		var name = localRadarData[i].vehName
		var speed = localRadarData[i].vehSpeed
		var isBoat = (localRadarData[i].vehClass == 14)
		var newCoords = translateCoords(deltaX, deltaY)
		if (isSonar()) {
			drawSonarTarget(newCoords[0], newCoords[1])
		}
		else {
			drawRadarTarget(newCoords[0], newCoords[1], deltaZ, name /*+ ":" + Math.round(deltaX) + ":" + Math.round(deltaY) */, newCoords[2], speed, isBoat ? radarColorBoat : radarColorPlane)
		}
	}
}

function getPointOnCircle(usingYaw) {
	var xy = translateCoords(radarRange, 0, yaw)
	return xy
}

function drawRadarSweep() {
	var toCoords = getPointOnCircle(yaw)
	console.log(toCoords)
	drawLine(getMidX(), getMidY(), getXCoord(toCoords[0]), getYCoord(toCoords[1]), null, null, circleDashSize, circleDashSpace)
}

function reDraw(force) {
	var startTime = Date.now()
	force = force || false

	if (isRadarOpen() || force) {
		scaleCanvasToFitScreen()
		drawBackground()
		drawRadarMidpoint()
		drawRadarCircle(radarRange)
		//drawRadarSweep()
		drawRadarObjects()

		// drawLogo()
		drawInfoText(startTime, debug)
	}
}

function openRadar() {
	reDraw(true)
	canvas.style.display = "block"
	canvaswrap.style.display = "block"
}

function closeRadar() {
	canvas.style.display = "none"
	canvaswrap.style.display = "none"
}

function isRadarOpen() {
	return canvas.style.display == "block"
}

function degreesToRadians(yaw) { //Unused
	return yaw * Math.PI / 180
}

function gameYawToRadians(yaw) { //Deprecated
	return yaw * Math.PI
}

function updateRadarInfo(range, freq, _yaw, _radarType, _radarName, targets) {
	radarRange = range
	radarTargets = targets
	radarUpdateFreq = freq
	yaw = _yaw
	radarType = _radarType
	radarName = _radarName	
}

function updateRadarData(radarData) {
	luaTime = Date.now() - testTimer
	localRadarData = []
	for (var i=0; i<radarData.length; i++) {
		var entry = radarData[i]
		localRadarData.push(entry)
	}
	lastDataUpdate = Date.now()
}

function playSonarPingSound() {
	var audioFileName = "sounds/Sonar_Ping_" + getRandomInt(1, numSonarPingSounds) + ".ogg"
	var audioHandle = new Audio(audioFileName)
	audioHandle.volume = sonarVolume
	audioHandle.play()
}

function shouldPlaySonarPingSound() {
	return (playSonarSound && isSonar() && isActiveSonar)
}

function isSonar(){
	return radarType == 3
}

window.addEventListener('message', function(event) {
	var item = event.data;
	//console.log(item)
	if (!item.command) {
		return
	}
	if (item.command == 'setRadarOpen') {
		if (item.enable == true) {
			openRadar()
		}
		else {
			closeRadar()
		}
	} 
	
	else if (item.command == "updateRadarData") {
		updateRadarData(item.radarData)
		reDraw()
		if (shouldPlaySonarPingSound()) {
			playSonarPingSound()
		}
	}
	
	else if (item.command == "updateRadarInfo") {
		// console.log("updateRadarInfo received")
		updateRadarInfo(item.range, item.freq, item.yaw, item.radarType, item.radarName, item.radarTargets)			
	}
	
	else if (item.command == "updateCamera") {
		var _fp = item.isInFirstPerson
		if (_fp != isInFirstPerson) {
			
			if (_fp) {
				document.getElementById("radar").style.display = "none"
			} else {
				document.getElementById("radar").style.display = "block"
			}
			
			isInFirstPerson = _fp
			reDraw()
		}
	}
	
	else if (item.command == "radarTimerStart") {
		testTimer = Date.now()
	}
	
	else if (item.command == "radarTimerEnd") {
		var now = Date.now()
		//console.log(now - testTimer)
	}
	
}, false);
	
if (debug) {
	// reDraw()
	// setInterval(function(){
		// reDraw()
	// }, 75)
}
