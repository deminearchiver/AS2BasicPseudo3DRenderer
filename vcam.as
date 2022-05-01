// Made by Shuriken255.
// Please don't claim as your own
// and you should be good.

// You are free to edit and add your own functions, tho.
// So good luck and have a nice day! ;)

import flash.geom.Matrix;


onEnterFrame = function() {
	_root.filters = this.filters;
	cameraLogic();
	moveParallaxes();
}

onUnload = function() {
	_root.filters = new Array();
	resetParentsPosition();
	moveParallaxes();
}

// Values between 0 and 1 determine how close viewframe will
// move to camera each frame.
// 0 = no binding, camera won't move
// 1 = full binding, viewframe will be strictly following camera
var binding = 1;

// Need this to determine symbol
var isACameraByShuriken255 = true;

// Gotta remember previous coordinates
var bounds:Object = viewfinder.getBounds(viewfinder);
var oW = bounds.xMax - bounds.xMin;
var oH = bounds.yMax - bounds.yMin;
var sW = Stage.width;
var sH = Stage.height;
var swR = Stage.width / oW;
var shR = Stage.height / oH;


// For future uses
var point:Object = new Object();

function convertToParent(clip:MovieClip, point) {
	var m:Matrix = clip.transform.matrix;
	var newX = clip._x + point.x * m.a + point.y * m.c;
	var newY = clip._y + point.x * m.b + point.y * m.d;
	point.x = newX;
	point.y = newY;
}

function convertFromParent(clip:MovieClip, point) {
	var m:Matrix = clip.transform.matrix;
	var newX = point.x;
	var newY = point.y;
	var oldX = ((clip._x + ((clip._y - newY) / (-m.d)) * m.c - newX) / (-m.a)) / (1 - (m.b * m.c) / (m.d * m.a));
	var oldY = ((clip._y + ((clip._x - newX) / (-m.a)) * m.b - newY) / (-m.d)) / (1 - (m.c * m.b) / (m.a * m.d));
	point.x = oldX;
	point.y = oldY;
}

var prevX = _x;
var prevY = _y;
var prevW = _xscale;
var prevH = _yscale;
var prevR = _rotation;

var defaultShakeMultiplier = 0.75; // constant, you may change it
var inverted = false;
var shakeX = 0;
var shakeY = 0;

var lastTrackingFrame = -2;

function cameraLogic() {
	resetParentsPosition();
	moveViewframe();
	attachParentToViewframe();
	shakeLogic();
}

function shakeLogic() {
	inverted = !inverted;
	var mul = _parent.shuriken255_shake_multiplier;
	if (mul == undefined) {
		mul = defaultShakeMultiplier;
	}
	shakeX *= mul;
	shakeY *= mul;
}

function moveViewframe() {
	viewfinder._x = 0;
	viewfinder._y = 0;
	viewfinder._xscale = 100;
	viewfinder._yscale = 100;
	viewfinder._rotation = -this._rotation;
	
	var tarX = _x;
	var tarY = _y;
	var tarW = _xscale;
	var tarH = _yscale;
	var tarR = _rotation;
	var difR = tarR - prevR;
	if (difR < -180) {
		difR += 360;
	}
	if (difR > 180) {
		difR -= 360;
	}
	var finR = prevR + (difR) * binding;
	
	var finX = prevX + (tarX - prevX) * binding;
	var finY = prevY + (tarY - prevY) * binding;
	var finW = prevW + (tarW - prevW) * binding;
	var finH = prevH + (tarH - prevH) * binding;
	
	prevX = finX;
	prevY = finY;
	prevW = finW;
	prevH = finH;
	prevR = finR;
	
	// Shaking camera
	if (inverted && shakeX != undefined) {
		finX -= shakeX;
		finY -= shakeY;
	} else {
		finX += shakeX;
		finY += shakeY;
	}
	
	if (finX == 0 && finY == 0) {
		finX = 0.5;
	}
	
	_root.vcam._x = finX;
	_root.vcam._y = finY;
	_root.vcam._xscale = finW;
	_root.vcam._yscale = finH;
	_root.vcam._rotation = finR;
	
	// Tracking logic
	if (lastTrackingFrame != -2) {
		if (_parent._currentframe > lastTrackingFrame) {
			lastTrackingFrame = _parent._currentframe;
			trace(finX + " " + finY + " " + (finW * oW / 100) + " " + (finH * oH / 100) + " " + finR);
		} else {
			lastTrackingFrame = -2;
			trace("Done! Copy everything above into \"camera_tracking.txt\".");
		}
	}
	
	// Applying final coordinates
	point.x = finX;
	point.y = finY;
	convertFromParent(this, point);
	viewfinder._x = point.x;
	viewfinder._y = point.y;
	
	viewfinder._xscale = (finW/100) / (_xscale/100) * 100;
	viewfinder._yscale = (finH/100) / (_yscale/100) * 100;
	viewfinder._rotation = finR - _rotation;
}

