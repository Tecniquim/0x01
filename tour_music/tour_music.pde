import processing.sound.*;

SinOsc sine;
// tour 0
//int[] tour = {3, 2, 1, 0, 8, 17, 10, 11, 20, 21, 14, 23, 31, 30, 29, 28, 36, 37, 38, 39, 47, 54, 45, 44, 51, 50, 41, 48, 56, 57, 58, 59,   60, 61, 62, 63, 55, 46, 53, 52, 43, 42, 49,   40, 32, 33, 34, 35, 27, 26, 25, 24, 16, 9, 18, 19, 12, 13, 22, 15, 7, 6, 5, 4};
// tour 11
//int [] tour = { 4, 11, 2, 9, 16, 24, 33, 42, 35, 44, 53, 62, 63, 55, 46, 37, 29, 22, 15, 7, 6, 13, 20, 27, 18, 25, 32, 40, 49, 58, 51, 60, 59, 52, 61, 54, 47, 39, 30, 21, 28, 19, 10, 1, 0, 8, 17, 26, 34, 41, 48, 56, 57, 50, 43, 36, 45, 38, 31, 23, 14, 5, 12, 3};
//tour 16
int [] tour = { 0, 8, 17, 10, 19, 20, 13, 22, 15, 7, 6, 5, 4, 11, 18, 9, 16, 24, 33, 34, 35, 27, 26, 25, 32, 40, 49, 42, 51, 60, 61, 62, 63, 55, 46, 53, 44, 43, 50, 41, 48, 56, 57, 58, 59, 52, 45, 54, 47, 39, 30, 29, 28, 36, 37, 38, 31, 23, 14, 21, 12, 3, 2, 1 };
// quarta oitava
float [] notas = {  261.626, 277.183, 293.665, 311.127, 329.628, 349.228, 369.994, 391.995, 415.305, 440, 466.164, 493.883 };



float L;

void shuffle( float[] deck ) {
  for (int i = 0; i < deck.length-2; ++i) {
    int ni = int(random( i+1, deck.length ));
    float temp = deck[i];
    deck[i] = deck[ni];
    deck[ni] = temp;
  }
}

void setup() {
  size(600, 600);
  L = width / 9;
  
  shuffle( notas );
  for(int i = 0; i < notas.length; ++i ){
    print( notas[i]+", " );
  }

  // create and start the sine oscillator.
  sine = new SinOsc(this);
  sine.play();
  
  background(255);
  noStroke();
  for ( int i = 0; i < 8; i++ ) {
    for ( int j = 0; j < 8; j++ ) {
      if( i % 2 == j % 2 ) fill(180);
      else fill(255);
      rect( (i+0.5)*L, (j+0.5)*L, L, L );
    }
  }
  fill( #29ED86 );
}

void draw() {
  
  int pos = round(frameCount / 10) - 5;
  if (pos >= 0 && pos < 64){
    //float frequency = map(tour[pos], 0, 63, 261.6, 1000);
    int i = tour[pos] % 8;
    int j = tour[pos] / 8;
    int T = (i+j) % 64;
    //if( i % 2 != j % 2 ) T = notas.length -1 - (pos % 12);
    float frequency = notas[tour[T] % 8];
    sine.amp(0.8);
    sine.freq(frequency);
    sine.pan(0);    
    circle( (i+1)*L, (j+1)*L, L*0.66 );
  }
  if (pos == 65) sine.stop();
}
