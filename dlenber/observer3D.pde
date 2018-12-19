class Observer3D {
  Object3D obj;

  float x, orig_x;
  float y, orig_y;
  float z, orig_z;

  Observer3D (float x, float y, float z) {
    this.orig_x = this.x = x;
    this.orig_y = this.y = y;
    this.orig_z = this.z = z;

    float[][] points = {{this.x,this.y,this.z,1}};
    int[][] lines = {{0,0}};
    this.obj = new Object3D(points,lines);
  }

  void updatePosition () {
    this.x = this.obj.points[0][0];
    this.y = this.obj.points[0][1];
    this.z = this.obj.points[0][2];
  }

  void updateRotation (Axis axis, Direction dir, float angle) {
    Direction mydir = dir == Direction.POSITIVE ? Direction.NEGATIVE : Direction.POSITIVE;
    this.obj.updateRotationUniverse(axis,dir,angle);
    this.updatePosition();
  }
}
