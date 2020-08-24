//based on this site (en) https://en.wikipedia.org/wiki/Quicksort
//(jp)https://ja.wikipedia.org/wiki/%E3%82%AF%E3%82%A4%E3%83%83%E3%82%AF%E3%82%BD%E3%83%BC%E3%83%88
int n = 100;//number of values
float[] values = new float[n];
float w;

void setup(){
  size(500, 500);
  colorMode(HSB, 360, 100, 100);
  w = float(width)/n;
  for(int i=0; i<n; i++){
    values[i] = random(height);
  }
  quicksort(values, 0, values.length-1);
}

void draw(){
  background(360);
  noStroke();
  for(int i=0; i<n; i++){
    fill(map(values[i], 0, height, 0, 360), 100, 100);
    rect(i*w, height, w, -values[i]);
  }
}
//             target    ,start    ,end
void quicksort(float[] a, int left, int right){
  if(left < right){
    int i = left, j = right;
    float tmp;//use when exchange value
    float pivot = med3(a[i], a[i+(j-i)/2], a[j]);//(i+j)/2 will over flow
    while(true){
      while(a[i] < pivot) i++;//find point that a[i] >= pivot
      while(pivot < a[j]) j--;//find point that a[j] <= pivot
      if(i >= j)break;
      tmp = a[i]; a[i] = a[j]; a[j] = tmp;//exchange a[i], a[j]
      i++; j--;
    }
    quicksort(a, left, i - 1);//sort recursive
    quicksort(a, j + 1, right);//
  }
}

//returns intermediate value
float med3(float x, float y, float z){
  if (x < y) {
        if (y < z) return y; 
        else if (z < x) return x; 
        else return z;
    } else {
        if (z < y) return y; 
        else if (x < z) return x; 
        else return z;
    }
}
