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

  Mode mode;

  Object3D observer_cavalier;
  Object3D observer_cabinet;
  Object3D observer_isometric;
  Object3D observer_perspective_1;
  Object3D observer_perspective_2;

  Universe (
    int minX, int maxX, int minY, int maxY, int minZ, int maxZ,
    int myWidth, int myHeight
  )
  {
    this.config = new Config(minX,maxX,minY,maxY,minZ,maxZ,myWidth,myHeight);

    this.fx = this.config.minX * 10.0f;
    this.fz = this.config.minZ * 10.0f;

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

    this.translateUniverse = false;
    this.rotateUniverse    = true;
    this.scaleUniverse     = false;

    this.mode = Mode.NORMAL;

    float[][] points_cavalier = {{fx,0,fz,1}};
    int[][] lines_cavalier = {{0,0}};
    this.observer_cavalier = new Object3D(points_cavalier,lines_cavalier);
  }

  void printObjects () {
    for (int i = 0; i < this.numObjects;i++) {
      this.objects[i].printObject3D();
    }
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
    this.grid.setColor(BLENDER_LIGHT_GRAY);
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

    this.grid.updateRotationUniverse(axis,dir,this.dr);
    this.axis.updateRotationUniverse(axis,dir,this.dr);
    this.observer_cavalier.updateRotationUniverse(axis,dir,this.dr);
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

    this.grid.updateScaleUniverse(axis,dir,this.ds);
    this.axis.updateScaleUniverse(axis,dir,this.ds);
    this.observer_cavalier.updateScaleUniverse(axis,dir,this.ds);
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

    this.grid.updateTranslationUniverse(axis,dir,this.dt);
    this.axis.updateTranslationUniverse(axis,dir,this.dt);
    this.observer_cavalier.updateTranslationUniverse(axis,dir,this.dt);
    for (int i = 0; i < this.numObjects; i++)
      this.objects[i].updateTranslationUniverse(axis,dir,this.dt);
  }

  void update (Projection proj) {
    this.axis.update(this.config,proj,this.fx,this.fz);
    this.grid.update(this.config,proj,this.fx,this.fz);

    this.observer_cavalier.update(this.config,proj,this.fx,this.fz);

    for (int i = 0; i < this.numObjects; i++)
      this.objects[i].update(this.config,proj,this.fx,this.fz);
  }

  void printFaces(Face[] faces) {
    for (int i = 0; i < faces.length; i++) {
      faces[i].printInfo();
    }
  }

  void printSeparator() {
    int n = 80;
    for (int i = 0; i < n; i++) print("-");
    print("\n");
  }

  void render () {
    // Here, axis must be rendered after grid...
    if (this.showGrid) this.grid.render(false,0,true);
    if (this.showAxis) this.axis.render(false,0,true);

    this.observer_cavalier.render(false,0,true);

    if (this.mode == Mode.NORMAL) {
      //-----------------------------------------------------------------------
      // NORMAL rendering
      //-----------------------------------------------------------------------
      int numFaces = getNumberOfFaces();
      Face[] faces = new Face[numFaces];
      int[] objIds = new int[numFaces];
      int currentFace = 0;
      for (int i = 0; i < this.numObjects; i++) {
        for (int j = 0; j < this.objects[i].faces.length; j++) {
          faces[currentFace] = this.objects[i].faces[j];
          objIds[currentFace] = i;
          currentFace++;
        }
      }

      float[][] norms = calculateNorms(faces);
      faces = getVisibleFaces(faces,norms);
      sortFacesByAvgZ(faces,objIds);

      for (int i = 0; i < faces.length; i++) {       // from smallest to biggest avgZ
      // for (int i = faces.length-1; i >= 0; i--) { // from biggest to smallest avgZ
        boolean selected = objIds[i] == this.selectedObject ? true : false;
        faces[i].render(this.objects[objIds[i]].projection,selected);
      }

      // Rendering just the first object's first face, for testing...
      // boolean selected = 0 == this.selectedObject ? true : false;
      // this.objects[0].faces[0].render(this.objects[0].projection,selected);
      //-----------------------------------------------------------------------
    }
    else if (this.mode == Mode.WIREFRAME) {
      //-----------------------------------------------------------------------
      // WIREFRAME rendering
      //-----------------------------------------------------------------------
      for (int i = 0; i < this.numObjects; i++) {
        boolean selected      = false;
        color   selectedColor = fill_color;
        if (i == this.selectedObject) {
          selected      = true;
          selectedColor = YELLOW;
        }
        this.objects[i].render(selected,selectedColor,true);
      }
      //-----------------------------------------------------------------------
    }
  }

  void reset () {
    this.axis.reset();
    this.grid.reset();

    for (int i = 0; i < this.numObjects; i++)
      this.objects[i].reset();
  }

  Object3D[] importFigure (String filename) {
    String[] strlines = read_file(filename);

    int NAME = 0, PLF_SIZES = 1, P = 2, L = 3, F = 4, ROT = 5, SC = 6, TR = 7;
    int step = NAME;

    Object3D objects[] = new Object3D[1];
    String name = "";
    double xmin = 0, xmax = 0, ymin = 0, ymax = 0;
    int num_objects = 0, sizep = 0, sizel = 0, sizef = 0;
    int curr_object = 0, count = 0;
    float points[][] = new float[1][4];
    int lines[][] = new int[1][1];
    Face faces[] = new Face[1];
    float rx=0, ry=0, rz=0;
    float sx=0, sy=0, sz=0;
    float tx=0, ty=0, tz=0;

    for (int i = 0; i < strlines.length; i++) {
      String[] pieces = strlines[i].split(" ");

      if (i==0) {
        // Read figure name
        // TODO
      }
      else if (i==1) {
        // Read universe config (Xmin Xmax Ymin Ymax)
        xmin = Float.parseFloat(pieces[0]);
        xmax = Float.parseFloat(pieces[1]);
        ymin = Float.parseFloat(pieces[2]);
        ymax = Float.parseFloat(pieces[3]);
        this.config.minX = (int) xmin;
        this.config.maxX = (int) xmax;
        this.config.minY = (int) ymin;
        this.config.maxY = (int) ymax;
      }
      else if (i==2) {
        // Read number of objects
        num_objects = Integer.parseInt(pieces[0]);
        objects = new Object3D[num_objects];
      }
      else {
        // Read an object from the figure
        if (step==NAME) {
          // Read name of object
          name = strlines[i];
          step = PLF_SIZES;
        }
        else if (step==PLF_SIZES) {
          // Read number of points, lines and faces
          sizep = Integer.parseInt(pieces[0]);
          sizel = Integer.parseInt(pieces[1]);
          sizef = Integer.parseInt(pieces[2]);
          points = new float[sizep][4];
          lines = new int[sizel][2];
          faces = new Face[sizef];
          step = P;
        }
        else if (step==P) {
          points[count][0] = Float.parseFloat(pieces[0]);
          points[count][1] = Float.parseFloat(pieces[1]);
          points[count][2] = Float.parseFloat(pieces[2]);
          points[count][3] = 1.0f;
          if (++count==sizep) {
            count = 0;
            step = L;
          }
        }
        else if (step==L) {
          lines[count][0] = Integer.parseInt(pieces[0])-1;
          lines[count][1] = Integer.parseInt(pieces[1])-1;
          if (++count==sizel) {
            count = 0;
            step = F;
          }
        }
        else if (step==F) {
          int num_vertices = Integer.parseInt(pieces[0]);
          faces[count] = new Face();
          for (int k=0; k<num_vertices; k++)
            faces[count].addPointIndex(Integer.parseInt(pieces[k+1])-1);
          faces[count].r = Float.parseFloat(pieces[num_vertices+1]);
          faces[count].g = Float.parseFloat(pieces[num_vertices+2]);
          faces[count].b = Float.parseFloat(pieces[num_vertices+3]);
          faces[count].setColor();
          if (++count==sizef) {
            count = 0;
            step = ROT;
          }
        }
        else if (step==ROT) {
          rx = Float.parseFloat(pieces[0]);
          ry = Float.parseFloat(pieces[1]);
          rz = Float.parseFloat(pieces[2]);
          step = SC;
        }
        else if (step==SC) {
          sx = Float.parseFloat(pieces[0]);
          sy = Float.parseFloat(pieces[1]);
          sz = Float.parseFloat(pieces[2]);
          step = TR;
        }
        else if (step==TR) {
          tx = Float.parseFloat(pieces[0]);
          ty = Float.parseFloat(pieces[1]);
          tz = Float.parseFloat(pieces[2]);

          Object3D obj_aux = new Object3D(points,lines);
          obj_aux.setStates(rx,ry,rz,sx,sy,sz,0,0,0);
          obj_aux.transform();

          Object3D obj = new Object3D(name,obj_aux.points,obj_aux.lines,faces);
          obj.tx = tx; obj.ty = ty; obj.tz = tz;
          objects[curr_object++] = obj;

          for (int j = 0; j < faces.length; j++) {
            faces[j].points = obj.points;
          }

          step = NAME;
        }
      }//else (if(i==0),if(i==1),if(i==2))
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

  int getNumberOfFaces () {
    int numFaces = 0;
    for (int i = 0; i < this.numObjects; i++) {
      numFaces += this.objects[i].faces.length;
    }
    return numFaces;
  }

  float[][] calculateNorms (Face[] faces) {
    float[][] norms = new float[faces.length][3];
    for (int i = 0; i < faces.length; i++) {
      Face f = faces[i];
      int v1 = f.pointIndexes[0];
      int v2 = f.pointIndexes[1];
      int v3 = f.pointIndexes[2];
      float p1x = f.points[v1][0], p1y = f.points[v1][1], p1z = f.points[v1][2];
      float p2x = f.points[v2][0], p2y = f.points[v2][1], p2z = f.points[v2][2];
      float p3x = f.points[v3][0], p3y = f.points[v3][1], p3z = f.points[v3][2];
      float nx =  (p3y-p2y)*(p1z-p2z)-(p1y-p2y)*(p3z-p2z);
      float ny =  (p3z-p2z)*(p1x-p2x)-(p1z-p2z)*(p3x-p2x);
      float nz =  (p3x-p2x)*(p1y-p2y)-(p1x-p2x)*(p3y-p2y);
      norms[i][0] = nx;
      norms[i][1] = ny;
      norms[i][2] = nz;
    }
    return norms;
  }

  Face[] getVisibleFaces (Face[] faces, float[][] norms) {
    Face[] tmpfaces = new Face[faces.length];
    int count = 0;
    for (int i = 0; i < faces.length; i++) {
      
    }
    return faces;
  }

  void sortFacesByAvgZ (Face[] faces, int[] objIds) {
    int i, j;
    Face keyface;
    int objId;
    int n = faces.length;
    for (i = 1; i < n; i++)
    {
      keyface = faces[i];
      objId = objIds[i];
      j = i-1;

      // Move elements of arr[0..i-1], that are
      // greater than key, to one position ahead
      // of their current position
      while (j >= 0 && faces[j].avgZ > keyface.avgZ)
      {
        faces[j+1] = faces[j];
        objIds[j+1] = objIds[j];
        j = j-1;
      }
      faces[j+1] = keyface;
      objIds[j+1] = objId;
    }
  }

}//class Universe
