Bola bola;
Pino pinos [];

int mode = 0;

void setup(){
  size(800,500);
  
  bola = new Bola( width, 0 );
  pinos = new Pino[6];
  for( int i = 0; i < pinos.length; i++ ){
    //int K = (random(2)>1)? -1 : 1;
    int K = (i%2==0)? -1 : 1;
    pinos[i] = new Pino( 400 + 100 * randomGaussian(), 250 + 100 * randomGaussian(), 20 * K );
  }
}
void draw(){
  
  if( mode == 0 ){ // MIRAR
    background(200);
    
    PVector mira = new PVector( 100, 0 );
    mira.rotate( atan2( mouseY - bola.pos.y, mouseX - bola.pos.x ) );
    stroke( 0 );strokeWeight(4);
    line( bola.pos.x, bola.pos.y, bola.pos.x + mira.x, bola.pos.y + mira.y );
    if( mousePressed ){
      bola.vel = mira.mult( 0.05 );
      mode = 1;
    }
  }
  noStroke();
  for( int i = 0; i < pinos.length; i++ ){
    pinos[i].display();
  }
  
  if( mode == 1 ){
    bola.step( pinos );
    bola.display();
    noStroke();
  }
}

void keyPressed(){
  bola.pos.set(width, 0);
  mode = 0;
}


class Pino{
  PVector pos;
  float force;
  Pino( float x, float y, float f ){
    pos = new PVector(x,y);
    force = f;
  }  
  void display(){
    if( force > 0 ) fill( 0,0,255 );
    else fill( 255,0,0 );
    circle( pos.x, pos.y, 30 );
  }
}

class Bola{
  PVector pos;
  PVector vel;
  Bola( float x, float y ){
    pos = new PVector(x,y);
    vel = new PVector(-5,3);
  }
  void step( Pino P [] ){
    PVector acc = new PVector(0,0);
    for( int i = 0; i < P.length; i++ ){
      PVector F = new PVector( P[i].force * ( 1.0 / pos.dist(P[i].pos)) * 1, 0 );
      F.rotate( atan2( P[i].pos.y - pos.y, P[i].pos.x - pos.x ) );
      acc.add( F );
    }
    vel.add( acc );
    pos.add( vel );    
  }
  void display(){
    fill( 255 );
    circle( pos.x, pos.y, 20 );
  }
}
