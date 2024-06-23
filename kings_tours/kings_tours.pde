import processing.sound.*;


int [][] tabuleiro;
King king;
float L;
int[] dirs = { 0, 1, 2, 3, 4, 5, 6, 7};

	
void setup() {
	size(400, 400);
	L = width / 9;
	tabuleiro = new int[8][8];
	for ( int i = 0; i < 8; i++ ) {
		for ( int j = 0; j < 8; j++ ) {
			tabuleiro[i][j] = -1;
		}
	}
	shuffle( dirs );
	strokeWeight(4);
	//noLoop();
}





void draw() {
	/*   0  1  2
			 7  X  3
			 6  5  4
	 */
	background(255);
	stroke(127);
	for ( int i = 0; i < 8; i++ ) {
		for ( int j = 0; j < 8; j++ ) {
			if( i % 2 == j % 2 ) fill(180);
			else fill(255);
			rect( (i+0.5)*L, (j+0.5)*L, L, L );
		}
	}
	stroke(0);
	for ( int i = 0; i < 8; i++ ) {
		for ( int j = 0; j < 8; j++ ) {
			tabuleiro[i][j] = -1;
		}
	}
	king = new King(0, 0);
	for ( int n = 0; n < 64; n++ ) {
		int dir = passo();
		if ( dir < 0 ) {
			//println(n);
			if( n == 63 ) noLoop();
			break;
		}
		int pi = king.i;
		int pj = king.j;
		tabuleiro[king.i][king.j] = n+1;
		king.step(dir);
		line( (pi+1)*L, (pj+1)*L, (king.i+1)*L, (king.j+1)*L );
	}
}

void keyPressed(){
	//for ( int i = 0; i < 4; i++ ) {
	//  for ( int j = 0; j < 4; j++ ) {
	//    tabuleiro[i][j] = -1;
	//  }
	//}
	loop();
	//shuffle( dirs );
	//redraw();
}

class King {
	int i, j;
	King( int i, int j ) {
		this.i = i;
		this.j = j;
	}
	void step( int dir ){
		switch( dir ){
			case 0:
				i -= 1;
				j -= 1;
				break;
			case 1:
				j -= 1;
				break;
			case 2:
				i += 1;
				j -= 1;
				break;
			case 3:
				i += 1;
				break;
			case 4:
				i += 1;
				j += 1;
				break;
			case 5:
				j += 1;
				break;
			case 6:
				i -= 1;
				j += 1;
				break;
			case 7:
				i -= 1;
				break;
		}
	}
}


void shuffle( int[] deck ) {
	for (int i = 0; i < deck.length-2; ++i) {
		int ni = int(random( i+1, deck.length ));
		int temp = deck[i];
		deck[i] = deck[ni];
		deck[ni] = temp;
	}
}

int passo() {
	shuffle( dirs );
	for ( int i = 0; i < 8; i++ ) {
		int dir = dirs[i];
		boolean valid = true;
		switch( dir ){
			case 0:
				if ( king.i -1 < 0 || king.j -1 < 0 || 
						 tabuleiro[king.i -1][king.j -1] > 0 ){
					valid = false;
				}
				break;
			case 1:
				if ( king.j -1 < 0 || tabuleiro[king.i][king.j -1] > 0 ){
					valid = false;
				}
				break;
			case 2:
				if ( king.i +1 > 7 || king.j -1 < 0 || 
						 tabuleiro[king.i +1][king.j -1] > 0 ){
					valid = false;
				}
				break;
			case 3:
				if ( king.i +1 > 7 || tabuleiro[king.i +1][king.j] > 0 ){
					valid = false;
				}
				break;
			case 4:
				if ( king.i +1 > 7 || king.j +1 > 7 || 
						 tabuleiro[king.i +1][king.j +1] > 0 ){
					valid = false;
				}
				break;
			case 5:
				if ( king.j +1 > 7 || tabuleiro[king.i][king.j +1] > 0 ){
					valid = false;
				}
				break;
			case 6:
				if ( king.i -1 < 0 || king.j +1 > 7 || 
						 tabuleiro[king.i -1][king.j +1] > 0 ){
					valid = false;
				}
				break;
			case 7:
				if ( king.i -1 < 0 || tabuleiro[king.i -1][king.j] > 0 ){
					valid = false;
				}
				break;
		}
		if( valid ) return dir;
	}
	return -1;
}
