class Player {
  
  World world;
  Game game;
  
  PVector pos;
  PVector velocity = new PVector(0, 0);
  PVector acceleration = new PVector(0, 0);
  
    Player(float posx, float posy, Game game, World world) {
      this.game = game;
      this.world = world;
      this.pos = new PVector(posx, posy);
    }

    void findAcceleration() {
        float dd = 2f / world.PIXPERM;
        
        float dhX = world.getHeightAt(PVector.add(pos, new PVector(0, 1))) - world.getHeightAt(PVector.add(pos, new PVector(0,-1)));
        float dhY = world.getHeightAt(PVector.add(pos, new PVector(1, 0))) - world.getHeightAt(PVector.add(pos, new PVector(-1,0)));
        float thetaX = asin(dhX / dd);
        float thetaY = asin(dhY / dd);
        acceleration.x = world.GRAVITY * sin(thetaX);
        acceleration.y = world.GRAVITY * sin(thetaY);
    }

    void move() {
      velocity = PVector.add(velocity, PVector.mult(acceleration, game.dt));
      pos = PVector.add(pos, PVector.mult(velocity, game.dt));
    }
    
    void draw() {
      noStroke();
      fill(0);
      ellipse(pos.x, pos.y, 8, 8);
    }
}
