// Calculates ring tables for "Chainmail Spheres"
// by Les Hall
// Sun Nov 11 2018
// 


// initialize the user visible variables
float diameter = 2 * 25.4;  // sphere diameter
int egg = 0;  // egg shape selection
int ring = 2;  // ring geometry selection


// shape values
float shape[][] = {
  {1, 1},  // Sphere
  {1, 1.75},  // Dragon's egg
  {1.1, 1.6},  // Japan's egg
  {1, 1.5},  // America's egg
  {1, 2}  // Test egg
};  // eggcentricity
// 
// ring values
String maille[] = {
  "Kingsmaille (x2)", 
  "Kingsmaille (x2)", 
  "Kingsmaille (x2)", 
  "European 8-1"};
float ID[] = {9.53, 10.0, 5.7, 7.0};
float AR[] = {4.7, 4.8, 4.75, 5.8};
float horiz[] = {0.74, 0.773, 0.743, 0.417};
float vert[] = {0.895, 0.715, 0.799, 0.679};
String weave = maille[ring];  // weave type
float ringID = ID[ring];  // ring inside diameter
float kh = horiz[ring];  // horizontal proportionality constant
float kv = vert[ring];  // vertical proportionality constant


// parameters
boolean debug = true;
color bgColor = color(0, 127, 127);
color fgColor = color(255);
color eggColor = color(191, 191, 191);


// initialize the hidden global variables
float d = diameter;
float di = ringID;
int textSize = 25;
float m = 0;
int mLen = 100;
float[] mList = {};
int n = 0;
float total = 0;
int tPos[] = {100, 210};  // table position (x, y)
int tCol[] = {0, 80};  // table column offsets (horizontal)
float temp = 0;
float x = 0;
float y = 0;
float v = 0;
int nMax[] = {0, 0};


void setup() {
  // graphics stuff
  size(1200, 800);
  rectMode(CENTER);
  x = width*0.775;
  y = height-height/(shape[egg][1]+shape[egg][0]);
  v = width*0.15;
  
  // sort the shape halves
  if (shape[egg][0] > shape[egg][1]) {
    temp = shape[egg][0];
    shape[egg][0] = shape[egg][1];
    shape[egg][1] = temp;
  }
    
  for (int i = 0; i < mLen; i++)
    mList = append(mList, -1);
}



void draw() {
  
  // graphics stuff
  background(bgColor);
  
  // draw the egg
  for(int side = 1; side >= 0; side--) {
    pushMatrix();
      //draw the egg half
      fill(eggColor);
      stroke(eggColor);
      translate(x, y);
      ellipse(0, 0, 2*v, 2*v*shape[egg][side]);
      // erase the larger side
      if(side == 1) {
        fill(bgColor);
        stroke(bgColor);
        translate(0, v/2*shape[egg][side]);
        rect(0, 0, 2*v, v*shape[egg][side]);
      }
    popMatrix();
  }
  fill(fgColor);
  stroke(fgColor);
  
  
  // title
  textAlign(CENTER, TOP);
  textSize(40);
  text("Chainmail Tables", width/2, 2*textSize);  
  textSize(30);
  text("for spheres and eggs", width/2, 4*textSize);  
  
  // text setings
  textAlign(RIGHT, TOP);
  textSize(textSize);

  total = 0;  // total number of rings
  for(int side = 0; side <= 1; side++) {
    
    // calculate column tab position
    float tLoc = 5*tCol[1] * (side);
    
    // table header
    textAlign(RIGHT, TOP);
    text("n", tPos[0] + tLoc + tCol[0], tPos[1]);
    text("m", tPos[0] + tLoc + tCol[1], tPos[1]);
    if ((debug) && (side == 1)) {
      text("rdc", tPos[0] + tLoc/2 - tCol[0], tPos[1]);
      text("crv", tPos[0] + tLoc/2 + tCol[1], tPos[1]);
    }
    
    // text setings
    textAlign(CENTER, TOP);
    text("shape = " + nf(shape[egg][side]), tPos[0] + tLoc + (tCol[0] + tCol[1])/2, tPos[1]-50);
  
    // text setings
    textAlign(RIGHT, TOP);
    
    n = 0;
    m = 0;
    float mPrev = 0;
    float delta = 0;
    float deltaPrev = 0;
    float curve = 0;
    float r = d/2.0;
    do {
      // make calculations
      mPrev = m;
      m =  ( (2*PI * r / (kh*di)) * cos( (kv*di/r) * n/shape[egg][side]) );
      //mList[nMax[side]+n] = m;
      mList[n] = m;
      deltaPrev = delta;
      delta = m - mPrev;
      curve = delta - deltaPrev;
      
      // write the rings per row text
      // which is the main point of the program
      if ( (m > 0) && (n >= side) ) {
        text(nf(n), 
          tPos[0] + tLoc + tCol[0], 
          tPos[1] + (n+3.0/2)*textSize);
        text(nf(m, 1, 1), 
          tPos[0] + tLoc + tCol[1], 
            tPos[1] + (n+3.0/2)*textSize);
      }
      
      // write the debug text
      if (debug && (n > 0) && (m >= 0) && (side == 1)) {
        text(nf(abs(delta), 1, 1), 
          tPos[0] + tLoc/2 + tCol[0], 
          tPos[1] + (n+3.0/2)*textSize);
        if (n > 1) {
          text(nf(abs(curve), 1, 1), 
          tPos[0] + tLoc/2 + tCol[1], 
            tPos[1] + (n+3.0/2)*textSize);
        }
      }
  
      // update counters
      n++;
      nMax[side] = n;
      total += m * (n == 0 ? 1/2 : 1);
    } while (m >= 0);
  }
  
  // draw the sphere\
  /*
  float prevX = 0;
  float fracX = 0;
  float delta = 0;
  n = 0;
  strokeWeight(4);
  for(int side = -1; side <= -1; side += 2) {
    int s = (side+1)/2;
    for (int i = 0; i < nMax[s]; i++) {
      stroke(0, 255*float(i)/nMax[s], 255-255*float(i)/nMax[s]);
      prevX = fracX;
      fracX = -float(mList[n])/float(mList[nMax[s]]);
      delta = fracX - prevX;
      float fracY = float(i)/float(nMax[s]) * delta;
      println(fracX);
      line(
        x - v*fracX, y - side*v*fracY, 
        x + v*fracX, y - side*v*fracY);
    n++;
    }
  }
  */

  // print out the table summary
  textAlign(CENTER);
  textSize(40);
  text(weave, width/2, height - 4*textSize);
  text("total:  " + nf(total, 1, 1), width/2, height - 2*textSize);
}
