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

  float[] getCenter(float[][] points) {
    float meanX=0.0f, meanY=0.0f, meanZ=0.0f;
    for (int i = 0; i < this.listSize; i++) {
      meanX += points[this.pointIndexes[i]][0];
      meanY += points[this.pointIndexes[i]][1];
      meanZ += points[this.pointIndexes[i]][2];
    }
    meanX /= this.listSize;
    meanY /= this.listSize;
    meanZ /= this.listSize;
    float[] center = {meanX,meanY,meanZ};
    return center;
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

  float calculatePhongIllumination (Observer3D obsv, Light3D light, float[][] points) {
    // Parameters
    float Iamb = 0.8; // Ambiente light intensity
    int v = this.pointIndexes[1];
    float px = points[v][0];
    float py = points[v][1];
    float pz = points[v][2];
    float obsvx  = obsv.x;
    float obsvy  = obsv.y;
    float obsvz  = obsv.z;
    float lightx = light.lamp.points[0][0];
    float lighty = light.lamp.points[0][1];
    float lightz = light.lamp.points[0][2];

    // Calculate vectors L, N, V, cos(theta) -----------------------------------
    float[] L = {(lightx-px), (lighty-py), (lightz-pz)};
    normalize_vector(L);
    float[] N = this.calculateNormal(points);
    normalize_vector(N);
    float[] V = {(obsvx-px), (obsvy-py), (obsvz-pz)};
    normalize_vector(V);
    float cos_theta = cos_vectors(N,L);
    // float theta = acos(cos_theta);
    //--------------------------------------------------------------------------

    // Ambient -----------------------------------------------------------------
    float Ia = this.material.Ka * Iamb;
    //--------------------------------------------------------------------------

    // Diffuse -----------------------------------------------------------------
    float Id = this.material.Kd * light.Ii * cos_theta;
    //--------------------------------------------------------------------------

    // Specular ----------------------------------------------------------------
    float Is = light.Ii * this.material.Ks * pow(cos_theta,this.material.alpha);
    //--------------------------------------------------------------------------

    float illumination = Ia + Id + Is;
    if (illumination < 0) illumination = 0;

    return illumination;
  }

  void render (float[][] points, boolean selected) {
    // Calling fill polygon in algorithms.pdf ----------------------------------
    if (selected) stroke(YELLOW);
    else          stroke(this.myColor);
    my_fill_poly(points,this.pointIndexes,this.listSize,this.myColor);
    stroke(fill_color);
    //--------------------------------------------------------------------------
  }

  void render_2 (float[][] points, boolean selected, float illumination) {
    // Calling fill polygon in algorithms.pdf ----------------------------------
    if (selected) stroke(YELLOW);
    else          stroke(this.myColor);

    // int[] orig_rgb = {this.R,this.G,this.B};
    // print_rgb(orig_rgb);
    //
    // float[] hsl = rgbToHsl(this.R,this.G,this.B);
    // print_hsl(hsl);
    // hsl[2] = illumination;
    // print_hsl(hsl);
    // int[] rgb = hslToRgb(hsl[0],hsl[1],hsl[2]);
    // print_rgb(rgb);
    // print_separator();

    // float[] rgb = new float[3];
    // float l = illumination+0.2;
    // // float l = illumination > 0.5 ? 1+(illumination-0.5) : illumination;
    // rgb[0] = ((float)this.R)*(l);
    // rgb[1] = ((float)this.G)*(l);
    // rgb[2] = ((float)this.B)*(l);

    float[] rgb = shade_color(this.R,this.G,this.B,illumination);
    // int[] rgb = shade_color(this.R,this.G,this.B,illumination);

    color c = color((int)rgb[0],(int)rgb[1],(int)rgb[2]);
    my_fill_poly(points,this.pointIndexes,this.listSize,c);

    stroke(fill_color);
    //--------------------------------------------------------------------------
  }
}
