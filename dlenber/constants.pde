color BLACK     = color(0,0,0);
color WHITE     = color(255,255,255);
color DARK_GRAY = color(50,50,50);
color RED       = color(255,0,0);
color GREEN     = color(0,255,0);
color BLUE      = color(0,0,255);
color YELLOW    = color(255,255,0);

// Custom colors
color BLENDER_LIGHT_GRAY  = color(74,74,74);
color BLENDER_DARK_GRAY   = color(57,57,57);
// color BLENDER_OBJECT_GRAY = color(?,?,?);

enum Axis {
  X,
  Y,
  Z,
  ALL_3;
}

enum Projection {
  CAVALIER,
  CABINET,
  ISOMETRIC,
  PERSPECTIVE_1,
  PERSPECTIVE_2;
}

enum Direction {
  POSITIVE,
  NEGATIVE;
}

enum Mode {
  NORMAL,
  WIREFRAME;
}

class SinesAndCosines {
  float[] sin_positive;
  float[] sin_negative;
  float[] cos_positive;
  float[] cos_negative;
  int numAngles;

  SinesAndCosines () {
    this.numAngles = 360;
    this.sin_positive = get_sin_positive(this.numAngles);
    this.sin_negative = get_sin_negative(this.numAngles);
    this.cos_positive = get_cos_positive(this.numAngles);
    this.cos_negative = get_cos_negative(this.numAngles);
  }
}
