

class World {
  
  public final float PIXPERM = 100f;  // Pixels per "meter".
  public final float GRAVITY = 3f;
  public final float ELECTRIC = -0.03f;
  public final float AIR = 0.1;
  
  final float TERRAIN_CHANGE_SPEED = .005;
  final float TERRAIN_SIZE = 0.02;
  final int MAX_PIXELS_HIGH = 50;
  
  final int WIDTH;
  final int HEIGHT;
  final int SIZE;
  
  ArrayList<Player> players;
  
  PGraphics graphics;
  PGraphics circleMask;
  
  World(int w, int h, ArrayList<Player> p) {
    players = p;
    WIDTH = w;
    HEIGHT = h;
    SIZE = w*h;
    
    graphics = createGraphics(w, h*2);
    
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
  
  void draw() {
    
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
     
    graphics.clear();
    graphics.loadPixels();
    int s = graphics.width * graphics.height;
    int offset = s/2;
    color c;
    
    for (int i=0; i<s/2; i++) {
      if (circleMask.pixels[i] == #FFFFFF) {
        
        float h = heightmap[i];
       
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
      } else {
        graphics.pixels[offset+i] = color(0,0,0,0);
      }  
    }
    
    graphics.updatePixels();
    
    image(graphics, width/2, height/2 - graphics.height/2, graphics.width*2, graphics.height*2);
  }
}


    
