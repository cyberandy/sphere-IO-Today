/**
 * Original Geometry by Marius Watz revised by CyberAndy for IO10
 *   
 * KEYBOARD COMMANDS:
 * 
 *   'w' Wireframe YES/NO
 *   'b' Background White/Black
 *   'UP' Sphere resolution up
 *   'DOWN' Sphere resolution down
 *   'RIGHT' Sphere size grow
 *   'LEFT' Sphere size down
 * 
 * Using sin/cos lookup tables, blends colors, and draws a series of 
 * rotating arcs on the screen.
*/
 
// Trig lookup tables borrowed from Toxi; cryptic but effective.
float sinLUT[];
float cosLUT[];
float SINCOS_PRECISION=1.0;
int SINCOS_LENGTH= int((360.0/SINCOS_PRECISION));

// System data
boolean dosave=false;
int num;
float pt[];
int style[];

int res = 20;
boolean isWireFrame = false;
int bgcolor = 255;

int intNum = 15;   // Sets the number of flying elements

float rx = 0;
float ry = 0;
int radius = 130;
 
void setup() {
  size(1024, 768, P3D);
  background(255);
  

  // Fill the tables
  sinLUT=new float[SINCOS_LENGTH];
  cosLUT=new float[SINCOS_LENGTH];
  for (int i = 0; i < SINCOS_LENGTH; i++) {
    sinLUT[i]= (float)Math.sin(i*DEG_TO_RAD*SINCOS_PRECISION);
    cosLUT[i]= (float)Math.cos(i*DEG_TO_RAD*SINCOS_PRECISION);
  }
 
  num = intNum;
  pt = new float[6*num]; // rotx, roty, deg, rad, w, speed
  style = new int[2*num]; // color, render style
 
  // Set up arc shapes
  int index=0;
  float prob;
  for (int i=0; i<num; i++) {
    pt[index++] = random(PI*2); // Random X axis rotation
    pt[index++] = random(PI*2); // Random Y axis rotation
 
    pt[index++] = random(60,80); // Short to quarter-circle arcs
    if(random(100)>90) pt[index]=(int)random(8,27)*10;
 
    pt[index++] = int(random(20,35)*5); // Radius. Space them out nicely
 
    pt[index++] = random(4,20); // Width of band originally 4,32
    if(random(100)>90) pt[index]=random(40,60); // Width of band
    
    pt[index++] = radians(random(5,30))/5; // Speed of rotation
 
    // Get colors
    prob = random(100);
    
    int[] colorlist_;
    
    colorlist_ = chooseRandomColor();

    if(prob<30) style[i*2]=color(colorlist_[0],colorlist_[1],colorlist_[2]);
    else if(prob<70) style[i*2]=color(colorlist_[0],colorlist_[1],colorlist_[2]);
    else if(prob<90) style[i*2]=color(colorlist_[0],colorlist_[1],colorlist_[2]);
    else style[i*2]=color(0,0,0, 0);

    if(prob<50) style[i*2]=color(colorlist_[0],colorlist_[1],colorlist_[2]);
    else if(prob<90) style[i*2]=color(colorlist_[0],colorlist_[1],colorlist_[2]);
    
    
    else style[i*2]=color(#F71E84);

    style[i*2+1]=(int)(random(100))%3;
  }
}
 
void draw() {
 
  background(bgcolor);
 
 
  int index=0;
  translate(width/2, height/2, 0);
  rotateX(PI/6);
  rotateY(PI/6);
  
  
  for (int i = 0; i < num; i++) {

    pushMatrix();
 
    rotateX(pt[index++]);
    rotateY(pt[index++]);

    
    strokeWeight(.5);

    // Set up the central Sphere    
    
    if (isWireFrame){
        noFill();
          } 
    else {
        fill(#F71E84); // PINK
        //fill(#8FD22A); // GREEN
                }
    sphereDetail(res);
    sphere(radius);
    

 
    if(style[i*2+1]==0) {
      stroke(style[i*2]);
      noFill();
      strokeWeight(2);
      arcLineBars(50,50, pt[index++],pt[index++],pt[index++]);
    }
    else if(style[i*2+1]==1) {
      fill(style[i*2]);
      noStroke();
      arc(50,50, pt[index++],pt[index++],pt[index++]);
    }
    else {
      fill(style[i*2]);
      noStroke();
      arc(50,50, pt[index++],pt[index++],pt[index++]);
    }
 
   
    // increase rotation
    pt[index-5]+=pt[index]/10;
    pt[index-4]+=pt[index++]/20;
 
    popMatrix();
        
  }
  
  // Saving tif on the disk for movie creation
  
  //saveFrame("IOTODAY-frames/####.tga");
  
}
 
 

int[] colorBlended() { 
  String[] colors = new String[7];
  
  // color palette - change here to try different palette
  
  colors[0] = "#F20F62"; // pink 
  colors[1] = "#FF9A2E"; // orange
  colors[2] = "#F9F81E"; // yellow
  colors[3] = "#8FD22A"; // green
  colors[4] = "#642994"; // purple
  colors[5] = "ffffff";  // white
  colors[6] = "000000";  // black
  
  float q = random(colors.length);
  int c = int(q);

  int[] colorlist_ = int(colors);
  return colorlist_;  
 }
 
// Draw arc line with bars
void arcLineBars(float x,float y,float deg,float rad,float w) {
  int a = int((min (deg/SINCOS_PRECISION,SINCOS_LENGTH-1)));
  a /= 4;
 
  beginShape(QUADS);
  for (int i=0; i<a; i+=4) {
    vertex(cosLUT[i]*(rad)+x,sinLUT[i]*(rad)+y);
    vertex(cosLUT[i]*(rad+w)+x,sinLUT[i]*(rad+w)+y);
    vertex(cosLUT[i+2]*(rad+w)+x,sinLUT[i+2]*(rad+w)+y);
    vertex(cosLUT[i+2]*(rad)+x,sinLUT[i+2]*(rad)+y);
  }
  endShape();
}
 
// Draw solid arc
void arc(float x,float y,float deg,float rad,float w) {
  int a = int(min (deg/SINCOS_PRECISION,SINCOS_LENGTH-1));
  beginShape(QUAD_STRIP);
  for (int i = 0; i < a; i++) {
    vertex(cosLUT[i]*(rad)+x,sinLUT[i]*(rad)+y);
    vertex(cosLUT[i]*(rad+w)+x,sinLUT[i]*(rad+w)+y);
  }
  endShape();
}
  
int[] chooseRandomColor() {
  
  String[] colors = new String[7];
  
  // color palette - change here to try different palette
  colors[0] = "242,15,98";
  colors[1] = "255,154,46";
  colors[2] = "249,248,30";
  colors[3] = "143,210,42";
  colors[4] = "100,41,148";
  colors[5] = "0,0,0";
  
  float q = random(6);
  int c = int(q);
  String[] colorlist = split(colors[c], ','); 
  int[] colorlist_ = int(colorlist);
  return colorlist_; 
}



void keyPressed(){                 // Keyboard controls

  if (key =='w'){                  // 'w' Wireframe YES/NO
    if (isWireFrame){
      isWireFrame=false;
    } 
    else {
      isWireFrame=true;
    }
  }
  
    
  if (key =='b'){                  // 'b' Background White/Black
    if (bgcolor==255){
      bgcolor=0;
    } 
    else {
      bgcolor=255;
    }
  }
  
    if(key == CODED) {             // 'UP' Sphere resolution up
    // res
    if (keyCode == UP) { 
      if (res<20){
        res++;
      } 
    } 
    else if (keyCode == DOWN){     // 'DOWN' Sphere resolution down
      if (res>3){
        res--;
      }
    }   
    if (keyCode == RIGHT) {        // 'RIGHT' Sphere size grow
      if (radius<300){
        radius++;
      } 
    } 
    else if (keyCode == LEFT) {    // 'LEFT' Sphere size down
      if (radius>3){
        radius--;
      }
    }   
   
   
     }
  }

