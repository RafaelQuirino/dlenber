class Config {
  int minX, maxX;
  int minY, maxY;
  int minZ, maxZ;
  int myWidth, myHeight;

  int H, W, D;

  float multX, multY, mult;
  float dx, dy;

  Config (
    int minX, int maxX, int minY, int maxY, int minZ, int maxZ,
    int myWidth, int myHeight
  )
  {
    this.minX = minX; this.maxX = maxX;
    this.minY = minY; this.maxY = maxY;
    this.minZ = minZ; this.maxZ = maxZ;
    this.myWidth = myWidth;
    this.myHeight = myHeight;

    this.H = this.maxY - this.minY;
    this.W = this.maxX - this.minX;
    this.D = this.maxZ - this.minZ;

    this.multX = (float) this.myWidth / (float) this.W;
    this.multY = (float) this.myHeight / (float) this.H;
    this.mult = min(this.multX, this.multY);
    this.dx = this.myWidth  - this.W*this.mult;
    this.dy = this.myHeight - this.H*this.mult;
  }

  void printConfig() {
    print("X: [" + this.minX + ", " + this.maxX + "]\n");
    print("Y: [" + this.minY + ", " + this.maxY + "]\n");
    print("Z: [" + this.minZ + ", " + this.maxZ + "]\n");
    print("width,height: (" + this.myWidth + ", " + this.myHeight + ")\n");
    print("W,H,D: " + this.W + ", " + this.H + ", " + this.D + "\n");
    print("multx, multY, mult: " + this.multX + ", " + this.multY + ", " + this.mult + "\n");
    print("dx,dy: " + this.dx + ", " + this.dy + "\n\n");
  }
}
