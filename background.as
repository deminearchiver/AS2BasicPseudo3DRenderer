/*
Copyright © DeMineArchiver 2022
ActionScript2 only!
Macromedia Flash 8 +

Instructions:
https://deminearchiver.github.io/AS2BasicPseudo3DRenderer/
*/

// VCam import
var vcam:MovieClip = new MovieClip();

var fillColor = 0xD0CEBF;
var stripeColor = 0xB4ADA0;

// Perspective values (do not change X and Y!)
var perspectiveDivider = 20;
var perspectiveX = 400;
var perspectiveY = 200;

// Draw a line with unlimited amount of segments
/*
points: an array of points to draw through
obj: MovieClip in which you want to draw
closed: determines if the path will be closed or not
*/
function drawLine(points:Array, obj:MovieClip, closed:Boolean) {
	if(arguments.length == 2) {
		closed = false;
	}
	var sP = points[0];
	for(var i = 0; i<points.length;i++) {
		var p1 = points[i];
		if(!points[i+1]) {
			if(closed == false) {
				return;
			} else{
				drawSegment(p1.x,p1.y,p1.z,sP.x,sP.y,sP.z, obj);
				return;
			}
		}
		var p2 = points[i+1];
		drawSegment(p1.x,p1.y,p1.z,p2.x,p2.y,p2.z,obj);
	}
}

// Draws a closed filled object
/* 
points: an array of points to draw through
obj: MovieClip in which you want to draw
rgb: solid color of the fill
alpha: the alpha value of the fill
*/
function drawPolygon(points:Array, obj:MovieClip, rgb:Number, alpha:Number) {
	var sP = projectPoint(points[0]);
	obj.beginFill(rgb, alpha);
	obj.moveTo(sP.x, sP.y);
	points.shift();
	for(var i = 0;i<points.length;i++) {
		var p = projectPoint(points[i]);
		obj.lineTo(p.x, p.y);
	}
	obj.endFill();
};

// Do not touch! Technical Functions!
function projectPoint(p) {
	p.z /= perspectiveDivider;
   	p.x = perspectiveX + (p.x - perspectiveX) / p.z;
   	p.y = perspectiveY + (p.y - perspectiveY) / p.z;
	var point = {x: p.x, y: p.y};
	return point;
}
function drawSegment(x1, y1, z1, x2, y2, z2, obj:MovieClip) {
	var p1 = projectPoint({x: x1, y: y1, z: z1});
	var p2 = projectPoint({x: x2, y: y2, z: z2});
   	obj.moveTo(p1.x,p1.y);
   	obj.lineTo(p2.x,p2.y);
}
function updatePerspective() {
	perspectiveX = vcam._x + vcam._xscale / 2;
   	perspectiveY = vcam._y + vcam._yscale / 2;
}

onEnterFrame = function()
{
   updatePerspective();
   
   //Example of Drawing Object creation:
   _root.createEmptyMovieClip("lines", _root.getDepth() - 1);
   _root.lines.lineStyle(1, 0x000000, 100, true, "normal", "square", "miter", 1);
   
   // Draw down here
   
   
   
};
onEnterFrame();

// End of the renderer script
