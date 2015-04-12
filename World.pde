

class World {



  color[] gradient;
  color[] gradient2;


  public final int SCALE = 2;

  public final float PIXPERM = 100f;  // Pixels per "meter".
  public final float GRAVITY = 500.0f;
  public final float ELECTRIC = 0f;//-2000f; //-0.03f;
  public final float AIR = 0.4;

  float TERRAIN_CHANGE_SPEED = .000;
  final float TERRAIN_SIZE = 1.0;
  float TERRAIN_RES = 0.03;
  final int MAX_PIXELS_HIGH = 120;
  final int MAX_BUILD_HEIGHT = 100;



  final int WIDTH;
  final int HEIGHT;
  final int SIZE;
  final PVector MIDDLE;

  ArrayList<Player> players;
  float[] buildMap;

  PGraphics graphics;
  PGraphics circleMask;

  World(int w, int h, ArrayList<Player> p) {

    noiseSeed((int) random(329075));

    players = p;
    WIDTH = w;
    HEIGHT = h;
    SIZE = w*h;
    MIDDLE = new PVector(WIDTH/2, HEIGHT/2);

    graphics = createGraphics(w, h*2);
    buildMap = new float[WIDTH*HEIGHT];

    circleMask = createGraphics(w, h);
    circleMask.beginDraw();
    circleMask.noSmooth();
    circleMask.background(0);
    circleMask.noStroke();
    circleMask.fill(255);
    circleMask.ellipse(w/2, h/2, w, h);
    circleMask.endDraw();
    circleMask.loadPixels(); 
    
    String[] s = {"grad0.png", "grad0.png", "grad0.png"};
    String fileName = s[(int) random(3)];

    PImage gradientImg = loadImage(fileName);
    PImage gradientImg2 = loadImage("gradient2.png");
    gradient = new color[gradientImg.height];
    gradient2 = new color[gradientImg2.height];
    gradientImg.loadPixels();
    gradientImg2.loadPixels();

    for (int i=0; i<gradientImg.height; i++) {
      gradient[i] = gradientImg.pixels[i*gradientImg.width];
      gradient2[i] = gradientImg2.pixels[i*gradientImg2.width];
    } 

    gradientImg.loadPixels();
    gradientImg2.loadPixels();
    
    TERRAIN_CHANGE_SPEED = (random(1f) < 0.1) ? random(0.001, 0.0001) : 0;
    TERRAIN_RES = random(0.0019, 0.04);
  }

  void update() {

    PVector centerOfGravity = new PVector(0, 0);
    for (Player p : players) {
      centerOfGravity.add(p.pos);
    }
    centerOfGravity.div(players.size());

    /*
    for (int i=0; i<buildMap.length; i++) {
     buildMap[i] *= 0.9 * game.dt;
     }
     */
  } 

  /*
  float getHeightAt(PVector v) {
   float r = noise(v.x*TERRAIN_SIZE, v.y*TERRAIN_SIZE, frameCount*TERRAIN_CHANGE_SPEED);
   return r;
   }
   
   float getHeightAt(float x, float y) {
   return noise(x*TERRAIN_SIZE, y*TERRAIN_SIZE, frameCount*TERRAIN_CHANGE_SPEED);
   }
   
   */

  float getHeightAt(PVector v) {
    try {
      return noise(v.x*TERRAIN_RES, v.y*TERRAIN_RES, frameCount*TERRAIN_CHANGE_SPEED)*TERRAIN_SIZE + buildMap[(int) v.x + (int) v.y * WIDTH];
    } 
    catch (Exception e) {
      return noise(v.x*TERRAIN_RES, v.y*TERRAIN_RES, frameCount*TERRAIN_CHANGE_SPEED)*TERRAIN_SIZE;
    }
  }

  float getHeightAt(float x, float y) {
    try {
      return noise(x*TERRAIN_RES, y*TERRAIN_RES, frameCount*TERRAIN_CHANGE_SPEED)*TERRAIN_SIZE + buildMap[(int) x + (int) y * WIDTH];
    } 
    catch (Exception e) {
      return noise(x*TERRAIN_RES, y*TERRAIN_RES, frameCount*TERRAIN_CHANGE_SPEED)*TERRAIN_SIZE;
    }
  }



  // RAISE/LOWER

  void build(float heightPerSec, PVector pos, float sigma) {
    for (int x=int (pos.x-3*sigma); x<int(pos.x+3*sigma); x++) {
      if (x >= 0 && x < WIDTH) {
        for (int y=int (pos.y-3*sigma); y<int(pos.y+3*sigma); y++) {
          if (y >= 0 && y < HEIGHT) {
            buildMap[y * WIDTH + x] += gaussian(x, y, pos.x, pos.y, sigma) * heightPerSec * game.dt;
            buildMap[y * WIDTH + x] = constrain(buildMap[y * WIDTH + x], 0, MAX_BUILD_HEIGHT);
          }
        }
      }
    }
  }



