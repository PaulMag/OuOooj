class Player {
    Player(float) {
        this.pos = new PVector(posx, posy);
        this.velocity = new PVector(0, 0);
        this.acceleration = new PVector(0, 0);
    }

    void findAcceleration() {
        float dd = 2. / world.PIXPERM

        float dhX =
            world.getHeightAt(this.pos.add(PVector(0, 1))) -
            world.getHeightAt(this.pos.add(PVector(0,-1));
        float dhY =
            world.getHeightAt(this.pos.add(PVector( 1,0))) -
            world.getHeightAt(this.pos.add(PVector(-1,0));
        float thetaX = asin(dhX / dd)
        float thetaY = asin(dhY / dd)
        this.acceleration.x = world.GRAVITY * sin(thetaX)
        this.acceleration.y = world.GRAVITY * sin(thetaY)
    }

    void move() {
        this.velocity.add(this.acceleration * dt)
        this.pos.add(this.velocity * dt)
    }
}
