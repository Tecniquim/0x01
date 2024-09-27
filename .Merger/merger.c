#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <stdbool.h>
#include <string.h>
#include <locale.h>

#define PAGECOUNT 64


bool fseek_str( FILE *f, char *str ){
	char c = getc( f );
	int i = 0;
	while( c != EOF ){
		if( c == str[i] ){
			i++;
			if( str[i] == '\0' ) return 1;
		}
		else{
			i = 0;
		}
		c = getc( f );
	}
	return 0;
}

bool fseek_str_before( FILE *f, char *str, char *terminator ){
	long int original_pos = ftell( f );
	char c = getc( f );
	int s = 0;
	int t = 0;
	while( c != EOF ){

		if( c == terminator[t] ){
			t++;
			if( terminator[t] == '\0' ){
				fseek( f, original_pos, SEEK_SET );
				return 0;
			}
		}
		else{
			t = 0;
		}

		if( c == str[s] ){
			s++;
			if( str[s] == '\0' ) return 1;
		}
		else if( s > 0 ){//we are are not at the match yet, but we have to restart counting right away!
			if( c == str[0] ) s = 1;
			else s = 0;
		}
		
		c = getc( f );
	}
	fseek( f, original_pos, SEEK_SET );
	return 0;
}

void copyf( FILE *source, FILE *dest ){
	while( !feof(source) ){
		fprintf( dest, "%c", fgetc(source) );
	}
}

void copyf_until( FILE *source, FILE *dest, char *terminator ){

	char c = fgetc( source );
	int s = 0;
	
	while( c != EOF ){

		if( c == terminator[0] ){
			long int pos = ftell( source );
			int t = 0;
			c = fgetc( source );
			while( c != EOF ){
				t++;
				if( terminator[t] == '\0' ) return;
				if( c != terminator[t] ) break;
				c = fgetc( source );
			}
			fprintf( dest, "%c", terminator[0] );
			fseek( source, pos, SEEK_SET );
		}
		else{
			fprintf( dest, "%c", c );
		}
		c = fgetc( source );
	}
}


int main(int argc, char const *argv[]){

	setlocale (LC_ALL, "C");
	FILE *f = fopen( "zine.svg", "wb" );


	fprintf( f, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<svg>\n" );

	fprintf( f, "\t<sodipodi:namedview\n\t\tid=\"TheView\"\n\t\tinkscape:document-units=\"px\"\n\t\tinkscape:current-layer=\"LAYER1\">\n" );

	for (int P = 0; P < PAGECOUNT; ++P ){
		fprintf( f, "\t\t<inkscape:page x=\"0.0\" y=\"%.1f\" width=\"1587.4016\" height=\"1122.5198\" id=\"page%02d\" />\n",
				 P*1133.0, P+1 );
	}
    
  	fprintf( f, "\t</sodipodi:namedview>\n\n" );
  	
  	FILE *DF = fopen( "defs.txt", "rb" );
  	copyf( DF, f );
	fclose(DF);


  	FILE *MO = fopen( "MODELO.svg", "rb" );
  	//fseek_str( MO, "id=\"layer1\">" );
  	//long int MO_START = ftell( MO );

  	FILE *PO = fopen( "POSTERS.svg", "rb" );

  	FILE *HR = fopen( "horoscopos.txt", "rb" );


  	for (int P = 0; P < PAGECOUNT; P++ ){
  		putchar('>');
  		// FRONTSIDE
  		fprintf( f, "\t<g id=\"TRANS%d\" transform=\"translate(0.0,%.1f)\">\n", P+1, P*1133.0 );
  		rewind(MO);//fseek( MO, MO_START, SEEK_SET );
  		copyf_until( MO, f, "HOROS GOES HERE" );
  		copyf_until( HR, f, "\n" );
  		fprintf( f, ">" );// but this isn't even a complete fix... it's putting a ÿ afterwards.....
  		copyf( MO, f );
  		fprintf( f, "\t</g>\n\n" );
  		P += 1;
  		// BACKSIDE, POSTER
  		fprintf( f, "\t<g id=\"TRANS%d\" transform=\"translate(0.0,%.1f)\">\n", P+1, P*1133.0 );

  		fseek_str( PO, "label=\"Page" );
  		for (int i = 0; i < 4; ++i ) fseek_str( PO, "<g" );
  		fseek_str( PO, ">" );
  		copyf_until( PO, f, "</g>" );  		

  		fprintf( f, "\t</g>\n\n" );
  	}


  	fprintf( f, "</svg>" );

  	fclose(f);

	return 0;
}