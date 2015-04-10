

interface WorldInterface {
  
  public float getHeightAt(PVector v);
  public final float PIXPERM = 2f;
  
}



class World /*implements WorldInterface*/ {
  
  public final float PIXPERM = 100f;
  public final float GRAVITY = 1f;
  public final float ELECTRIC = -1f;
  
  public float noiseSize = 0.005;
  public float noiseHeight = 0.999;
  final int TERRAIN_PIXELS_HIGH = 20;
  
  private final float[] heightmap;
  public final int WIDTH;
  public final int HEIGHT;
  public final int SIZE;
  
  PImage graphics;
  ArrayList<Player> players;
 
  World(int w, int h, ArrayList<Player> players) {
    this.players = players;
    heightmap = new float[w*h];
    WIDTH = w;
    HEIGHT = h;
    SIZE = w * h;
    
    graphics = createGraphics(w, h);
    
    test();
  }
 
  float getHeightAt(PVector v) {
    float r = noise(v.x, v.y, frameCount*0.1) * noiseHeight;
    return r;
  }
 
  float getHeightAt(float x, float y) {
    return noise(x, y, frameCount*0.1) * noiseHeight;
  }
 
  void update() {
   
  } 
  
  void test() {

    for (int i=0; i<heightmap.length; i++) { 
      
      float x = i % WIDTH;
      float y = i / WIDTH;
      
      x *= noiseSize;
      y *= noiseSize;
      
      float h = getHeightAt(x, y);    
      h *= noiseHeight;  
      
      heightmap[i] = h;
    }
  }
  
  void draw() {
    
    test();
    

    graphics.loadPixels();
   
    
    
    for (int i=0; i<SIZE; i++) {
     
      
      color c = color(heightmap[i]*125,200,255-heightmap[i]*255f);
      //int h = (int) map(heightmap[i], 0, 1f, 0f, TERRAIN_PIXELS_HIGH);
      graphics.pixels[i] = c;
    
      /*   
      for (int j=0; j<h; j++) {
         graphics.pixels[max(i - j*WIDTH, 0)] = c;
      }
      */
    }
   
    graphics.updatePixels();
    
    imageMode(CENTER);
    image(graphics, width/2, height/2); 
  }
  

}