function attachParentToViewframe() {
	point.x = -oW / 2;
	point.y = -oH / 2;
	convertToParent(viewfinder, point);
	convertToParent(this, point);
	var oox = point.x;
	var ooy = point.y;
	var fox = 0;
	var foy = 0;
	
	point.x = oW / 2;
	point.y = -oH / 2;
	convertToParent(viewfinder, point);
	convertToParent(this, point);
	var oxx = point.x;
	var oxy = point.y;
	var fxx = sW;
	var fxy = 0;
	
	point.x = -oW / 2;
	point.y = oH / 2;
	convertToParent(viewfinder, point);
	convertToParent(this, point);
	var oyx = point.x;
	var oyy = point.y;
	var fyx = 0;
	var fyy = sH;
	
	var m:Matrix = _parent.transform.matrix;
	
	var p = (oyx * oxy) / (oxx * oyy);
	var px = oxx * (1 - p);
	var py = oyy * (1 - p);
	var pd = oox / px + ooy / py - (oxy * oox) / (oyy * px) - (oyx * ooy) / (oxx * py);
	var cx = (fox - ((fxx - (fyx / oyy) * oxy) / px) * oox - ((fyx - (fxx / oxx) * oyx) / py) * ooy) / (1 - pd);
	var cy = (foy - ((fxy - (fyy / oyy) * oxy) / px) * oox - ((fyy - (fxy / oxx) * oyx) / py) * ooy) / (1 - pd);
	m.a = (fxx - cx - ((fyx - cx) / oyy) * oxy) / px;
	m.b = (fxy - cy - ((fyy - cy) / oyy) * oxy) / px;
	m.c = (fyx - cx - ((fxx - cx) / oxx) * oyx) / py;
	m.d = (fyy - cy - ((fxy - cy) / oxx) * oyx) / py;
	
	_parent.transform.matrix = m;
	_parent._x = cx;
	_parent._y = cy;
}

function resetParentsPosition() {
	_parent._x = 0;
	_parent._y = 0;
	var m:Matrix = _parent.transform.matrix;
	m.a = 1;
	m.b = 0;
	m.c = 0;
	m.d = 1;
	_parent.transform.matrix = m;
}

var parallaxSymbols:Array;

function addParallaxSymbol(parallax:MovieClip) {
	if (parallaxSymbols == null) {
		parallaxSymbols = new Array();
	}
	parallaxSymbols.push(parallax);
}

function removeParallaxSymbol(parallax:MovieClip) {
	for (var i = 0; i < parallaxSymbols.length; i++) {
		if (parallaxSymbols[i] == parallax) {
			parallaxSymbols.splice(i, 1);
			return;
		}
	}
}

