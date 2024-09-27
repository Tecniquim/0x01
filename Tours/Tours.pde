import processing.pdf.*;
PShape tours;
int N;
boolean panning;
float tx = 50, ty = 50;

float[] minx;
float[] miny;
int[] path;

void setup() {
	size(600, 600, PDF, "filename.pdf");
  //surface.setLocation(10, 10);
	/*
	PImage im = loadImage("tours.png");
	PGraphics pg = createGraphics(im.width/2, im.height/2);
	pg.beginDraw();
	for( int i = 0; i < 6; i++ ){
		for ( int j = 0; j < 8; j++ ) {
			pg.image( im.get( round((i+0.25) * 120), round((j+0.25) * 120), 60, 60 ), i*60, j*60 ); 
		}
	}
	pg.endDraw();
	pg.save("mid-quarter tours.png");
	exit();*/
	
	
	
	PShape file = loadShape( "Magic King's Tours.svg" );
	tours = file.getChild(1);
	N = tours.getChildCount();
	minx = new float[N];
	miny = new float[N];
	for( int t = 0; t < N; t++ ){
		println( tours.getChild(t).width, tours.getChild(t).height );
		tours.getChild(t).setStroke(#ffffff);
		int vn = tours.getChild(t).getVertexCount();
		//println( t, vn );
		minx[t] = 999999;
		miny[t] = 999999;
		for(int v = 0; v < vn; v++){
			PVector V = tours.getChild(t).getVertex(v);
			if( V.x < minx[t] ) minx[t] = V.x;
			if( V.y < miny[t] ) miny[t] = V.y;
		}
		tours.getChild(t).translate(-minx[t], -miny[t]);
	}
	
	int T = 9;
	path = get_path( tours.getChild(T), minx[T], miny[T] );

	//test_magicness();
	
	/*for(int i = 0; i < 64; i++ ){
		 print( arr[i] +", " ); 
	}*/
	//exit();
	
	
	colorMode(HSB);
	//noLoop();
}


int[] get_path( PShape tour, float tx, float ty ){
	int[] out;
	out = new int[64];
	int o = 0;
	int vn = tour.getVertexCount();
	//println( t, vn );
	for(int v = 0; v < vn; v++){
		PVector V = tour.getVertex(v);
		PVector NV = tour.getVertex((v+1)%vn);
		float dx = NV.x - V.x;
		float dy = NV.y - V.y;
		out[o++] = round( (V.y-ty) * 8 + V.x-tx);
		if( abs(dx) > 1 || abs(dy) > 1 ){
			if( dx != 0 && dy == 0 ){//horizontal
				float dir = (NV.x > V.x)? 1 : -1;
				for(int x = 1; x < abs(dx); x++ ){
					out[o++] = round( (V.y-ty) * 8 + V.x-tx + (dir*x));
				}
			}
			else if(dx == 0 && dy != 0 ){//vertical
				float dir = (NV.y > V.y)? 1 : -1;
				for(int y = 1; y < abs(dy); y++ ){
					out[o++] = round( (V.y-ty+(y*dir)) * 8 + V.x - tx);
				}
			}
			else if(dx != 0 && dy != 0 ){//diagonal
				float dirx = (NV.x > V.x)? 1 : -1;
				float diry = (NV.y > V.y)? 1 : -1;
				for(int t = 1; t < abs(dy); t++ ){
					out[o++] = round( (V.y-ty+(t*diry)) * 8 + V.x - tx + (dirx*t));
				}
			} 
		}
	}
	return out;
}

void draw() {
	background(200);
	
	float cw = width / 4.0;
	float S = cw / 8.25;
	noFill();
	strokeWeight(1);
	
	translate(tx, ty);

	textAlign(CENTER,CENTER);
	textSize(27);

	int px = path[0] % 8;
	int py = path[0] / 8;
	stroke(0); strokeWeight(8);
	for( int i = 0; i < 64; i++ ){
		int x = (path[i] % 8) * 50;
		int y = (path[i] / 8) * 50;
		line( px, py, x, y );
		px = x; py = y;
	}

	px = path[0] % 8;
	py = path[0] / 8;
	for( int i = 0; i < 64; i++ ){
		int x = (path[i] % 8) * 50;
		int y = (path[i] / 8) * 50;
		fill(255); noStroke();
		circle( x, y, 32 );

		//int o = i - 3;
		//if( o < 0 ) o += 64;
		int o = i+1;
		//o = 66-o;
		//if( o > 64 ) o -= 64;

		fill(0);
		text( o+"", x, y-2 );
		px = x; py = y;
	}
	print("DONE");
	exit();
  /*
	for( int i = 0; i < 6; i++ ){
		for ( int j = 0; j < 6; j++ ) {
			pushMatrix();
			translate( 6 + i*cw, 6 + j*cw);
			scale(S);
			shape( tours.getChild(i+9), 0, 0 );
			popMatrix();
		}
	}*/
	
	/*strokeWeight(3);
	for(int t = 0; t < N; ++t ){
		int vn = tours.getChild(t).getVertexCount();
		//fill( map( t, 0, N, 0, 255), 255, 255 );
		beginShape();
		for(int v = 0; v < vn; v++){
			PVector V = tours.getChild(t).getVertex(v);
			stroke( map( v, 0, vn, 0, 255), 255, 255 );
			vertex( S * V.x, S * V.y );  
		}
		endShape(CLOSE);
	}*/
	
	//scale(12);
	//stroke(255);
	//shape(tours, 0, 0 );
}


void mouseDragged(){
	tx += mouseX - pmouseX;
	ty += mouseY - pmouseY;
	redraw();
}


void test_magicness( ){// They are sensitive as to the starting position!!
	
	//path = get_path( MKTs.getChild( ID ), minx[ID], miny[ID] );

	for( int slide = 1; slide < 2; slide++ ) {

		int magic = 0;
		boolean ITIS = true;
		
		int[][] board = new int [8][8];
		for( int p = 0; p < 64; p++ ) {
			 int x = path[p] % 8;
			 int y = path[p] / 8;
			 board[x][y] = p+1;
		}
		for( int y = 0; y < 8; y++ ){
			for( int x = 0; x < 8; x++ ){
				print( board[x][y] + " " );
			}
			print("\n");
		}
			

		//test columns
		for( int x = 0; x < 8; x++ ){
			int t = 0;
			for( int y = 0; y < 8; y++ ){
				t += board[x][y];
			}
			if( magic == 0 ){
				magic = t; 
			}
			else{
				if( magic != t ){
					ITIS = false;
					//println( "!!!! slide " + slide + ", column " + x + " = " + t + ", previous = " + magic + "." );   
				}
			}
		}

		//test rows
		for( int y = 0; y < 8; y++ ){
			int t = 0;
			for( int x = 0; x < 8; x++ ){
				t += board[x][y];
			}
			if( magic != t ){
				ITIS = false;
				//println( "!!!! slide " + slide + ", row " + y + " = " + t + ", previous = " + magic + "." );   
			}
		}

		//test diags
		int d1 = 0;
		int d2 = 0;
		for( int n = 0; n < 8; n++ ){
			d1 += board[n][  n];
			d2 += board[n][7-n];
		}
		if( magic != d1 ){
			//println( "!!!! slide " + slide + ", d1 = " + d1 + ", previous = " + magic + "." );   
		}
		if( magic != d2 ){
			//println( "!!!! slide " + slide + ", d2 = " + d2 + ", previous = " + magic + "." );   
		}

		if( ITIS ){
			println( "> slide " + slide + " is magic. number = " + magic + ".\n" );
		}
	} 
}