  void build2(float heightPerSec, PVector pos, float sigma) {
    for (int x=int (pos.x-3*sigma); x<int(pos.x+3*sigma); x++) {
      if (x >= 0 && x < WIDTH) {
        for (int y=int (pos.y-3*sigma); y<int(pos.y+3*sigma); y++) {
          if (y >= 0 && y < HEIGHT) {
            buildMap[y * WIDTH + x] += gaussian(x, y, pos.x, pos.y, sigma);
          }
        }
      }
    }
  }


  void draw() {

    for (int i=0; i<buildMap.length; i++) {
      buildMap[i] *= 0.995;
    }

    //Player[][] dp = new Player[HEIGHT][0];

    Player[] dp = new Player[HEIGHT];

    for (Player p : players) { 
      int d = (int) p.pos.y;
      if (d >= 0 && d < HEIGHT) {
        dp[d] = p;
      }
    }

    float[] heightmap = new float[WIDTH*HEIGHT];

    for (int i=0; i<heightmap.length; i++) {
      heightmap[i] = getHeightAt(i%WIDTH, i/WIDTH);
    }

    // offset players
    int ox = width/2 - graphics.width/2;
    int oy = height/2 - graphics.height/2;

    graphics.beginDraw();
    graphics.clear();
    graphics.endDraw();

    graphics.loadPixels();
    int s = graphics.width * graphics.height;
    int offset = s/2;
    color c;

    for (int i=0; i<offset; i++) {

      if (circleMask.pixels[i] == #FFFFFF) { // inside circle -> draw

        float h = heightmap[i];    
        int pixelsHigh = int(h*MAX_PIXELS_HIGH);

        //c = color(110, 150-h*75, 120 + h*150f);
        //graphics.pixels[max(offset + i, 0)] = c;

        boolean cut = false;

        if (circleMask.pixels[min(i+WIDTH, SIZE-1)] == #000000) { 
          cut = true;
        }

        color[] grad = ((heightmap[i] - noise((i%WIDTH)*TERRAIN_RES, (i/WIDTH)*TERRAIN_RES, frameCount*TERRAIN_CHANGE_SPEED)*TERRAIN_SIZE) > 0.01) ? gradient2 : gradient; 

        for (int j=0; j<pixelsHigh; j++) {
          int p = (int) map(j, 0, MAX_PIXELS_HIGH, 0, gradient.length);
          p = constrain(p, 0, gradient.length-1);
          graphics.pixels[max(offset + i - j*graphics.width, 0)] = (cut) ? color(0, 0, 0, 0) : grad[p];
        }


        for (Player p : players) {
          if ((int) p.pos.y == i/WIDTH) {
            //if (dp[i/WIDTH] != null) {
            //for (int k=0; k<dp[i/WIDTH].length; k++) {
            //Player p = p;//[k];
            float ph = getHeightAt(p.pos.x, p.pos.y)*MAX_PIXELS_HIGH;
            graphics.updatePixels();
            graphics.imageMode(CENTER);
            //graphics.tint(p.playerColor);
            graphics.image(orb, p.pos.x, HEIGHT + p.pos.y - ph /*- p.RAD + cos(frameCount*0.1)*2 + 5*/ - 2);
            //graphics.noTint();
            graphics.loadPixels();
            //}
          }
        }   

        if (i/WIDTH == HEIGHT/2) {
          graphics.updatePixels();
          graphics.imageMode(CENTER);
          //graphics.tint(p.playerColor);
          graphics.image(light, WIDTH/2, HEIGHT/2 + pixelsHigh + light.height/2, light.width, light.height*2);
          graphics.noTint();
          graphics.loadPixels();
        }
      } else {
        graphics.pixels[offset+i] = color(0, 0, 0, 0);
      }
    }

    graphics.updatePixels();

    // shadow?
    /*
    tint(200,100,125,10);
     image(graphics, width/2 - mouseX+8 + width/2, height/SCALE - graphics.height/SCALE + mouseY+8, graphics.width*SCALE*1.2, graphics.height*SCALE);
     image(graphics, width/2 - mouseX+16 + width/2, height/SCALE - graphics.height/SCALE + mouseY+16, graphics.width*SCALE*1.25, graphics.height*SCALE);
     image(graphics, width/2 - mouseX + width/2, height/SCALE - graphics.height/SCALE + mouseY, graphics.width*SCALE, graphics.height*SCALE);
     noTint();
     */

    image(graphics, width/2, height/SCALE - graphics.height/SCALE/2 + 30 + cos(frameCount*0.01)*4f, graphics.width*SCALE, graphics.height*SCALE);
  }
}



