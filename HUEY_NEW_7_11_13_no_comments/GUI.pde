PImage Logo;
PImage Brush, Music, Splash, Grid, BrushB, MusicB, SplashB, GridB, Network, NetworkB, Root, RootB, Erase, EraseB;
PGraphics GUILAYER;
boolean drawmode = false, splashmode = false, musicmode = false, gridonoff = false, rootmode = false, networkmode = false, erasemode = false ;
PShape Kids;
AudioOutput out;
SineWave sine;
//--------Splash -------------------------
ArrayList splatpoop = new ArrayList();
//--------network Brush variable----------
ArrayList hist = new ArrayList();
float joinDist = 100;
//--------root Brush variable----------
ArrayList<Node> nodes = new ArrayList<Node>();
int lastRedraw;
color splc;
//----------------------------------------
void GUIimages() {
  GUILAYER = createGraphics(displayWidth, displayHeight, P3D);
  //---------NEUTRAL------------------------
  BrushB = loadImage("Brushb.jpg");
  MusicB = loadImage("Musicb.jpg");
  SplashB = loadImage("splashb.jpg");
  GridB = loadImage("GridB.jpg");
  RootB = loadImage("rootb.jpg");
  NetworkB = loadImage("networkb.jpg");
  EraseB = loadImage("EraserB.jpg");
  //---------ACTIVE-------------------------
  Brush = loadImage("Brush.jpg");
  Music = loadImage("Music.jpg");
  Splash = loadImage("splash.jpg");
  Grid = loadImage("Grid.jpg");
  Root = loadImage("root.jpg");
  Network = loadImage("network.jpg");
  Erase = loadImage("Eraser.jpg");
  Logo = loadImage("logo.png");
  Kids = loadShape("kids.svg");
}

