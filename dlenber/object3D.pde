class Object3D {

  private float[][] origPoints;
  float[][] projection;

  float[][] points;
  int[][] lines;
  Face[] faces;

  color[] lineColors;

  int n, numPoints;
  int m, numLines;
  color myColor;

  // Transformation matrices
  float[][] Rx, Ry, Rz;
  float[][] Sx, Sy, Sz;
  float[][] Tx, Ty, Tz;

  // Current state of each transformation
  float rx, ry, rz;
  float sx, sy, sz;
  float tx, ty, tz;

  // Current state of each transformation,
  // in respect to the universe
  float urx, ury, urz;
  float usx, usy, usz;
  float utx, uty, utz;

  // Steps for each transformation
  float dr, ds, dt;

  Object3D (float[][] points, int[][] lines) {
    this.points    = points;
    this.lines     = lines;
    this.numPoints = this.n = points.length;
    this.numLines  = this.m = lines.length;
    this.myColor   = fill_color;

    lineColors = new color[lines.length];
    for (int i = 0; i < lines.length; i++)
      lineColors[i] = fill_color;

    this.origPoints = make_copy(this.points);
    this.projection = make_copy(this.points);

    this.initStates();
    this.initSteps();

    this.updateMatrices();
  }

  Object3D (float[][] points, int[][] lines, Face[] faces) {
    this(points,lines);
    this.faces = faces;
  }

  void reset () {
    this.points     = make_copy(this.origPoints);
    this.projection = make_copy(this.origPoints);
  }

  void setColor (color thecolor) {
    for (int i = 0; i < this.lines.length; i++)
      this.setLineColor(thecolor,i);
  }

  void setLineColor (color thecolor, int index) {
    if (index < 0 || index >= lines.length)
      print("Error at Object3D::setLineColor.");
    else
      this.lineColors[index] = thecolor;
  }

  void initStates () {
    this.rx = 0.0f; this.ry = 0.0f; this.rz = 0.0f;
    this.sx = 0.0f; this.sy = 0.0f; this.sz = 0.0f;
    this.tx = 0.0f; this.ty = 0.0f; this.tz = 0.0f;

    this.urx = 0.0f; this.ury = 0.0f; this.urz = 0.0f;
    this.usx = 0.0f; this.usy = 0.0f; this.usz = 0.0f;
    this.utx = 0.0f; this.uty = 0.0f; this.utz = 0.0f;
  }

  void initSteps () {
    this.dr = 1.0f;
    this.ds = 0.05f;
    this.dt = 1.0f;
  }



  //----------------------------------------------------------------------------
  // Transformations in relations to the Object
  //----------------------------------------------------------------------------
  void setStates (
    float rx, float ry, float rz,
    float sx, float sy, float sz,
    float tx, float ty, float tz
  )
  {
    this.rx = rx; this.ry = ry; this.rz = rz;
    this.sx = sx; this.sy = sy; this.sz = sz;
    this.tx = tx; this.ty = ty; this.tz = tz;
  }

  void setRotationMatrices () {
    this.Rx = get_rot_mat_x(this.rx);
    this.Ry = get_rot_mat_y(this.ry);
    this.Rz = get_rot_mat_z(this.rz);
  }

  void setScaleMatrices () {
    this.Sx = get_sc_mat_x(this.sx);
    this.Sy = get_sc_mat_y(this.sy);
    this.Sz = get_sc_mat_z(this.sz);
  }

  void setTranslationMatrices () {
    this.Tx = get_tr_mat_x(this.tx);
    this.Ty = get_tr_mat_y(this.ty);
    this.Tz = get_tr_mat_z(this.tz);
  }

  void updateMatrices () {
    this.setRotationMatrices();
    this.setScaleMatrices();
    this.setTranslationMatrices();
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
  }

  void updateTranslation (Axis axis, Direction dir, float distance) {
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
  }
  //----------------------------------------------------------------------------



  //----------------------------------------------------------------------------
  // Transformations in relation to the Universe
  //----------------------------------------------------------------------------
  void setStatesUniverse (
    float urx, float ury, float urz,
    float usx, float usy, float usz,
    float utx, float uty, float utz
  )
  {
    this.urx = urx; this.ury = ury; this.urz = urz;
    this.usx = usx; this.usy = usy; this.usz = usz;
    this.utx = utx; this.uty = uty; this.utz = utz;
  }

  void setRotationMatricesUniverse () {
    this.Rx = get_rot_mat_x(this.urx);
    this.Ry = get_rot_mat_y(this.ury);
    this.Rz = get_rot_mat_z(this.urz);
  }

  void setScaleMatricesUniverse () {
    this.Sx = get_sc_mat_x(this.usx);
    this.Sy = get_sc_mat_y(this.usy);
    this.Sz = get_sc_mat_z(this.usz);
  }

  void setTranslationMatricesUniverse () {
    this.Tx = get_tr_mat_x(this.utx);
    this.Ty = get_tr_mat_y(this.uty);
    this.Tz = get_tr_mat_z(this.utz);
  }

  void updateMatricesUniverse () {
    this.setRotationMatricesUniverse();
    this.setScaleMatricesUniverse();
    this.setTranslationMatricesUniverse();
  }

  void updateRotationUniverse (Axis axis, Direction dir, float angle) {
    if (axis == Axis.X)
      this.urx = dir == Direction.POSITIVE ? this.urx + angle : this.urx - angle;
    if (axis == Axis.Y)
      this.ury = dir == Direction.POSITIVE ? this.ury + angle : this.ury - angle;
    if (axis == Axis.Z)
      this.urz = dir == Direction.POSITIVE ? this.urz + angle : this.urz - angle;
  }

  void rotateUniverse (Axis axis, Direction dir) {
    this.updateRotationUniverse(axis,dir,this.dr);
  }

  void updateScaleUniverse (Axis axis, Direction dir, float factor) {
    if (axis == Axis.X)
      this.usx = dir == Direction.POSITIVE ? this.usx + factor : this.usx - factor;
    if (axis == Axis.Y)
      this.usy = dir == Direction.POSITIVE ? this.usy + factor : this.usy - factor;
    if (axis == Axis.Z)
      this.usz = dir == Direction.POSITIVE ? this.usz + factor : this.usz - factor;
    if (axis == Axis.ALL_3) {
      if (dir == Direction.POSITIVE) {
        this.usx += factor;
        this.usy += factor;
        this.usz += factor;
      }
      if (dir == Direction.NEGATIVE) {
        float third_factor = factor/3.0f;
        this.usx -= third_factor;
        this.usy -= third_factor;
        this.usz -= third_factor;
      }
    }
  }

  void scaleUniverse (Axis axis, Direction dir) {
    this.updateScaleUniverse(axis,dir,this.ds);
  }

  void updateTranslationUniverse (Axis axis, Direction dir, float distance) {
    float newtx = this.utx, newty = this.uty, newtz = this.utz;

    if (axis == Axis.X) {
      if (dir == Direction.POSITIVE)      newtx = this.utx + distance;
      else if (dir == Direction.NEGATIVE) newtx = this.utx - distance;
    }
    if (axis == Axis.Y) {
      if (dir == Direction.POSITIVE)      newty = this.uty + distance;
      else if (dir == Direction.NEGATIVE) newty = this.uty - distance;
    }
    if (axis == Axis.Z) {
      if (dir == Direction.POSITIVE)      newtz = this.utz + distance;
      else if (dir == Direction.NEGATIVE) newtz = this.utz - distance;
    }

    this.utx = newtx;
    this.uty = newty;
    this.utz = newtz;
  }

  void translateUniverse (Axis axis, Direction dir) {
    this.updateTranslationUniverse(axis,dir,this.dt);
  }
  //----------------------------------------------------------------------------



  void normalize () {
    for (int i = 0; i < this.projection.length; i++) {
      for (int j = 0; j < this.projection[0].length; j++) {
        this.projection[i][j] /= this.projection[i][3];
      }
    }
  }

  void transform () {
    // Transformations in relation to the Object
    this.updateMatrices();
    this.points = dot(this.points,this.Rx);
    this.points = dot(this.points,this.Ry);
    this.points = dot(this.points,this.Rz);
    this.points = dot(this.points,this.Sx);
    this.points = dot(this.points,this.Sy);
    this.points = dot(this.points,this.Sz);
    this.points = dot(this.points,this.Tx);
    this.points = dot(this.points,this.Ty);
    this.points = dot(this.points,this.Tz);

    // Transformations in relations to the Universe
    this.updateMatricesUniverse();
    this.points = dot(this.points,this.Rx);
    this.points = dot(this.points,this.Ry);
    this.points = dot(this.points,this.Rz);
    this.points = dot(this.points,this.Sx);
    this.points = dot(this.points,this.Sy);
    this.points = dot(this.points,this.Sz);
    this.points = dot(this.points,this.Tx);
    this.points = dot(this.points,this.Ty);
    this.points = dot(this.points,this.Tz);
  }

  void project(Projection proj, float fx, float fz) {

    this.projection = make_copy(this.points);

    float[][] projmat = new float[4][4];

    if (proj == Projection.CAVALIER)
      projmat = get_cavalier_mat();
    if (proj == Projection.CABINET)
      projmat = get_cabinet_mat();
    if (proj == Projection.ISOMETRIC)
      projmat = get_isometric_mat();
    if (proj == Projection.PERSPECTIVE_1)
      projmat = get_perspective_1_mat(fz);
    if (proj == Projection.PERSPECTIVE_2)
      projmat = get_perspective_2_mat(fx,fz);

    this.projection = dot(this.projection,projmat);

    if (proj == Projection.PERSPECTIVE_1 || proj == Projection.PERSPECTIVE_2)
      this.normalize();
  }

  void convertToDisplay (Config config) {

    float[][] clipNeg = new float[this.projection.length][4];
    for (int i = 0; i < clipNeg.length; i++) {
      for (int j = 0; j < clipNeg[0].length; j++) {
        if (j == 0) clipNeg[i][j] = (float) config.minX;
        if (j == 1) clipNeg[i][j] = (float) config.minY;
        if (j == 2) clipNeg[i][j] = (float) config.minZ;
        if (j == 3) clipNeg[i][j] = 0.0f;
      }
    }

    this.projection = sub(this.projection,clipNeg);

    float[][] inv = {
      { 1.0f,  0.0f,  0.0f, 0.0f},
      { 0.0f, -1.0f,  0.0f, 0.0f},
      { 0.0f,  0.0f, -1.0f, 0.0f},
      { 0.0f,  0.0f,  0.0f, 1.0f}
    };

    this.projection = dot(this.projection,inv);

    float[][] convY = new float[this.projection.length][4];
    for (int i = 0; i < convY.length; i++) {
      for (int j = 0; j < convY[0].length; j++) {
        if (j == 0) convY[i][j] = 0.0f;
        if (j == 1) convY[i][j] = config.H;
        if (j == 2) convY[i][j] = 0.0f;
        if (j == 3) convY[i][j] = 0.0f;
      }
    }

    this.projection = add(this.projection,convY);

    float[][] convZ = new float[this.projection.length][4];
    for (int i = 0; i < convZ.length; i++) {
      for (int j = 0; j < convZ[0].length; j++) {
        if (j == 0) convZ[i][j] = 0.0f;
        if (j == 1) convZ[i][j] = 0.0f;
        if (j == 2) convZ[i][j] = config.D;
        if (j == 3) convZ[i][j] = 0.0f;
      }
    }

    this.projection = add(this.projection,convZ);

    for (int i = 0; i < this.projection.length; i++) {
      this.projection[i][0] = this.projection[i][0]*config.mult + config.dx/2.0;
      this.projection[i][1] = this.projection[i][1]*config.mult + config.dy/2.0;
      this.projection[i][2] = this.projection[i][2]*config.mult;
    }
  }

  void render () {
    for (int i = 0; i < this.lines.length; i++) {
      float x0 = this.projection[this.lines[i][0]][0];
      float y0 = this.projection[this.lines[i][0]][1];
      float x1 = this.projection[this.lines[i][1]][0];
      float y1 = this.projection[this.lines[i][1]][1];

      lin_bres(
        (int) x0,
        (int) y0,
        (int) x1,
        (int) y1,
        this.lineColors[i]
      );
    }
  }

  void renderColor (color thecolor) {
    for (int i = 0; i < this.lines.length; i++) {
      float x0 = this.projection[this.lines[i][0]][0];
      float y0 = this.projection[this.lines[i][0]][1];
      float x1 = this.projection[this.lines[i][1]][0];
      float y1 = this.projection[this.lines[i][1]][1];

      lin_bres(
        (int) x0,
        (int) y0,
        (int) x1,
        (int) y1,
        thecolor
      );
    }
  }

  void update (Config config, Projection proj, float fx, float fz) {
    transform();
    project(proj,fx,fz);
    convertToDisplay(config);
  }
}
