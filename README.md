# ActionScript 2 Pseudo 3D Renderer
### A 3D vector renderer written in ActionScript2 and integrated with the [Advanced Virtual Camera](https://www.youtube.com/watch?v=JARa5qIN4x8&t=125s)

## Requirements
1. Macromedia Flash 8 - Adobe Flash CS6
2. ActionScript 2 set in publish settings
3. Basic knowledge of ActionScript

## Setup

### Getting the code
Download the Renderer and the VCam code from here:
1. [VCam](https://deminearchiver.github.io/AS2BasicPseudo3DRenderer/vcam.as?raw=true)
2. [Renderer](https://deminearchiver.github.io/AS2BasicPseudo3DRenderer/background.as?raw=true)

### Installing

1. Get the Advanced Virtual Camera for AS2 from [*Google Drive*](https://drive.google.com/file/d/1J3w_2s23ik-YjBWvZ1yMlzRFW4WOBuaF)
2. Following [*this tutorial*](https://www.youtube.com/watch?v=JARa5qIN4x8), setup the Camera and the Control Panel
3. Enter the Camera symbol (**"SHURIKEN255_CAMERA"**), right-click on the frame with an **"*a*"** symbol on it, and select **"Actions"**
4. In the opened window (**"Actions"**), select all the code and delete it. After that, replace it with the code from [**vcam.as**](https://deminearchiver.github.io/AS2BasicPseudo3DRenderer/vcam.as?raw=true)
5. Go to the root level of your scene, create a new layer. On the first blank of the layer open the **"Actions"** panel again and paste in the code from [**renderer.as**](https://deminearchiver.github.io/AS2BasicPseudo3DRenderer/background.as?raw=true)

It should be properly setup now!

## Usage

### In order to use the renderer, you will have to draw lines and polygons using code
#### Open the "Actions" panel for the frame with the Renderer code and scroll down until you see `//Draw down here` line of code. All your code for drawing will go below that line

### Creating a drawing object
To create a drawing object, type in the following above the `//Draw down here` line:
```ActionScript
    _root.createEmptyMovieClip("name", root.getDepth() - depth)
```
, where `name` is the name you will have to reference later, and `depth` is the Z level you want your layer to be at.

### Drawing
#### Lines:
Before drawing lines, you will have to set a linestyle for your Drawing Object like this:
```ActionScript
    _root.name.lineStyle(thickness,rgb,alpha,pixelHinting,noScale,capsStyle,jointStyle,miterLimit);
```
You can read about all those values in the [ActionScript2 documentation](https://homepage.divms.uiowa.edu/~slonnegr/flash/ActionScript2Reference.pdf#lineStyle%20(MovieClip.lineStyle%20method))

To draw a line type in the following line of code:
```ActionScript
    drawLine(points, object, closed);
```
, where `object` is the name of the Drawing Object you have created in the last step, and `closed` (can either be `true` or `false`) determines whether or not the path should be closed.

`points` is the parameter where you define all the coordinates for the path. It should look like this:
`drawLine([{},{},{},...{}], object, closed)` (each pair of curly braces is one point, you can have as many as you want).

Inside of each point you need to specify its x, y and z coordinates:
(one point example) `{x: 200, y: 400, z: 50}`

###### You need at least 2 points for the code to work.

#### Polygons
 WIP
