class Face {

  // Circular list of vertices
  int[] pointIndexes;
  int listLimit;
  int listSize;

  // RGB color component
  float r,g,b;

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
  }

  Face (int[] pointIndexes) {
    
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

  void addPointIndex (int index) {
    this.pointIndexes[this.listSize++] = index;
  }

  void calculateAvgZ () {

  }

  void render () {

  }
}
