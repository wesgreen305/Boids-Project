//Boids project

ArrayList<Boid> flock = new ArrayList<Boid>();

void setup(){
  size(displayWidth,displayHeight, P2D);
  frameRate(60.0);
  
  
 for (int i = 0; i < 500; i++){
     
    float R,G,B;

    R = random(200,255);
    G = random(200,255);
    B = random(255);
    
    color inputcolor = color(R,G,B);
    
    flock.add(new Boid(inputcolor));
 }
  
}

void draw(){
  background(10,10,10);
  
  for (int i = 0; i < flock.size(); i++){
    Boid bd = flock.get(i);

    bd.flock();
    bd.update();
    bd.show();
  }
  
}

class Boid{
  
  PVector pos, vel, acc, alignment, avoidance, cohesion;
  color c;
  float maxForce, maxSpeed;
  
  Boid(color inputcolor){
    pos = new PVector(random(0,displayWidth),
                      random(0,displayHeight));
    vel = PVector.random2D();
    vel.setMag(random(-5,5));
    alignment = new PVector();
    avoidance = new PVector();
    cohesion = new PVector();
    acc = new PVector();
    c = inputcolor;
    
    maxForce = 0.2;
    maxSpeed = 5.0;
    
    
  }
  
  PVector align(){
    
    int view = 60;
    int total = 0;
    
    for (int i = 0; i < flock.size(); i++){
      
      Boid bdnear = flock.get(i);
      
      float d = dist(
            this.pos.x,
            this.pos.y,
            bdnear.pos.x,
            bdnear.pos.y
            ); 
            
      if (bdnear.pos != this.pos && d < view){
        alignment.add(bdnear.vel);
        total++;
      }  
    }
    if (total > 0){
        alignment.div(total);
        alignment.setMag(this.maxSpeed);
        alignment.sub(this.vel);
        alignment.limit(maxForce);
     }
   return alignment;
  }
  
  PVector avoid(){
    
    int view = 48;
    int total = 0;
    
    for (int i = 0; i < flock.size(); i++){
      
      Boid bdnear = flock.get(i);
      
      float d = dist(
            this.pos.x,
            this.pos.y,
            bdnear.pos.x,
            bdnear.pos.y
            ); 
            
      if (bdnear.pos != this.pos && d < view){
        avoidance.add(this.vel);
        avoidance.sub(bdnear.vel);
        avoidance.div(d);
        total++;
      }  
    }
    if (total > 0){
        //avoidance.add(this.vel);
        avoidance.div(total);
        avoidance.setMag(maxSpeed);
        avoidance.sub(this.vel);
        avoidance.limit(maxForce*1.5);
     }
   return avoidance;
  }
  
  PVector cohere(){
    
    int view = 48;
    int total = 0;
    
    for (int i = 0; i < flock.size(); i++){
      
      Boid bdnear = flock.get(i);
      
      float d = dist(
            this.pos.x,
            this.pos.y,
            bdnear.pos.x,
            bdnear.pos.y
            ); 
            
      if (bdnear.pos != this.pos && d < view){
        cohesion.add(bdnear.pos);
        total++;
      }  
    }
    if (total > 0){
        cohesion.div(total);
        cohesion.sub(this.pos);
        cohesion.setMag(maxSpeed);
        cohesion.sub(this.vel);
        cohesion.limit(maxForce*2);
     }
   return cohesion;
  }
  
  void flock(){
    
    align();
    avoid();
    cohere();
    
    this.acc.add(alignment);
    this.acc.add(avoidance);
    this.acc.add(cohesion);
    this.acc.div(2);
  }
  
  void update(){
    
    this.pos.add(this.vel);
    this.vel.add(this.acc);
    
    this.acc.set(0,0);
    
    
    ////EDGES
    //if (pos.x < 0){
    //  vel.x = vel.x*-1; 
    //}
    //if (pos.x > width){
    //  vel.x = vel.x*-1; 
    //}
    //if (pos.y < 0){
    //  vel.y = vel.y*-1; 
    //}
    //if (pos.y > height){
    //  vel.y = vel.y*-1; 
    //}
    
    //// WRAP WALLS
    if (pos.x < 100){
      pos.x = width-100; 
    }
    if (pos.x > width-100){
      pos.x = 100;  
    }
    if (pos.y < 100){
      pos.y = height-100; 
    }
    if (pos.y > height-100){
      pos.y = 100; 
    }
    

  }
  
  void show(){
    strokeWeight(12);
    stroke(this.c);
    point(pos.x, pos.y);
  }
}
