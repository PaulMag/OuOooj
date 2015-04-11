
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

public float gaussian(float x, float y, float x0, float y0, float sigma) {
  return exp(- (pow(x - x0, 2) + pow(y - y0, 2)) / (2*sigma*sigma));
}
public float gaussian(PVector v, PVector v0, float sigma) {
  return gaussian(v.x, v.y, v0.x, v0.y, sigma);
}
