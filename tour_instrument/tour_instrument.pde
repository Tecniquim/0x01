import processing.sound.*;

SinOsc sine;

// quarta oitava
float [] notas_freq = { 261.626, 277.183, 293.665, 311.127, 329.628, 349.228, 369.994, 391.995, 415.305, 440, 466.164, 493.883 };
String[] notas_nome = {   "C",     "C#",    "D",     "D#",    "E",     "F",     "F#",    "G",     "G#",  "A",   "A#",    "B"   }; 
int[] natural = { 0, 2, 4, 5, 7, 9, 11, 12 };

int [][] grid_notas;
int[] tour = {3, 2, 1, 0, 8, 17, 10, 11, 20, 21, 14, 23, 31, 30, 29, 28, 36, 37, 38, 39, 47, 54, 45, 44, 51, 50, 41, 48, 56, 57, 58, 59,   60, 61, 62, 63, 55, 46, 53, 52, 43, 42, 49,   40, 32, 33, 34, 35, 27, 26, 25, 24, 16, 9, 18, 19, 12, 13, 22, 15, 7, 6, 5, 4};
int play_start = 0;

PShape MKTs;// magic kings tours (they're all children on this parent object)
int TN; //number of tours

//seletor de tour
float slt_x;
float slt_w;

//seletor de notas
float sln_y;
float sln_w, sln_h;

//tabuleiro
float tab_x, tab_y;
float tab_w;
float tab_L;// largura das casas.

float m = 3;//margins

void shuffle( float[] deck ) {
	for (int i = 0; i < deck.length-2; ++i) {
		int ni = int(random( i+1, deck.length ));
		float temp = deck[i];
		deck[i] = deck[ni];
		deck[ni] = temp;
	}
}

void setup() {
	size( 1366, 695 );
	surface.setLocation(-8, -2);
	surface.setResizable(true);
	frameRate(60);
	strokeCap(SQUARE);

	slt_w = 0.25 * width;
	slt_x = width - slt_w;

	sln_w = width - slt_w;
	sln_h = 0.25 * height;
	sln_y = height - sln_h;

	tab_w = 0.95 * sln_y;
	tab_x = 0.5 * (sln_w - tab_w);
	tab_y = 0.5 * (sln_y - tab_w);
	tab_L = tab_w / 8;

	PShape mkt_file = loadShape( "Magic King's Tours.svg" );
	MKTs = mkt_file.getChild(1);
	TN = MKTs.getChildCount();

	build_ui();
	
	grid_notas = new int[8][8];
	for ( int i = 0; i < 8; i++ ){
		for ( int j = 0; j < 8; j++ ){
			grid_notas[i][j] = 4 * 12 + natural[i];
		}		
	}

	// create the sine oscillator.
	sine = new SinOsc(this);
}

void draw() {

	background(230);

	stroke(0); strokeWeight(2);
	fill( 200 );
	// Desenhar Seletor de Tours
	rect( slt_x, m, slt_w - m, height - 2*m );

	// Desenhar Seletor de Notas
	rect( m, sln_y, sln_w - 2*m, sln_h - m );

	// Desenhar Tabuleiro
	noFill();
	rect( tab_x, tab_y, tab_w, tab_w );
	noStroke();
	colorMode(HSB, 256);
	for ( int i = 0; i < 8; i++ ) {
		for ( int j = 0; j < 8; j++ ) {
			int nota = grid_notas[i][j] % 12;
			int octa = grid_notas[i][j] / 12;
			if( i % 2 == j % 2 ) fill( map(nota, 0, 12, 0, 256), 180 + 5 * octa, 256 );
			else                 fill( map(nota, 0, 12, 0, 256), 180 + 5 * octa, 192 );
			rect( tab_x + i * tab_L, tab_y + j * tab_L, tab_L, tab_L );
		}
	}
	colorMode(RGB, 256);

	
	if( PLAYING.b ){
		if( PLAYING.changed() ){
			tour = get_path( MKTs.getChild( sel_tour.n ) );
			sine.play();
			play_start = millis();
			PLAYING.set();
		}
		int pos = round( (millis() - play_start) / step_duration.n );
		if( pos >= 0 && pos < 65 ){
			stroke( 22 ); strokeWeight(tab_L*0.5);
			noFill();
			beginShape();
			for ( int p = 0; p <= pos; p++ ) {
				int i = tour[p] % 8;
				int j = tour[p] / 8;
				vertex( tab_x + (i+0.5) * tab_L, tab_y + (j+0.5) * tab_L );
			}
			endShape();
			noStroke(); strokeWeight(2);
			fill(22);
			//float frequency = map(tour[pos], 0, 63, 261.6, 1000);
			int i = tour[pos] % 8;
			int j = tour[pos] / 8;
			//int T = (i+j) % 64;
			//if( i % 2 != j % 2 ) T = notas.length -1 - (pos % 12);
			int nota = grid_notas[i][j] % 12;
			int octa = grid_notas[i][j] / 12;
			float frequency = notas_freq[ nota ];//notas_freq[tour[T] % 8];
			frequency *= pow( 2, octa-4 );
			sine.amp(0.8);
			sine.freq(frequency);
			sine.pan(0);    
			circle( tab_x + (i+0.5) * tab_L, tab_y + (j+0.5) * tab_L, tab_L*0.66 );
		}
		else{
			if( loop_song.b ){
				play_start += 64 * step_duration.n;
			}
			else{
				sine.stop();
				PLAYING.set(false);
			}
		}
	}
	else{
		if( PLAYING.changed() ){
			sine.stop();
			PLAYING.set();
		}
	}

	UI.display();
}

