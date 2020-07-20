//based on this site kimasendorf.com https://www.youtube.com/watch?v=tE84V0iGso8

int mode = 1;

// image path is relative to sketch directory
PImage img, sortedImg;
boolean[][] mask;//sort when false

int loops = 1;

// threshold values to determine sorting start and end pixels
int brightnessValue = 60;

int row = 0;
int column = 0;

void setup() {
  //fullScreen();
  size(1280, 720);
  img = loadImage("green-nature.jpg");
  
  // allow resize and update surface to image dimensions
  //surface.setResizable(true);
  //surface.setSize(img.width, img.height);
  
  // load image onto surface - scale to the available width,height for display
  image(img, 0, 0, width, height);
}


void draw() {
  brightnessValue = (int)map(mouseY, 0, height, 0, 255);
  
  mask = new boolean[img.width][img.height];
  for(float i=0; i<img.width; i++){
    for(float j=0; j<img.height; j++){
      mask[(int)i][(int)j] = noise(i/100., j/100.)*255 > brightnessValue;
    }
  }
  
  sortedImg = img.copy();
  
  column = 0;
  // loop through columns
  sortedImg.updatePixels();
  while(column < sortedImg.width-1) {
    //println("Sorting Column " + column);
    sortColumn();
    column++;
  }
  sortedImg.updatePixels();
  
  brightnessValue = (int)map(mouseX, 0, width, 0, 255);
  mask = new boolean[img.width][img.height];
  for(float i=0; i<img.width; i++){
    for(float j=0; j<img.height; j++){
      mask[(int)i][(int)j] = brightness(img.pixels[(int)i + (int)j * img.width]) > brightnessValue;
    }
  }
  
  row = 0;
  // loop through rows
  sortedImg.loadPixels(); 
  while(row < sortedImg.height-1) {
    //println("Sorting Row " + column);
    sortRow();
    row++;
  }
  sortedImg.updatePixels();
  
  // load updated image onto surface and scale to fit the display width,height
  image(sortedImg, 0, 0, width, height);
}

void sortRow() {
  // current row
  int y = row;
  
  // where to start sorting
  int x = 0;
  
  // where to stop sorting
  int xend = 0;
  
  while(xend < sortedImg.width-1) {
    x = getFirstX(x, y);
    xend = getNextX(x, y);
    
    if(x < 0) break;
    
    int sortLength = xend-x;
    
    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsorted[i] = sortedImg.pixels[x + i + y * sortedImg.width];
    }
    
    sorted = sort(unsorted);
    
    for(int i=0; i<sortLength; i++) {
      sortedImg.pixels[x + i + y * sortedImg.width] = sorted[i];      
    }
    
    x = xend+1;
  }
}


void sortColumn() {
  // current column
  int x = column;
  
  // where to start sorting
  int y = 0;
  
  // where to stop sorting
  int yend = 0;
  
  while(yend < sortedImg.height-1) {
    y = getFirstBrightY(x, y);
    yend = getNextDarkY(x, y);
    
    if(y < 0) break;
    
    int sortLength = yend-y;
    
    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsorted[i] = sortedImg.pixels[x + (y+i) * sortedImg.width];
    }
    
    sorted = sort(unsorted);
    
    for(int i=0; i<sortLength; i++) {
      sortedImg.pixels[x + (y+i) * sortedImg.width] = sorted[i];
    }
    
    y = yend+1;
  }
}


// brightness x
int getFirstX(int x, int y) {
  
  while(mask[x][y] == false) {//brightness(img.pixels[x + y * img.width])
    x++;
    if(x >= img.width)
      return -1;
  }
  
  return x;
}

int getNextX(int _x, int _y) {
  int x = constrain(_x+1, 0, img.width-1);
  int y = _y;
  while(mask[x][y]) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}

// brightness y
int getFirstBrightY(int x, int y) {

  if(y < img.height) {
    while(mask[x][y] == false) {
      y++;
      if(y >= img.height)
        return -1;
    }
  }
  
  return y;
}

int getNextDarkY(int x, int y) {
  y++;

  if(y < img.height) {
    while(mask[x][y]) {
      y++;
      if(y >= img.height)
        return img.height-1;
    }
  }
  return y-1;
}
