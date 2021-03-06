

class World {
  
  public final int SCALE = 3;
  
  public final float PIXPERM = 100f;  // Pixels per "meter".
  public final float GRAVITY = 500.0f;
  public final float ELECTRIC = -2000f; //-0.03f;
  public final float AIR = 0.9;
  
  final float TERRAIN_CHANGE_SPEED = .045;
  final float TERRAIN_SIZE = 0.4;
  final float TERRAIN_RES = 0.03;
  final int MAX_PIXELS_HIGH = 50;
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
  }
  
  void update() {

    PVector centerOfGravity = new PVector(0, 0);
    for (Player p : players) {
      centerOfGravity.add(p.pos);
    }
    centerOfGravity.div(players.size());
    
    for (int i=0; i<buildMap.length; i++) {
      buildMap[i] *= 0.9 * game.dt;
    }
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
    } catch (Exception e) {
      return noise(v.x*TERRAIN_RES, v.y*TERRAIN_RES, frameCount*TERRAIN_CHANGE_SPEED)*TERRAIN_SIZE; 
    }
  }
  
  float getHeightAt(float x, float y) {
    try {
      return noise(x*TERRAIN_RES, y*TERRAIN_RES, frameCount*TERRAIN_CHANGE_SPEED)*TERRAIN_SIZE + buildMap[(int) x + (int) y * WIDTH];
    } catch (Exception e) {
      return noise(x*TERRAIN_RES, y*TERRAIN_RES, frameCount*TERRAIN_CHANGE_SPEED)*TERRAIN_SIZE; 
    }
  }

  
  
  void build(float heightPerSec, PVector pos, float sigma) {
    for (int x=int(pos.x-3*sigma); x<int(pos.x+3*sigma); x++) {
      if (x >= 0 && x < WIDTH) {
        for (int y=int(pos.y-3*sigma); y<int(pos.y+3*sigma); y++) {
          if (y >= 0 && y < HEIGHT) {
            buildMap[y * WIDTH + x] += gaussian(x, y, pos.x, pos.y, sigma) * heightPerSec * game.dt;
          }
        }
      }
    }
  }
  

  void draw() {
    
    Player[] dp = new Player[HEIGHT];
    
    for (Player p : players) { 
      int d = (int) p.pos.y;
      if (d > 0 && d < HEIGHT) {
        dp[d] = p;
      }
    }
    
    float[] heightmap = new float[WIDTH*HEIGHT];
    float[] lightning = new float[WIDTH*HEIGHT];
    
    for (int i=0; i<heightmap.length; i++) {
      heightmap[i] = getHeightAt(i%WIDTH, i/WIDTH);
    }
    
    /*
    for (int i=0; i<lightning.length-1-WIDTH; i++) {
      float x = heightmap[(i + SIZE + 1)%SIZE] - heightmap[(i + SIZE - 1)%SIZE];
      float y = heightmap[(i + SIZE + WIDTH)%SIZE] + heightmap[(i + SIZE - WIDTH)%SIZE];
      PVector v = new PVector(x, y);
      float a = map(v.heading(), -PI, PI, 0f, 1f);
      //a *= v.mag();
      lightning[i] = a;
    }
    */
    
    int ox = width/2 - graphics.width/2;
    int oy = height/2 - graphics.height/2;
    
    graphics.beginDraw();
    graphics.clear();
    graphics.endDraw();
    
    graphics.loadPixels();
    int s = graphics.width * graphics.height;
    int offset = s/2;
    color c;
    
    for (int i=0; i<s/2; i++) {
      if (circleMask.pixels[i] == #FFFFFF) {
        
        float h = getHeightAt(i%WIDTH, i/WIDTH);
       
        int pixelsHigh = int(h*MAX_PIXELS_HIGH);
        
        
        c = color(100, 150-h*75, 120 + h*300f);
        graphics.pixels[max(offset + i, 0)] = c;
        
        
        boolean cut = false;
        if (circleMask.pixels[min(i+WIDTH, SIZE-1)] == #000000) {
          cut = true;
        }
   
        for (int j=0; j<pixelsHigh; j++) {
          //c = color(100, 100, lightning[i]*255);
          graphics.pixels[max(offset + i - j*graphics.width, 0)] = (cut) ? color(0,0,0,0) : color(100, 150-h*75, 120 + h*300f);
        }
       
        
        if (dp[i/WIDTH] != null) {
          Player p = dp[i/WIDTH];
          float ph = getHeightAt(p.pos.x, p.pos.y)*MAX_PIXELS_HIGH;
          graphics.updatePixels();
          graphics.imageMode(CENTER);
          graphics.tint(p.playerColor);
          graphics.image(orb, p.pos.x, HEIGHT + p.pos.y - ph - p.RAD + cos(frameCount*0.1)*2 + 5);
          graphics.noTint();
          graphics.loadPixels();
        }
        
        
      
      } else {
        graphics.pixels[offset+i] = color(0,0,0,0);
      }  
    }
    
    graphics.updatePixels();
    
    image(graphics, width/2, height/SCALE - graphics.height/SCALE, graphics.width*SCALE, graphics.height*SCALE);
  }
}


    
