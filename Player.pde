class Player {

  World world;
  Game game;
  
  public color playerColor;

  final float RAD = 4;  // Size of the Player's ball.
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

