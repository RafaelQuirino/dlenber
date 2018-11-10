class Universe {
  Config config;
  Object3D axis, grid;
  Object3D trGizmo, rotGizmo, scGizmo;

  float fx;
  float fz;

  boolean showAxis;
  boolean showGrid;

  Object3D[] objects;
  int numObjects;
  int limit;

  // Current state of each transformation
  float rx, ry, rz;
  float sx, sy, sz;
  float tx, ty, tz;

  // Steps for each transformation
  float dr, ds, dt;

  boolean translateUniverse;
  boolean rotateUniverse;
  boolean scaleUniverse;

  Universe (
    int minX, int maxX, int minY, int maxY, int minZ, int maxZ,
    int myWidth, int myHeight
  )
  {
    this.config = new Config(minX,maxX,minY,maxY,minZ,maxZ,myWidth,myHeight);

    this.fx = this.config.minX * 100.0f;
    this.fz = this.config.minZ * 100.0f;

    this.showAxis = true;
    this.showGrid = true;

    this.numObjects = 0;
    this.limit = 1024;
    this.objects = new Object3D[this.limit];

    createAxis();
    createGrid();
    createGizmos();

    this.initStates();
    this.initSteps();

    this.translateUniverse = true;
    this.rotateUniverse = false;
    this.scaleUniverse = false;
  }

  void toggleTranslateUniverse() {
    this.translateUniverse = !this.translateUniverse;
  }

  void toggleRotateUniverse() {
    this.rotateUniverse = !this.rotateUniverse;
  }

  void toggleScaleUniverse() {
    this.scaleUniverse = !this.scaleUniverse;
  }

  void initStates () {
    this.rx = 0.0f; this.ry = 0.0f; this.rz = 0.0f;
    this.sx = 0.0f; this.sy = 0.0f; this.sz = 0.0f;
    this.tx = 0.0f; this.ty = 0.0f; this.tz = 0.0f;
    this.axis.initStates();
    this.grid.initStates();
  }

  void initSteps () {
    this.dr = 1.0f;
    this.ds = 0.05f;
    this.dt = 1.0f;
  }

  void toggleShowAxis () {
    this.showAxis = !this.showAxis;
  }

  void toggleShowGrid () {
    this.showGrid = !this.showGrid;
  }

  void addObject (Object3D obj) {
    this.objects[this.numObjects++] = obj;
  }

  void createAxis () {
    int skew = 5;
    float percent = 0.0f;

    float minx = this.config.minX + this.config.minX*percent;
    float maxx = this.config.maxX + this.config.maxX*percent;
    float miny = this.config.minY + this.config.minY*percent;
    float maxy = this.config.maxY + this.config.maxY*percent;
    float minz = this.config.minZ + this.config.minZ*percent;
    float maxz = this.config.maxZ + this.config.maxZ*percent;

    float[][] points = {
      {minx,0,0,1},
      {maxx,0,0,1},
      {0,miny,0,1},
      {0,maxy,0,1},
      {0,0,minz,1},
      {0,0,maxz,1},
      // x arrow
      {maxx,     0,0,1},
      {maxx-skew, skew,0,1},
      {maxx-skew,-skew,0,1},
      // y arrow
      {0,    maxy,     0,1},
      { skew,maxy-skew,0,1},
      {-skew,maxy-skew,0,1},
      // z arrow
      {0,    0,maxz,     1},
      { skew,0,maxz-skew,1},
      {-skew,0,maxz-skew,1}
    };

    int[][] lines = {
      {0,1},
      {2,3},
      {4,5},
      // x arrow
      {6,7},
      {6,8},
      // y arrow
      {9,10},
      {9,11},
      // z arrow
      {12,13},
      {12,14}
    };

    this.axis = new Object3D(points,lines);
    this.axis.setLineColor(RED,0);
    this.axis.setLineColor(GREEN,1);
    this.axis.setLineColor(BLUE,2);
    // x arrow
    this.axis.setLineColor(RED,3);
    this.axis.setLineColor(RED,4);
    // y arrow
    this.axis.setLineColor(GREEN,5);
    this.axis.setLineColor(GREEN,6);
    // z arrow
    this.axis.setLineColor(BLUE,7);
    this.axis.setLineColor(BLUE,8);
  }

  void createGrid () {
    // This is like the "floor"...
    float minx = (float) this.config.minX / 1.06f;
    float maxx = (float) this.config.maxX / 1.06f;
    float minz = (float) this.config.minZ / 1.06f;
    float maxz = (float) this.config.maxZ / 1.06f;

    float[][] points = {
      {minx,0,minz,1},
      {maxx,0,minz,1},
      {maxx,0,maxz,1},
      {minx,0,maxz,1},
      // Intermediate points
      // "horizontal"
      {minx/2.0f,0,minz,1},
      {minx/2.0f,0,maxz,1},
      {0,0,minz,1},
      {0,0,maxz,1},
      {maxx/2.0f,0,minz,1},
      {maxx/2.0f,0,maxz,1},
      // "vertical"
      {minx,0,minz/2.0f,1},
      {maxx,0,minz/2.0f,1},
      {minx,0,0,1},
      {maxx,0,0,1},
      {minx,0,maxz/2.0f,1},
      {maxx,0,maxz/2.0f,1}
    };

    int[][] lines = {
      {0,1},
      {1,2},
      {2,3},
      {3,0},
      // Intermediate lines
      // "horizontal"
      {4,5},
      {6,7},
      {8,9},
      // "vertical"
      {10,11},
      {12,13},
      {14,15}
    };

    this.grid = new Object3D(points,lines);
    this.grid.setColor(DARK_GRAY);
  }

  void createGizmos () {

  }

  void updateRotation (Axis axis, Direction dir, float angle) {
    if (axis == Axis.X)
      this.rx = dir == Direction.POSITIVE ? this.rx + angle : this.rx - angle;
    if (axis == Axis.Y)
      this.ry = dir == Direction.POSITIVE ? this.ry + angle : this.ry - angle;
    if (axis == Axis.Z)
      this.rz = dir == Direction.POSITIVE ? this.rz + angle : this.rz - angle;
  }

  void rotate (Axis axis, Direction dir) {
    this.updateRotation(axis,dir,this.dr);

    this.grid.updateRotation(axis,dir,this.dr);
    this.axis.updateRotation(axis,dir,this.dr);
    for (int i = 0; i < this.numObjects; i++)
      this.objects[i].updateRotation(axis,dir,this.dr);
  }

  void updateScale (Axis axis, Direction dir, float factor) {
    if (axis == Axis.X)
      this.sx = dir == Direction.POSITIVE ? this.sx + factor : this.sx - factor;
    if (axis == Axis.Y)
      this.sy = dir == Direction.POSITIVE ? this.sy + factor : this.sy - factor;
    if (axis == Axis.Z)
      this.sz = dir == Direction.POSITIVE ? this.sz + factor : this.sz - factor;
    if (axis == Axis.ALL_3) {
      if (dir == Direction.POSITIVE) {
        this.sx += factor;
        this.sy += factor;
        this.sz += factor;
      }
      if (dir == Direction.NEGATIVE) {
        float third_factor = factor/3.0f;
        this.sx -= third_factor;
        this.sy -= third_factor;
        this.sz -= third_factor;
      }
    }
  }

  void scale (Axis axis, Direction dir) {
    this.updateScale(axis,dir,this.ds);

    this.grid.updateScale(axis,dir,this.ds);
    this.axis.updateScale(axis,dir,this.ds);
    for (int i = 0; i < this.numObjects; i++)
      this.objects[i].updateScale(axis,dir,this.ds);
  }

  void updateTranslation(Axis axis, Direction dir, float distance) {
    float newtx = this.tx, newty = this.ty, newtz = this.tz;

    if (axis == Axis.X) {
      if (dir == Direction.POSITIVE)      newtx = this.tx + distance;
      else if (dir == Direction.NEGATIVE) newtx = this.tx - distance;
    }
    if (axis == Axis.Y) {
      if (dir == Direction.POSITIVE)      newty = this.ty + distance;
      else if (dir == Direction.NEGATIVE) newty = this.ty - distance;
    }
    if (axis == Axis.Z) {
      if (dir == Direction.POSITIVE)      newtz = this.tz + distance;
      else if (dir == Direction.NEGATIVE) newtz = this.tz - distance;
    }

    this.tx = newtx;
    this.ty = newty;
    this.tz = newtz;
  }

  void translate (Axis axis, Direction dir) {
    this.updateTranslation(axis,dir,this.dt);

    this.grid.updateTranslation(axis,dir,this.dt);
    this.axis.updateTranslation(axis,dir,this.dt);
    for (int i = 0; i < this.numObjects; i++)
      this.objects[i].updateTranslation(axis,dir,this.dt);
  }

  void update (Projection proj) {
    this.axis.update(this.config,proj,this.fx,this.fz);
    this.grid.update(this.config,proj,this.fx,this.fz);

    for (int i = 0; i < this.numObjects; i++)
      this.objects[i].update(this.config,proj,this.fx,this.fz);
  }

  void render () {
    // Here, axis must be rendered after grid...
    if (this.showGrid) this.grid.render();
    if (this.showAxis) this.axis.render();

    for (int i = 0; i < this.numObjects; i++)
      this.objects[i].render();
  }

  void reset () {
    this.axis.reset();
    this.grid.reset();

    for (int i = 0; i < this.numObjects; i++)
      this.objects[i].reset();
  }



  // Static object created for demonstration purpose
  Object3D getCube () {
    float[][] points = {
      {-20,  20,  20, 1},
      { 20,  20,  20, 1},
      { 20,  20, -20, 1},
      {-20,  20, -20, 1},
      {-20, -20, -20, 1},
      {-20, -20,  20, 1},
      { 20, -20,  20, 1},
      { 20, -20, -20, 1}
    };

    int[][] lines = {
      {0, 1},
      {1, 2},
      {2, 3},
      {3, 4},
      {4, 5},
      {5, 6},
      {6, 7},
      {7, 4},
      {0, 3},
      {0, 5},
      {1, 6},
      {2, 7}
    };

    return new Object3D(points,lines);
  }
}
