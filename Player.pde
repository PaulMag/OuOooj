class Player {

  World world;
  Game game;

  PVector pos;
  PVector velocity = new PVector(0, 0);
  PVector acceleration = new PVector(0, 0);
  boolean alive = true;

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
    acceleration.x = world.GRAVITY * sin(thetaX);
    acceleration.y = world.GRAVITY * sin(thetaY);
  }

  PVector getAttraction(Player other) {
    PVector r = PVector.sub(other.pos, this.pos);
    PVector rAbs = r.get();
    rAbs.normalize();
    return PVector.mult(rAbs, world.ELECTRIC / PVector.dot(r, r));
  }

  void move() {
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
    noStroke();
    fill(0);
    ellipse(pos.x, pos.y, 8, 8);
  }
}

