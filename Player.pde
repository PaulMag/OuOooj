class Player {

  World world;
  Game game;
  
  public color playerColor;

  final float WALKSPEED = 5;
  final float BUILDSPEED = 1;
  final float BUILDSIZE = 1;

  PVector pos;
  PVector velocity = new PVector(0, 0);
  PVector acceleration = new PVector(0, 0);
  PVector thrust;
  boolean alive = true;
  byte moveX = 0;
  byte moveY = 0;
  byte moveZ = 0;

  Player(float posx, float posy, Game game, World world) {
    this.game = game;
    this.world = world;
    this.pos = new PVector(posx, posy);
  }

  void findAcceleration() {
    float dd = 2f / world.PIXPERM;

    float dhX = world.getHeightAt(PVector.add(pos, new PVector(0, 1))) - world.getHeightAt(PVector.add(pos, new PVector(0, -1)));
    float dhY = world.getHeightAt(PVector.add(pos, new PVector(1, 0))) - world.getHeightAt(PVector.add(pos, new PVector(-1, 0)));
    float thetaX = atan(dhX / dd);
    float thetaY = atan(dhY / dd);
    thrust = new PVector(moveX * WALKSPEED, moveY * WALKSPEED);
    if (moveX != 0 && moveY != 0) {
      thrust.mult(0.70710678118654746);
    }
    acceleration.add(thrust);
    acceleration.x = world.GRAVITY * sin(thetaX);
    acceleration.y = world.GRAVITY * sin(thetaY);
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
      world.build(BUILDSPEED * moveZ, pos, BUILDSIZE);
    }
  }

  private void move() {
    velocity = PVector.add(velocity, PVector.mult(acceleration, game.dt));
    pos = PVector.add(pos, PVector.mult(velocity, game.dt));
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