void mouseMoved(){
	UI.mouseMoved();

}
void mousePressed(){
	if( mouseX >= tab_x && mouseX <= tab_x + tab_w && mouseY >= tab_y && mouseY <= tab_y + tab_w ){
		int I = floor( (mouseX - tab_x) / tab_L );
		int J = floor( (mouseY - tab_y) / tab_L );
		grid_notas[I][J] = sel_octa.n * 12 + sel_nota.n;

	} UI.mousePressed();
}
void mouseReleased(){
	UI.mouseReleased();
  
}
void mouseDragged(){
	if( mouseX >= tab_x && mouseX <= tab_x + tab_w && mouseY >= tab_y && mouseY <= tab_y + tab_w ){
		int I = floor( (mouseX - tab_x) / tab_L );
		int J = floor( (mouseY - tab_y) / tab_L );
		grid_notas[I][J] = sel_octa.n * 12 + sel_nota.n;

	} UI.mouseDragged();
}
void mouseWheel( MouseEvent E ){
	UI.mouseWheel(E);
}
void keyReleased(){
	if( key == ' ' ){
		PLAYING.b = true;
	}
}

class BB{
	float x, y, w, h;
	BB( float x, float y, float w, float h){
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}
}
BB calc_PShape_BB( PShape S ){
	int vn = S.getVertexCount();
	float minx =  999999;
	float miny =  999999;
	float maxx = -999999;
	float maxy = -999999;
	for(int v = 0; v < vn; v++){
		PVector V = S.getVertex(v);
		if( V.x < minx ) minx = V.x;
		if( V.y < miny ) miny = V.y;
		if( V.x > maxx ) maxx = V.x;
		if( V.y > maxy ) maxy = V.y;
	}
	return new BB( minx, miny, maxx - minx, maxy - miny );
}

int[] get_path( PShape tour ){
	BB bb = calc_PShape_BB( tour );
	int[] out;
	out = new int[65];
	int o = 0;
	int vn = tour.getVertexCount();
	//println( t, vn );
	for(int v = 0; v < vn; v++){
		PVector V = tour.getVertex(v);
		PVector NV = tour.getVertex((v+1)%vn);
		float dx = NV.x - V.x;
		float dy = NV.y - V.y;
		out[o++] = round( (V.y-bb.y) * 8 + V.x-bb.x);
		if( abs(dx) > 1 || abs(dy) > 1 ){
			if( dx != 0 && dy == 0 ){//horizontal
				float dir = (NV.x > V.x)? 1 : -1;
				for(int x = 1; x < abs(dx); x++ ){
					out[o++] = round( (V.y-bb.y) * 8 + V.x-bb.x + (dir*x));
				}
			}
			else if(dx == 0 && dy != 0 ){//vertical
				float dir = (NV.y > V.y)? 1 : -1;
				for(int y = 1; y < abs(dy); y++ ){
					out[o++] = round( (V.y-bb.y+(y*dir)) * 8 + V.x - bb.x);
				}
			}
			else if(dx != 0 && dy != 0 ){//diagonal
				float dirx = (NV.x > V.x)? 1 : -1;
				float diry = (NV.y > V.y)? 1 : -1;
				for(int t = 1; t < abs(dy); t++ ){
					out[o++] = round( (V.y-bb.y+(t*diry)) * 8 + V.x - bb.x + (dirx*t));
				}
			} 
		}
	}
	out[64] = out[0];
	return out;
}