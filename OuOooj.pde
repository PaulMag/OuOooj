
// colorpalette
color bgColor = #FFA28B;

// objects
Game game;
PImage orb;


void setup() {
  size(480, 480);
  frame.setResizable(true);
  noSmooth();
  imageMode(CENTER);
  
  colorMode(HSB, 255);
 
  orb = loadImage("ball.png");
  
  game = new Game();
}

void draw() {
  background(bgColor);
 
  
  game.update();
  
  // draw fps
  fill(0);
  text(frameRate, 0, 12); 
}


