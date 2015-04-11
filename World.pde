

class World {
  
  
  
  public final float PIXPERM = 100f;  // Pixels per "meter".
  public final float GRAVITY = 15f;
  public final float ELECTRIC = 0f; //-0.03f;
  public final float AIR = 0.5;
  
  final float TERRAIN_CHANGE_SPEED = .0000;
  final float TERRAIN_SIZE = 0.04;
  final int MAX_PIXELS_HIGH = 30;
  
  final int WIDTH;
  final int HEIGHT;
  final int SIZE;
  
  ArrayList<Player> players;
  float[] buildMap;
  
  PGraphics graphics;
  PGraphics circleMask;
  
  World(int w, int h, ArrayList<Player> p) {
    players = p;
    WIDTH = w;
    HEIGHT = h;
    SIZE = w*h;
    
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

  } 
  
  float getHeightAt(PVector v) {
    float r = noise(v.x*TERRAIN_SIZE, v.y*TERRAIN_SIZE, frameCount*TERRAIN_CHANGE_SPEED);
    return r;
  }

  float getHeightAt(float x, float y) {
    return noise(x*TERRAIN_SIZE, y*TERRAIN_SIZE, frameCount*TERRAIN_CHANGE_SPEED);
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
    
    for (int i=0; i<lightning.length-1-WIDTH; i++) {
      float x = heightmap[(i + SIZE + 1)%SIZE] - heightmap[(i + SIZE - 1)%SIZE];
      float y = heightmap[(i + SIZE + WIDTH)%SIZE] + heightmap[(i + SIZE - WIDTH)%SIZE];
      PVector v = new PVector(x, y);
      float a = map(v.heading(), -PI, PI, 0f, 1f);
      //a *= v.mag();
      lightning[i] = a;
    }
    
    int ox = width/2 - graphics.width/2;
    int oy = height/2 - graphics.height/2;
     
    graphics.clear();
    graphics.loadPixels();
    int s = graphics.width * graphics.height;
    int offset = s/2;
    color c;
    
    for (int i=0; i<s/2; i++) {
      if (circleMask.pixels[i] == #FFFFFF) {
        
        float h = heightmap[i] + buildMap[i];
       
        int pixelsHigh = int(h*MAX_PIXELS_HIGH);
        
        c = color(100, 70, heightmap[i]*255f);
        graphics.pixels[max(offset + i, 0)] = c;
        
        if (circleMask.pixels[min(i+WIDTH, SIZE-1)] == #000000) {
          c = color(0,0,0,0);
        }
   
        for (int j=0; j<pixelsHigh; j++) {
          //c = color(100, 100, lightning[i]*255);
          graphics.pixels[max(offset + i - j*graphics.width, 0)] = c;
        }
        
        if (dp[i/WIDTH] != null) {
          Player p = dp[i/WIDTH];
          float ph = getHeightAt(p.pos.x, p.pos.y)*MAX_PIXELS_HIGH;
          graphics.updatePixels();
          graphics.image(orb, p.pos.x, HEIGHT + p.pos.y - ph - 5);
          graphics.loadPixels();
        }
        
      
      } else {
        graphics.pixels[offset+i] = color(0,0,0,0);
      }  
    }
    
    graphics.updatePixels();
    
    image(graphics, width/2, height/2 - graphics.height/2, graphics.width*2, graphics.height*2);
  }
}


    
