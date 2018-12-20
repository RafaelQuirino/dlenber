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

  Material material;

  Face () {
    this.listLimit = 1024;
    this.listSize = 0;
    this.pointIndexes = new int[this.listLimit];

    this.r = 0;
    this.g = 0;
    this.b = 0;

    this.avgZ = 0;
    this.points = null;

    this.material = getStandardDiffuseMaterial();
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

  Face[] getNeighborFaces (Object3D obj) {
    Face[] neighbors = new Face[1];

    return neighbors;
  }

  float[] calculateNormal (float[][] points) {
    float[] normal = new float[3];

    int v1 = this.pointIndexes[0];
    int v2 = this.pointIndexes[1];
    int v3 = this.pointIndexes[2];
    float p1x = points[v1][0], p1y = points[v1][1], p1z = points[v1][2];
    float p2x = points[v2][0], p2y = points[v2][1], p2z = points[v2][2];
    float p3x = points[v3][0], p3y = points[v3][1], p3z = points[v3][2];
    float nx = ((p3y-p2y)*(p1z-p2z))-((p1y-p2y)*(p3z-p2z));
    float ny = ((p3z-p2z)*(p1x-p2x))-((p1z-p2z)*(p3x-p2x));
    float nz = ((p3x-p2x)*(p1y-p2y))-((p1x-p2x)*(p3y-p2y));
    normal[0] = nx;
    normal[1] = ny;
    normal[2] = nz;

    return normal;
  }

  float calculatePhongIllumination () {
    // Ambient -----------------------------------------------------------------
    //--------------------------------------------------------------------------

    // Diffuse -----------------------------------------------------------------
    //--------------------------------------------------------------------------

    // Specular ----------------------------------------------------------------
    //--------------------------------------------------------------------------
    
    return 1.0f;
  }

  void render (float[][] points, boolean selected) {
    // Calling fill polygon in algorithms.pdf ----------------------------------
    if (selected) stroke(YELLOW);
    else          stroke(this.myColor);
    my_fill_poly(points,this.pointIndexes,this.listSize,this.myColor);
    stroke(fill_color);
    //--------------------------------------------------------------------------
  }
}
