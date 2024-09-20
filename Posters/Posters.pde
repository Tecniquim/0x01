int DPI;
float ppcm;// = 28.33333; // pixels_per_cm @ 72dpi
float mm_per_inch = 25.4;
float inch_per_mm = 0.03937008;
float cm_per_inch = 2.54;
float inch_per_cm = 0.3937008;
int A3w = 420;
int A3h = 297;

PShape tours;
float mx, my;//margins
float cm;//cell margin
float rsw = 0.35; // raw stroke width in the tours file
int W, H;
float cw;// cell width

ArrayList<Tour> tlist;

void setup() {
  size(827, 585, P2D);
  
  //DPI = 300;
  //ppcm = DPI * inch_per_cm;
  ppcm = width / (A3w/10.0);

  mx = (width / (A3w * 300 * inch_per_mm)) * 1.0 * ppcm;
  W = round(width - 2*mx);
  cw = W / 12.0;
  H = round((2/3.0) * W);
  my = 0.5 * (height - H);
  cm = 4*(rsw/7.35)*cw;
  print( mx, W, cw, H, my, cm, ".\n" );
  



  PShape file = loadShape( "Magic King's Tours.svg" );
  tours = file.getChild(1);
  int N = tours.getChildCount();
  float[] minx = new float[N];
  float[] miny = new float[N];
  for( int t = 0; t < N; t++ ){
    //println( tours.getChild(t).width, tours.getChild(t).height );
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
  
  //colorMode(HSB);
  noLoop();
}

void draw() {

  build_poster();

  background(0);

  //grid();

  print("let's show'em");
  for(int i = 0; i < tlist.size(); i++ ){
    tlist.get(i).show();
  }  
}

void keyPressed(){
  redraw();
}

void grid(){
  //print("grid");
  stroke(80);
  for(int j = 0; j <= 8; j++ ){
    line( mx + 0,   my + j*cw, mx + W,    my + j*cw );
  }
  for(int i = 0; i <= 12; i++ ){
    line( mx + i*cw, my + 0,   mx + i*cw, my + H    );
  }
}

void build_poster(){

  tlist = new ArrayList();
  boolean[][] map = new boolean[12][8];

  for(int j = 0; j < 8; j++ ){
    for(int i = 0; i < 12; i++ ){
      if( map[i][j] == false ){
        int s = int(pow(2, int(random(3))));
        boolean collision;
        do{// check if space is available
          collision = false;
          for(int k = 0; k < s; k++ ){
            for(int l = 0; l < s; l++ ){
              if( i+k >= 12 || j+l >= 8 || map[i+k][j+l] ){
                collision = true;
                s /= 2;
                break;
              }
            }
            if( collision ) break;
          }
        } while( collision );

        tlist.add( new Tour( i, j, s ) );

        //mark space as occupied
        for(int k = 0; k < s; k++ ){
          for(int l = 0; l < s; l++ ){
            if( i+k >= 12 || j+l >= 8 ) continue;
            map[i+k][j+l] = true;
          }
        }
      }
    }
  }

  println( "tlist.size():",  tlist.size() );
}

class Tour{

  int i, j;
  int s;
  int tID;
  boolean rot;

  Tour( int i, int j, int s ){
    this.i = i;
    this.j = j;
    this.s = s;
    tID = int(random(tours.getChildCount()));
    if( int(random(10)) % 2 == 0 ) rot = true;
    //println( i, j, s, tID );
  }
  void show(){
    //println( i, j, s, tID );
    pushMatrix();
    float w = (s * cw) - cm;
    float S = w / 7.35;
    float mg = (0.5 * cm) + ((0.175/7.35) * w);
    
    if( rot ) translate( mx + ((i+s) * cw) - mg, my + (j * cw) + mg );
    else      translate( mx + (i     * cw) + mg, my + (j * cw) + mg );
    scale( S );
    if( rot ) rotate(HALF_PI);
    shape( tours.getChild(tID), 0, 0 );
    popMatrix();
  }
}
