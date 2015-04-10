
// colorpalette
color bgColor = #FFA28B;

// objects
World world;



void setup() {
  size(480, 480);
  frame.setResizable(true);
  
  colorMode(HSB, 255);
  
  world = new World(width, height);
}

void draw() {
  background(bgColor);
 
  world.draw(); 
  
  // draw fps
  fill(0);
  text(frameRate, 0, 12); 
}


