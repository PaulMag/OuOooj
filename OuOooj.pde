
// colorpalette
color bgColor = #FFA28B;

// objects
Game game;



void setup() {
  size(480, 480);
  frame.setResizable(true);
  
  colorMode(HSB, 255);
 
  game = new Game();
}

void draw() {
  background(bgColor);
 
  game.update();
  
  // draw fps
  fill(0);
  text(frameRate, 0, 12); 
}


