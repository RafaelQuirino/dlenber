class Face {

  //Redundant, but will ease things out
  //(or perhaps not...)
  float[][] points;

  // Circular list of vertices
  int[] pointIndexes;
  int listLimit;
  int listSize;

  // RGB color component
  float r,g,b; //percentage
  int   R,G,B; //absolute
  color myColor;

  // Average z-index
  float avgZ;

  Face () {
    this.listLimit = 1024;
    this.listSize = 0;
    this.pointIndexes = new int[this.listLimit];

    this.r = 0;
    this.g = 0;
    this.b = 0;

    this.avgZ = 0;
    this.points = null;
  }

  Face (int[] pointIndexes) {

  }

  Face (float[][] points) {
    this();
    this.points = points;
  }

  void printInfo () {
    print("Face info: (");
    for (int i=0; i<this.listSize; i++) {
      if (i == this.listSize-1)
        print(this.pointIndexes[i]+"), ");
      else
        print(this.pointIndexes[i]+", ");
    }
    print("("+this.r+","+this.g+","+this.b+"), ");
    print(this.avgZ+"\n");
  }

  void setRGB () {
    this.R = (int) (r*255.0);
    this.G = (int) (g*255.0);
    this.B = (int) (b*255.0);
  }

  void setColor () {
    this.setRGB();
    this.myColor = color(this.R,this.G,this.B);
  }

  void setColor (color thecolor) {
    this.R = (int) red(thecolor);   this.r = (float) this.R/255.0;
    this.G = (int) green(thecolor); this.g = (float) this.G/255.0;
    this.B = (int) blue(thecolor);  this.b = (float) this.B/255.0;
    this.myColor = thecolor;
  }

  void addPointIndex (int index) {
    this.pointIndexes[this.listSize++] = index;
  }

  void calculateAvgZ (float[][] points) {
    float avg = 0.0f;
    for (int i = 0; i < this.listSize; i++) {
      float z = points[this.pointIndexes[i]][2];
      avg += z;
    }
    this.avgZ = avg/(float)this.listSize;
  }

  void render (float[][] points, boolean selected) {
    // Test --------------------------------------------------------------------
    if (false) {
      float[][] p = points;
      int[] pi = pointIndexes;
      int n = listSize;
      int f = pi[0]; // first
      float minX=p[f][0], maxX=p[f][0], minY=p[f][1], maxY=p[f][1];
      for (int i = 1; i < n; i++) {
        float x = p[pi[i]][0], y = p[pi[i]][1];
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
      }
      float x=minX, y=minY, w=(maxX-minX), h=(maxY-minY);
      int x0 = (int)x;
      int y0 = ((int)y) + 2;
      if (true) {
        for (int i = 0; i < 100; i++) {
          lin_bres(x0,y0+i,x0+100,y0+i,color(255,0,0));
        }
      } else {
        fill(color(255,0,0));
        rect(x0,y0,100,100);
        fill(fill_color);
      }
    }
    //--------------------------------------------------------------------------

    // Processing like fill polygon --------------------------------------------
    if (selected) stroke(YELLOW);
    else          stroke(this.myColor);

    // scanline_fill(points,pointIndexes,listSize,c);
    my_fill_poly(points,pointIndexes,listSize,this.myColor);

    stroke(fill_color);
    //--------------------------------------------------------------------------
  }
}