function moveParallaxes() {
	if (parallaxSymbols == null) {
		return;
	}
	var viewfinderLocation = getViewfinderLocation();
	for (var i = 0; i < parallaxSymbols.length; i++) {
		if (parallaxSymbols[i] == null) {
			parallaxSymbols.splice(i, 1);
			i--;
		} else {
			parallaxSymbols[i].putParallax(viewfinderLocation);
		}
	}
}

var sw = Stage.width;
var sh = Stage.height;

// For parallax
function getViewfinderLocation():Object {
	var point:Object = new Object();
	var loc:Object = new Object();
	
	// Getting location of the center
	point.x = 0;
	point.y = 0;
	convertToParent(viewfinder, point);
	convertToParent(this, point);
	loc.x = (point.x * 2) / sw - 1;
	loc.y = (point.y * 2) / sh - 1;
	
	// Getting location of top-left corner on stage
	point.x = -oW / 2;
	point.y = -oH / 2;
	convertToParent(viewfinder, point);
	convertToParent(this, point);
	var ox = point.x;
	var oy = point.y;
	
	// Getting location of top-right corner on stage
	point.x = oW / 2;
	point.y = -oH / 2;
	convertToParent(viewfinder, point);
	convertToParent(this, point);
	var xx = point.x;
	var xy = point.y;
	
	// Getting location of bottom-left corner on stage
	point.x = -oW / 2;
	point.y = oH / 2;
	convertToParent(viewfinder, point);
	convertToParent(this, point);
	var yx = point.x;
	var yy = point.y;
	
	// Was not tested. I was slightly braindead when i wrote this.
	var dwx = xx - ox;
	var dwy = xy - oy;
	var dhx = yx - ox;
	var dhy = yy - oy;
	
	loc.pw = Math.sqrt(dwx * dwx + dwy * dwy);
	loc.ph = Math.sqrt(dhx * dhx + dhy * dhy);
	
	loc.z = 1 - loc.pw / sw;
	
	return loc;
}

function activateShakeController() {
	var shakeController = searchForMovieClip(_parent, "isAShakeControllerByShuriken255", 0);
	if (shakeController != null) {
		shakeController.searchForShake();
	}
}

function activateBindingController() {
	var bindingController = searchForMovieClip(_parent, "isABindingByShuriken255", 0);
	if (bindingController != null) {
		bindingController.searchForCamera();
		bindingController.onEnterFrame();
	}
}

// Searches for single object with certain indetifier
function searchForMovieClip(where:MovieClip, identifier:String, level:Number):MovieClip {
	if (level > 0) {
		level--;
		for (var clipName in where) {
			if (where[clipName] instanceof MovieClip) {
				var foundClip:MovieClip = searchForMovieClip(where[clipName], identifier, level);
				if (foundClip != null) {
					return foundClip;
				}
			}
		}
	} else {
		for (var clipName in where) {
			if (where[clipName] instanceof MovieClip) {
				var clip:MovieClip = where[clipName];
				if (clip[identifier]) {
					return clip;
				}
			}
		}
	}
	return null;
}

// Searches for all objects with certain identifier
function searchForMovieClips(where:MovieClip, identifier:String, level:Number):Array {
	var foundClips:Array = new Array();
	if (level > 0) {
		level--;
		for (var clipName in where) {
			if (where[clipName] instanceof MovieClip) {
				var newFoundClips:Array = searchForMovieClips(where[clipName], identifier, level);
				foundClips = foundClips.concat(newFoundClips);
			}
		}
	} else {
		for (var clipName in where) {
			if (where[clipName] instanceof MovieClip) {
				var clip:MovieClip = where[clipName];
				if (clip[identifier]) {
					foundClips.push(clip);
				}
			}
		}
	}
	return foundClips;
}

function initializeParallaxes() {
	var parallaxes = searchForMovieClips(_parent, "isParallaxByShuriken255", 1);
	for (var i = 0; i < parallaxes.length; i++) {
		parallaxes[i].initialized = parallaxes[i].tryToInit();
	}
}

initializeParallaxes();
activateShakeController();
activateBindingController();
onEnterFrame();
