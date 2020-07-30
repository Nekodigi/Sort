import java.util.Collections;

PImage baseImg;
ArrayList<Image> images = new ArrayList<Image>();
int tileS = 50;//100
int nw, nh;

void setup(){
  size(1000, 1000);
  //fullScreen();
  baseImg = loadImage("Mona_Lisa Small.jpg");
  baseImg.resize(width, height);
  baseImg.filter(GRAY);
  nw = ceil((float)baseImg.width / tileS);
  nh = ceil((float)baseImg.height/ tileS);
  for(int i=0; i<baseImg.width; i+=tileS){
    for(int j=0; j<baseImg.height; j+=tileS){
      images.add(new Image(i, j, baseImg.get(i, j, tileS, tileS)));
    }
  }
  for(Image img : images){
    img.calcAvg();
  }
  Collections.sort(images, new ImageComp());
  for(int i=0; i<nw; i++){
    for(int j=0; j<nh; j++){
      images.get(i+j*nw).pos2 = new PVector(i*tileS, j*tileS);//update positon
    }
  }
}

void draw(){
  background(0);
  float fac = 0.5+0.5*sin(float(frameCount)/100);
  for(int i=0; i<nw; i++){
    for(int j=0; j<nh; j++){
      images.get(i+j*nw).show(fac);
    }
  }
}

class Image{
  PVector pos1, pos2;
  PImage img;
  color avgCol;
  
  Image(float x, float y, PImage img){
    this.pos1 = new PVector(x, y);
    this.img = img;
  }
  
  void calcAvg(){
    float r = 0, g = 0, b = 0;
    int count = 0;
    for(int i=0; i<img.width; i++){
      for(int j=0; j<img.height; j++){
        color tcol = img.pixels[i+j*img.width];
        r += red(tcol);
        g += green(tcol);
        b += blue(tcol);
        count++;
      }
    }
    avgCol = color(r/count, g/count, b/count);
  }
  
  void show(float fac){
    noStroke();
    fill(avgCol);
    //rect(pos.x, pos.y, tileS, tileS);
    PVector pos = PVector.lerp(pos1, pos2, fac);
    image(img, pos.x, pos.y);
  }
}
