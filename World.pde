

interface WorldInterface {
  
  public float getHeightAt(PVector v);
  public final float PIXPERM = 2f;
  
}



class World /*implements WorldInterface*/ {
  
  public float noiseSize = 0.005;
  public float noiseHeight = 0.999;
  final int TERRAIN_PIXELS_HIGH = 20;
  
  private final float[] heightmap;
  public final int WIDTH;
  public final int HEIGHT;
  public final int SIZE;
  
  PImage graphics;
 
  World(int w, int h) {
    heightmap = new float[w*h];
    WIDTH = w;
    HEIGHT = h;
    SIZE = w * h;
    
    
    
    graphics = createGraphics(w, h);
    
    test();
  }
 
 
  void update() {
   
  } 
  
  void test() {

    for (int i=0; i<heightmap.length; i++) { 
      
      float x = i % WIDTH;
      float y = i / WIDTH;
      
      x *= noiseSize;
      y *= noiseSize;
      
      float h = noise(x, y, frameCount*0.01);    
      h *= noiseHeight;  
      
      heightmap[i] = h;
    }
  }
  
  void draw() {
    
    //test();
    
    graphics.loadPixels();
    
    
    for (int i=0; i<SIZE; i++) {
      
      color c = color(heightmap[i]*255,200,255-heightmap[i]*255f);
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
