

float flash = 0f;

// colorpalette
//color bgColor = #FFD8DD;
//color bgColor = #F5B2B8;
//color bgColor = #FFFA9D;
//color bgColor = #CBCBCB;
//color bgColor = #1F2F39;
color bgColor = #322E46;

// objects
Game game;

PImage orb;

PImage light;



void setup() {
  size(480, 480);
  frame.setResizable(true);
  noSmooth();
  imageMode(CENTER);

  colorMode(HSB, 255);

  orb = loadImage("ball.png");
  light = loadImage("light.png");

  game = new Game();
}

void draw() {
  background(bgColor);

  /*
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
  */

  if (raise)
    game.players.get(0).moveZ = 1;
  else if (lower)
    game.players.get(0).moveZ = -1;
  else
    game.players.get(0).moveZ = 0;

  /*
  if (left2 || right2) {
   game.players.get(1).moveX = (left2) ? -1 : 1;
   } else {
   game.players.get(1).moveX = 0;
   }
   
   if (up2 || down2) {
   game.players.get(1).moveY = (up2) ? -1 : 1;
   } else {
   game.players.get(1).moveY = 0;
   }
   
   game.players.get(1).moveZ = (raise2) ? 1 : 0;
   */





  game.loop();

  for (Player p : game.players) {
    if (dist(p.pos.x, p.pos.y, game.world.WIDTH/2, game.world.HEIGHT/2) < 8) {
       game = new Game(); 
       flash = 1f;
    }
  }
  
  
  flash = lerp(flash, 0f, 0.07);
  if (flash < 0.02)
    flash = 0f;
  
  noStroke();
  
  fill(color(255,0,255,flash*255));
  rect(0,0,width,height);

  // draw fps
  fill(0);
  //text(frameRate, 0, 12);
}

public float gaussian(float x, float y, float x0, float y0, float sigma) {
  return exp(- (pow(x - x0, 2) + pow(y - y0, 2)) / (2*sigma*sigma));
}
public float gaussian(PVector v, PVector v0, float sigma) {
  return gaussian(v.x, v.y, v0.x, v0.y, sigma);
}

boolean raise = false;
boolean lower = false;
boolean left = false;
boolean right = false;
boolean up = false;
boolean down = false;

boolean raise2 = false;
boolean left2 = false;
boolean right2 = false;
boolean up2 = false;
boolean down2 = false;


void keyPressed() {
  if (keyCode == LEFT) 
    left = true;
  if (keyCode == RIGHT) 
    right = true;
  if (keyCode == UP) 
    up = true;
  if (keyCode == DOWN) 
    down = true;
  if (key == 'z')
    lower = true;
  if (key == 'x' || key == ' ')
    raise = true;

  if (key == 'a') 
    left2 = true;
  if (key == 'd') 
    right2 = true;
  if (key == 'w') 
    up2 = true;
  if (key == 's') 
    down2 = true;
  if (keyCode == SHIFT)
    raise2 = true;
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
  if (key == 'z')
    lower = false;
  if (key == 'x' || key == ' ')
    raise = false;

  if (key == 'a') 
    left2 = false;
  if (key == 'd') 
    right2 = false;
  if (key == 'w') 
    up2 = false;
  if (key == 's') 
    down2 = false;
  if (keyCode == SHIFT)
    raise2 = false;
    
  if (keyCode == 'R') {
    game = new Game();
    flash = 1f;
  }
}

