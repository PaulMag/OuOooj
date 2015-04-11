
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
 
  if (left || right) {
    game.players.get(0).moveX = (left) ? -1 : 1;
  } else {
    game.players.get(0).moveX = 0;
  }
  
  if (up || down) {
    game.players.get(0).moveY = (up) ? -1 : 1;
  } else {
    game.players.get(0).moveY = 0;
  }
    
  
  game.update();
  
  println(game.players.get(0).moveY);
  
  
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



boolean left = false;
boolean right = false;
boolean up = false;
boolean down = false;

void keyPressed() {
  if (keyCode == LEFT) 
    left = true;
  if (keyCode == RIGHT) 
    right = true;
  if (keyCode == UP) 
    up = true;
  if (keyCode == DOWN) 
    down = true;
}
  
void keyReleased() {
  if (keyCode == LEFT) 
    left = false;
  if (keyCode == RIGHT) 
    right = false;
  if (keyCode == UP) 
    up = false;
  if (keyCode == DOWN) 
    down = false;
}