void GUI() {
  //--------------------------START MAIN GUI ---------------------------------
  GUILAYER.beginDraw();
  GUILAYER.background(-1, 0);
  GUILAYER.smooth();
  GUILAYER.beginShape();
  GUILAYER.noStroke();
  GUILAYER.fill(#FF005E);
  GUILAYER.vertex(0, 0);//1
  GUILAYER.vertex(width, 0);//2
  GUILAYER.vertex(width, 30);//3
  GUILAYER.vertex(7*width/10+25, 30);//4
  GUILAYER.vertex(7*width/10, 45);//5
  GUILAYER.vertex(3*width/10, 45);//6
  GUILAYER.vertex(3*width/10-25, 30);//7
  GUILAYER.vertex(0, 30);//8
  GUILAYER.endShape();
  GUILAYER.stroke(0);
  GUILAYER.line(0+10, height-BrushB.height-20, width-10, height-BrushB.height-20);
  GUILAYER.noStroke();
  //----------------- Music -----------------------------------------------
  Music.resize(int(width*0.04), int(width*0.04));
  MusicB.resize(int(width*0.04), int(width*0.04));
  if (!musicmode) GUILAYER.image(MusicB, width/2-MusicB.width-50, height-MusicB.height-10);
  if (musicmode) GUILAYER.image(Music, width/2-Music.width-50, height-Music.height-10);
  //----------------- Brush -----------------------------------------------
  Brush.resize(int(width*0.04), int(width*0.04));
  BrushB.resize(int(width*0.04), int(width*0.04));
  if (!drawmode) GUILAYER.image(BrushB, width/2-BrushB.width/2, height-BrushB.height-10);
  if (drawmode) GUILAYER.image(Brush, width/2-Brush.width/2, height-Brush.height-10);
  //----------------- Brsuh Network -----------------------------------------
  Network.resize(int(width*0.04), int(width*0.04));
  NetworkB.resize(int(width*0.04), int(width*0.04));
  if (drawmode && !networkmode) GUILAYER.image(NetworkB, width/2-NetworkB.width/2+200, height-NetworkB.height-10);
  if (drawmode && networkmode) GUILAYER.image(Network, width/2-Network.width/2+200, height-Network.height-10);
  //----------------- Brush Root-----------------------------------------------
  Root.resize(int(width*0.04), int(width*0.04));
  RootB.resize(int(width*0.04), int(width*0.04));
  if (drawmode && !rootmode) GUILAYER.image(RootB, width/2-RootB.width/2-200, height-RootB.height-10);
  if (drawmode && rootmode ) GUILAYER.image(Root, width/2-Root.width/2-200, height-Root.height-10);
  //----------------- ERASER Left -----------------------------------------------
  Erase.resize(int(width*0.04), int(width*0.04));
  EraseB.resize(int(width*0.04), int(width*0.04));
  if (drawmode && !erasemode) GUILAYER.image(EraseB, 0, height/2);
  if (drawmode && erasemode) GUILAYER.image(Erase, 0, height/2);
  //----------------- ERASER Right-----------------------------------------------
  Erase.resize(int(width*0.04), int(width*0.04));
  EraseB.resize(int(width*0.04), int(width*0.04));
  if (drawmode && !erasemode) GUILAYER.image(EraseB, width-EraseB.width, height/2);
  if (drawmode && erasemode) GUILAYER.image(Erase, width- Erase.width, height/2);
  //----------------- Splash -----------------------------------------------
  Splash.resize(int(width*0.04), int(width*0.04));
  SplashB.resize(int(width*0.04), int(width*0.04));
  if (!splashmode) GUILAYER.image(SplashB, width/2+50, height-SplashB.height-10);
  if (splashmode) GUILAYER.image(Splash, width/2+50, height-Splash.height-10);
  //------------------ LOGO -----------------------------------------------
  Logo.resize(int(width*0.04), int(width*0.04));
  GUILAYER.ellipse(Logo.width + 40, Logo.height/2, Logo.width+10, Logo.width+10);
  GUILAYER.pushStyle();
  GUILAYER.imageMode(CENTER);
  GUILAYER.image(Logo, Logo.width + 40, Logo.height/2);
  GUILAYER.popStyle();
  GUILAYER.endDraw();
  //--------------------------END MAIN GUI ---------------------------------
  //image(GUILAYER, 0, 0);
}

//-------------------ERASER FUNCTION ------------------

void eraseFunction(float linex, float liney) {
  color c = color(0, 0);
  pg.beginDraw();
  pg.loadPixels();
  for (int x=0; x<pg.width; x++) {
    for (int y=0; y<pg.height; y++ ) {
      float distance = dist(x, y, linex, liney);
      if (distance <= 25) {
        int loc = x + y*pg.width;
        pg.pixels[loc] = c;
      }
    }
  }
  pg.updatePixels();
  pg.endDraw();
}

//-------------------root brush functions ------------
Node findNearest(Node p)
{
  float minDist = 1e10;
  int minIdx = -1;
  for (int i = 0; i < nodes.size(); ++i)
  {
    float d = p.dist(nodes.get(i));
    if (d < minDist)
    {
      minDist = d;
      minIdx = i;
    }
  }
  return nodes.get(minIdx);
}


void grow(float linex, float liney)
{
  float x, y;
  do
  {
    x = random(-40, 40);
    y = random(-40, 40);
  } 
  while (sq (x) + sq(y) > sq(40));
  x += linex;
  y += liney;

  Node sample = new Node(x, y);
  Node base = findNearest(sample);
  if (base.dist(sample) < 10.0)
    return;
  Node newNode = new Node(base, sample);
  nodes.add(newNode);
  newNode.display();
}

void updateWeights()
{
  for (int i = 0; i < nodes.size(); ++i)
    nodes.get(i).weight = 1;
  for (int i = nodes.size()-1; i >= 0; --i)
  {
    Node node = nodes.get(i);
    if (node.parent != null)
      node.parent.weight += node.weight;
  }
}

//void redraw_all()
//{
//  //pg.background(192);
//  updateWeights();
//  for (Node node : nodes)
//    node.display();
//}

class Node
{
  PVector pos;
  Node parent;
  int weight;

  Node(float x, float y)
  {
    pos = new PVector(x, y);
    weight = 1;
  }

  Node(Node base, Node sample)
  {
    PVector step = PVector.sub(sample.pos, base.pos);
    step.limit(5.0);
    pos = PVector.add(base.pos, step);
    parent = base;
    weight = 1;
  }

  float dist(Node other)
  {
    return PVector.dist(pos, other.pos);
  }

  void display()
  {
    if (parent == null)
      return;
    pg.strokeWeight(1+log(weight)*0.5);  
    pg.line(parent.pos.x, parent.pos.y, pos.x, pos.y);
  }
}

