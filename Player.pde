class Player {

  World world;
  Game game;
  
  public color playerColor;

  final float RAD = 4;  // Size of the Player's ball.
  final float WALKSPEED = 80;
  final float BUILDSPEED = 0.04;
  final float BUILDSIZE = 10;

  PVector pos;
  PVector velocity = new PVector(0, 0);
  PVector acceleration = new PVector(0, 0);
  PVector thrust;
  boolean alive = true;
  int moveX = 0;
  int moveY = 0;
  int moveZ = 0;

  Player(float posx, float posy, Game game, World world) {
    this.game = game;
    this.world = world;
    this.pos = new PVector(posx, posy);
  }

  void findAcceleration() {

    float hX1 = 0;
    float hX2 = 0;
    float hY1 = 0;
    float hY2 = 0;
    for (int i=1; i<=RAD; i++) {
      hX1 += world.getHeightAt(PVector.add(pos, new PVector(-i, 0)));
      hX2 += world.getHeightAt(PVector.add(pos, new PVector(+i, 0)));
      hY1 += world.getHeightAt(PVector.add(pos, new PVector(0, -i)));
      hY2 += world.getHeightAt(PVector.add(pos, new PVector(0, +i)));
    }
    float dhX = hX2 - hX1;
    float dhY = hY2 - hY1;
    float thetaX = atan(dhX / RAD);
    float thetaY = atan(dhY / RAD);
    thrust = new PVector(moveX * WALKSPEED, moveY * WALKSPEED);
    if (moveX != 0 && moveY != 0) {
      thrust.mult(0.70710678118654746);
    }

    acceleration.x = - world.GRAVITY * sin(thetaX);
    acceleration.y = - world.GRAVITY * sin(thetaY);
    
    acceleration.add(getBumpBack());
    acceleration.add(thrust);
    acceleration.sub(PVector.mult(velocity, world.AIR)); // drag force
  }

  PVector getAttraction(Player other) {
    PVector r = PVector.sub(other.pos, this.pos);
    PVector rAbs = r.get();
    rAbs.normalize();
    return PVector.mult(rAbs, world.ELECTRIC / PVector.dot(r, r));
  }

  void update() {
    move();
    if (moveZ != 0) {
      float buildSpeed = (world.MAX_BUILD_HEIGHT - world.getHeightAt(pos)) / 
                         world.MAX_BUILD_HEIGHT * BUILDSPEED;
      world.build(buildSpeed * moveZ, pos, BUILDSIZE);
    }
  }

  private void move() {
    velocity = PVector.add(velocity, PVector.mult(acceleration, game.dt));
    pos = PVector.add(pos, PVector.mult(velocity, game.dt));
  }
  
  PVector getBumpBack() {
    PVector r = PVector.sub(world.MIDDLE, pos);
    if (r.mag() > world.WIDTH/2) {
      return PVector.mult(r, 1.0);
    }
    else {
      return new PVector(0, 0);
    }
  }
  
  void die() {
    alive = false;
    for (int i=0; i<world.players.size(); i++) {
      if (this == world.players.get(i)) {
        world.players.remove(i);
        break;
      }
    }
  }
 

  void draw() {
    /*
    noStroke();
    fill(0);
    ellipse(pos.x, pos.y, 8, 8);
    */
  }
}

