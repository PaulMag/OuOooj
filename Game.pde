
class Game {
  
  public float dt = 0f; // deltatime
  private long timePrevious = System.currentTimeMillis();

  ArrayList<Player> players = new ArrayList<Player>();
  World world = new World(130, 130, players);  
  
  Game() {
    players.add(new Player(50, 54, this, world));
    players.add(new Player(56, 55, this, world));
    players.add(new Player(50, 52, this, world));
    players.add(new Player(58, 55, this, world));
    
    players.get(0).playerColor = #FAF7AC;
    players.get(1).playerColor = #ACE8FA;
    players.get(2).playerColor = #B6FAAC;
    players.get(3).playerColor = #FAACF0;
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
      p.update();
    }
    
    
    world.draw();
    
    for (Player p : players) {
      p.draw();
    }
  }
}
