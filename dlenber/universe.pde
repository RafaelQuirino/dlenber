import java.util.Scanner;

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
  int selectedObject;

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
    this.selectedObject = 0;

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
      this.objects[i].updateRotationUniverse(axis,dir,this.dr);
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
      this.objects[i].updateScaleUniverse(axis,dir,this.ds);
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
      this.objects[i].updateTranslationUniverse(axis,dir,this.dt);
  }

  void update (Projection proj) {
    this.axis.update(this.config,proj,this.fx,this.fz);
    this.grid.update(this.config,proj,this.fx,this.fz);

    // print("this.numObjects: "+this.numObjects+"\n");
    // print("this.objects.length: "+this.objects.length+"\n");

    for (int i = 0; i < this.numObjects; i++)
      this.objects[i].update(this.config,proj,this.fx,this.fz);
  }

  void render () {
    // Here, axis must be rendered after grid...
    if (this.showGrid) this.grid.render();
    if (this.showAxis) this.axis.render();

    for (int i = 0; i < this.numObjects; i++) {
      if (!(i == this.selectedObject))
        this.objects[i].render();
    }
    // Selected object must be rendered last, to get "upon" the ohters
    this.objects[this.selectedObject].renderColor(YELLOW);
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
      {-1, -1,  1, 1},
      { 1, -1,  1, 1},
      { 1,  1,  1, 1},
      {-1,  1,  1, 1},
      {-1, -1, -1, 1},
      { 1, -1, -1, 1},
      { 1,  1, -1, 1},
      {-1,  1, -1, 1}
    };

    int[][] lines = {
      {0,1},
      {1,2},
      {2,3},
      {3,0},
      {0,4},
      {1,5},
      {2,6},
      {3,7},
      {4,5},
      {5,6},
      {6,7},
      {7,4}
    };

    int[] face1 = {};
    int[] face2 = {};
    int[] face3 = {};
    int[] face4 = {};
    int[] face5 = {};
    int[] face6 = {};

    Face[] faces = {
      //TODO
    };

    Object3D cube_aux = new Object3D(points,lines);
    cube_aux.sx = 25;
    cube_aux.sy = 25;
    cube_aux.sz = 25;
    cube_aux.tx = 120;
    cube_aux.ty = 120;
    cube_aux.tz = 100;

    Object3D cube = new Object3D(cube_aux.points,cube_aux.lines);

    return cube;
  }

  Object3D getPyramid () {
    float[][] points = {
      {-1, -1,  1, 1},
      { 1, -1,  1, 1},
      { 1, -1, -1, 1},
      {-1, -1, -1, 1},
      { 0,  1,  0, 1}
    };

    int[][] lines = {
      {0,1},
      {1,2},
      {2,3},
      {3,0},
      {0,4},
      {1,4},
      {2,4},
      {3,4}
    };

    int[] face1 = {};
    int[] face2 = {};
    int[] face3 = {};
    int[] face4 = {};
    int[] face5 = {};

    Face[] faces = {
      //TODO
    };

    Object3D pyramid_aux = new Object3D(points,lines);
    pyramid_aux.ry = 90;
    pyramid_aux.sx = 40;
    pyramid_aux.sy = 40;
    pyramid_aux.sz = 40;
    pyramid_aux.tx = 20;
    pyramid_aux.ty = 20;
    pyramid_aux.tz = 20;
    pyramid_aux.transform();

    Object3D pyramid = new Object3D(pyramid_aux.points,pyramid_aux.lines);

    return pyramid;
  }

  Object3D[] importFigure (String filename) {
    String[] strlines = read_file(filename);
    double xmin = 0, xmax = 0, ymin = 0, ymax = 0;

    int NAME = 0, PLF_SIZES = 1, P = 2, L = 3, F = 4, ROT = 5, SC = 6, TR = 7;
    int step = NAME;

    Object3D objects[] = new Object3D[1];
    int num_objects = 0, sizep = 0, sizel = 0, sizef = 0;
    int curr_object = 0, count = 0;
    float points[][] = new float[1][4];
    int lines[][] = new int[1][1];
    Face faces[] = new Face[1];
    float rx=0, ry=0, rz=0;
    float sx=0, sy=0, sz=0;
    float tx=0, ty=0, tz=0;

    for (int i = 0; i < strlines.length; i++) {
      Scanner scanner = new Scanner(strlines[i]);
      if (i==0) {
        // Read figure name
        // TODO
      }
      else if (i==1) {
        // Read universe config (Xmin Xmax Ymin Ymax)
        // Not a good implementation, must fix...
        xmin = scanner.nextFloat();
        xmax = scanner.nextFloat();
        ymin = scanner.nextFloat();
        ymax = scanner.nextFloat();
        this.config.minX = (int) xmin;
        this.config.maxX = (int) xmax;
        this.config.minY = (int) ymin;
        this.config.maxY = (int) ymax;
      }
      else if (i==2) {
        // Read number of objects
        num_objects = scanner.nextInt();
        objects = new Object3D[num_objects];
      }
      else {
        // Read an object from the figure
        if (step==NAME) {
          // Read name of object
          // TODO
          step = PLF_SIZES;
        }
        else if (step==PLF_SIZES) {
          // Read number of points, lines and faces
          sizep = scanner.nextInt();
          sizel = scanner.nextInt();
          sizef = scanner.nextInt();
          points = new float[sizep][4];
          lines = new int[sizel][2];
          faces = new Face[sizef];
          step = P;
        }
        else if (step==P) {
          points[count][0] = scanner.nextFloat();
          points[count][1] = scanner.nextFloat();
          points[count][2] = scanner.nextFloat();
          points[count][3] = 1.0f;
          if (++count==sizep) {
            count = 0;
            step = L;
          }
        }
        else if (step==L) {
          lines[count][0] = scanner.nextInt()-1;
          lines[count][1] = scanner.nextInt()-1;
          if (++count==sizel) {
            count = 0;
            step = F;
          }
        }
        else if (step==F) {
          int num_vertices = scanner.nextInt();
          faces[count] = new Face();
          for (int k=0; k<num_vertices; k++)
            faces[count].addPointIndex(scanner.nextInt()-1);
          faces[count].r = scanner.nextFloat();
          faces[count].g = scanner.nextFloat();
          faces[count].b = scanner.nextFloat();
          if (++count==sizef) {
            count = 0;
            step = ROT;
          }
        }
        else if (step==ROT) {
          rx = scanner.nextFloat();
          ry = scanner.nextFloat();
          rz = scanner.nextFloat();
          step = SC;
        }
        else if (step==SC) {
          sx = scanner.nextFloat();
          sy = scanner.nextFloat();
          sz = scanner.nextFloat();
          step = TR;
        }
        else if (step==TR) {
          tx = scanner.nextFloat();
          ty = scanner.nextFloat();
          tz = scanner.nextFloat();

          Object3D obj_aux = new Object3D(points,lines);
          obj_aux.setStates(rx,ry,rz,sx,sy,sz,0,0,0);
          obj_aux.transform();

          Object3D obj = new Object3D(obj_aux.points,obj_aux.lines);
          obj.tx = tx; obj.ty = ty; obj.tz = tz;
          objects[curr_object++] = obj;

          step = NAME;
        }
      }//else (if(i==0),if(i==1),if(i==2))else
    }//for (int i = 0; i < strlines.length; i++)

    return objects;

  }//void importFigure (String filename)

  void selectNext () {
    this.selectedObject = (this.selectedObject+1)%this.numObjects;
  }

  void selectPrevious () {
    if (this.selectedObject-1 < 0)
      this.selectedObject = this.numObjects-1;
    else
      this.selectedObject = this.selectedObject-1;
  }
}//class Universe
