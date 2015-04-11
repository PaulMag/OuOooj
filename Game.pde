
class Game {
  
  public float dt = 0f; // deltatime
  private long timePrevious = System.currentTimeMillis();

  ArrayList<Player> players = new ArrayList<Player>();
  World world = new World(400, 400, players);  
  
  Game() {
    players.add(new Player(100, 100, this, world));
    players.add(new Player(150, 150, this, world));
  }
 
  void update() {
    
    long timeNow = System.currentTimeMillis();
    dt = (timeNow - timePrevious) / 1000f;
    timePrevious = timeNow;
    
    world.update();
    for (Player p : players) {
      p.findAcceleration();
    }
    for (int i=0; i < players.size(); i++) {
      for (int j=i+1; j < players.size(); j++) {
        PVector a = players.get(i).getAttraction(players.get(j));
        players.get(i).acceleration.add(a);
        players.get(j).acceleration.sub(a);
      }
    }   
    for (Player p : players) {
      p.move();
    }
    
    
    world.draw();
    
    for (Player p : players) {
      p.draw();
    }
  }
}
