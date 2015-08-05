
// canvas setup
var c = document.getElementById("theCanvas");
var ctx = c.getContext("2d");

// middle of view window
var w = c.width;
var h = c.height;
var offset = w/2;
var pad = 50;

// canvas font settings
ctx.font = (10 * h/1000) + "px arial";

//min and max square roots of word frequencies
var M = 9.949, m = 2.24;

// animation
var	timer = null;
var delay = 20;

var zoom = 0.1;
var maxFontSize = 30;
var maxHeight = 5000;
var maxWidth = 5000;

var drawCloud = function(){
 // document.write(keysDown);
  if (keysDown[107] || keysDown[187]){
    if (c.height < maxHeight){
      c.height = Math.floor(c.height*(1 + zoom));
	  c.width = Math.floor(c.width*(1 + zoom));
	  w = c.width;
	  h = c.height;
	}
  }
  if (keysDown[109] || keysDown[189]){
    c.height *= 1 - zoom;
	c.width *= 1 - zoom;
	w = c.width;
	h = c.height;
  }  
  for (i=0; i < words.length; i++){
    var sizeFactor = ((10 * h/1000) > maxFontSize) ? maxFontSize : (10 * h/1000);
    ctx.font = "bold " + sizeFactor * (Math.sqrt(counts[i])/(2*(M-m)) + ( 1- M/(2*(M-m)))) + "px arial";
	var x = 255*(1 - counts[i]/100);
	ctx.fillStyle = "rgb(" + x + "," + x + "," + x + ")";
    ctx.fillText(words[i], pad + (w-2*pad) * (points[i][0]+1000)/2000, pad + (h-2*pad) * (points[i][1]+1000)/2000);
  }
}

// key interaction
var keysDown = {};

document.onkeydown = function(e){
  e = e || window.event;
  keysDown[e.keyCode] = true;
  //document.write(e.keyCode);
  drawCloud();
}

document.onkeyup = function(e){
  e = e || window.event;
  keysDown[e.keyCode] = false;
  drawCloud();
}

// entry point
drawCloud();
