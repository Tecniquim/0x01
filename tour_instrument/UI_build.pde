UISet UI;

integer sel_octa;
integer sel_nota;
integer sel_tour;
bool_p PLAYING;
bool loop_song;
floating_point step_duration;

void build_ui(){

	ui_font = loadFont("FiraSans-Regular-18.vlw");
	
	sel_octa = new integer(4);
	sel_nota = new integer(0);
	sel_tour = new integer(0);
	PLAYING = new bool_p(false);
	step_duration = new floating_point(160);
	loop_song = new bool();
	
	UI = new UISet( 3, 20, 16 );
	UI.setScheme( #D3D3C9, 20 );

	UI.Hx = 3;
	UI.Vx = 1;
	UI.addLabel( 0, 0, "Tour Instrument", "CILI" );

	UI.addToggle(0, 1, "Stop", "Play", "C", PLAYING);
	
	UI.addToggle(0, 2, "Loop", "C", loop_song );

	UI.addSlider(0, 4, "Duration", "TOLI", step_duration, 10, 1000 );


  
	UI.Hx = 2.5;
	UI.Vx = 2;
	UI.addPlusMinus( 0, 13, "Octave", "TOCO", sel_octa, 1 );

	UI.Hx = 0.94;
	UI.beginRow( 3, 13 );
	colorMode(HSB, 256);
	for ( int i = 0; i < 12; i++ ) {
		UI.addNumSet( notas_nome[i], "CICI", sel_nota, i, color( map(i, 0, 12, 0, 256), 200, 256 ) );
	}
	colorMode(RGB, 256);

	UI.Hx = 4.9;
	UI.Vx = 15;
	UI.addShapeListSelect( 15, 1, "Tours", "TOLI", MKTs, sel_tour );
	
	//create.addLabel( 0, 0, "Cellular Automata Suite 1.0", "C" );
	
}
