// Only abstraction allowed
void putpixel (int x, int y, color thecolor) {
    stroke(thecolor);
    fill(thecolor);

    // rect(x,y,1,1);
    point(x,y);

    stroke(fill_color);
    fill(fill_color);
}

float calc_sin (int angle) {
  int isneg = 0;
  int ang = angle;
  if (ang < 0) {
    ang = (-1*ang) % 360;
    isneg = 1;
  } else ang %= 360;
  float a = (float) ang;
  float result = sin((TWO_PI*a)/360.0);
  if (isneg == 1) result *= -1;
  return result;
}

float calc_cos (int angle) {
  int ang = angle >= 0 ? angle : -angle;
  ang %= 360;
  float a = (float) ang;
  return cos((TWO_PI*a)/360.0);
}

float[] get_sin_positive (int numAngles) {
  float[] sines = new float[numAngles];
  for (int i = 0; i < numAngles; i++) {
    sines[i] = calc_sin(i);
  }
  return sines;
}

float[] get_sin_negative (int numAngles) {
  float[] sines = new float[numAngles];
  for (int i = 0; i < numAngles; i++) {
    sines[i] = calc_sin(-i);
  }
  return sines;
}

float[] get_cos_positive (int numAngles) {
  float[] cosines = new float[numAngles];
  for (int i = 0; i < numAngles; i++) {
    cosines[i] = calc_cos(i);
  }
  return cosines;
}

float[] get_cos_negative (int numAngles) {
  float[] cosines = new float[numAngles];
  for (int i = 0; i < numAngles; i++) {
    cosines[i] = calc_cos(-i);
  }
  return cosines;
}

float get_sin (int angle) {
  if (angle > 0)
    return sincos.sin_positive[angle%sincos.numAngles];
  else
    return sincos.sin_negative[(-1*angle)%sincos.numAngles];
}

float get_cos (int angle) {
  if (angle > 0)
    return sincos.cos_positive[angle%sincos.numAngles];
  else
    return sincos.cos_negative[(-1*angle)%sincos.numAngles];
}

float[][] get_rot_mat_x (float angle) {
  int a = (int) angle;
  float[][] rotmat = {
    {1.0f,  0.0f,       0.0f,       0.0f},
    {0.0f,  get_cos(a), get_sin(a), 0.0f},
    {0.0f, -get_sin(a), get_cos(a), 0.0f},
    {0.0f,  0.0f,       0.0f,       1.0f}
  };
  return rotmat;
}

float[][] get_rot_mat_y (float angle) {
  int a = (int) angle;
  float[][] rotmat = {
    {get_cos(a), 0.0f, -get_sin(a), 0.0f},
    {0.0f,       1.0f,  0.0f,       0.0f},
    {get_sin(a), 0.0f,  get_cos(a), 0.0f},
    {0.0f,       0.0f,  0.0f,       1.0f}
  };
  return rotmat;
}

float[][] get_rot_mat_z (float angle) {
  int a = (int) angle;
  float[][] rotmat = {
    { get_cos(a), get_sin(a), 0.0f, 0.0f},
    {-get_sin(a), get_cos(a), 0.0f, 0.0f},
    {0.0f,        0.0f,       1.0f, 0.0f},
    {0.0f,        0.0f,       0.0f, 1.0f}
  };
  return rotmat;
}

float[][] get_sc_mat_x (float factor) {
  float f = factor;
  float[][] scmat = {
    {1.0f+f,  0.0f, 0.0f, 0.0f},
    {0.0f,    1.0f, 0.0f, 0.0f},
    {0.0f,    0.0f, 1.0f, 0.0f},
    {0.0f,    0.0f, 0.0f, 1.0f}
  };
  return scmat;
}

float[][] get_sc_mat_y (float factor) {
  float f = factor;
  float[][] scmat = {
    {1.0f,  0.0f,   0.0f, 0.0f},
    {0.0f,  1.0f+f, 0.0f, 0.0f},
    {0.0f,  0.0f,   1.0f, 0.0f},
    {0.0f,  0.0f,   0.0f, 1.0f}
  };
  return scmat;
}

float[][] get_sc_mat_z (float factor) {
  float f = factor;
  float[][] scmat = {
    {1.0f,  0.0f, 0.0f,   0.0f},
    {0.0f,  1.0f, 0.0f,   0.0f},
    {0.0f,  0.0f, 1.0f+f, 0.0f},
    {0.0f,  0.0f, 0.0f,   1.0f}
  };
  return scmat;
}

float[][] get_tr_mat_x (float distance) {
  float d = distance;
  float[][] trmat = {
    {1.0f,  0.0f, 0.0f, 0.0f},
    {0.0f,  1.0f, 0.0f, 0.0f},
    {0.0f,  0.0f, 1.0f, 0.0f},
    {   d,  0.0f, 0.0f, 1.0f}
  };
  return trmat;
}

float[][] get_tr_mat_y (float distance) {
  float d = distance;
  float[][] trmat = {
    {1.0f,  0.0f, 0.0f, 0.0f},
    {0.0f,  1.0f, 0.0f, 0.0f},
    {0.0f,  0.0f, 1.0f, 0.0f},
    {0.0f,     d, 0.0f, 1.0f}
  };
  return trmat;
}

float[][] get_tr_mat_z (float distance) {
  float d = distance;
  float[][] trmat = {
    {1.0f,  0.0f, 0.0f, 0.0f},
    {0.0f,  1.0f, 0.0f, 0.0f},
    {0.0f,  0.0f, 1.0f, 0.0f},
    {0.0f,  0.0f,    d, 1.0f}
  };
  return trmat;
}

float[][] get_cavalier_mat () {
  float[][] CAVALIER = {
    { 1.0f,             0.0f,            0.0f, 0.0f},
    { 0.0f,             1.0f,            0.0f, 0.0f},
    {-(sqrt(2)/2)*0.5,  -(sqrt(2)/2)*0.5, 0.0f, 0.0f},
    { 0.0f,             0.0f,            0.0f, 1.0f}
  };
  return CAVALIER;
}

float[][] get_cabinet_mat () {
  float[][] CABINET = {
    { 1.0f,             0.0f,            0.0f, 0.0f},
    { 0.0f,             1.0f,            0.0f, 0.0f},
    {-(sqrt(2)/4)*0.5, -(sqrt(2)/4)*0.5, 1.0f, 0.0f},
    { 0.0f,             0.0f,            0.0f, 1.0f}
  };
  return CABINET;
}

float[][] get_isometric_mat () {
  float[][] ISOMETRIC = {
    {sqrt(2)/2.0f,  1.0f/sqrt(6), 0.0f, 0.0f},
    {0.0f,          2.0f/sqrt(6), 0.0f, 0.0f},
    {sqrt(2)/2.0f, -1.0f/sqrt(6), 0.0f, 0.0f},
    {0.0f,          0.0f,         0.0f, 1.0f}
  };
  return ISOMETRIC;
}

float[][] get_perspective_1_mat (float fz) {
  float[][] PERSPECTIVE_1 = {
    {1.0f, 0.0f, 0.0f,  0.0f},
    {0.0f, 1.0f, 0.0f,  0.0f},
    {0.0f, 0.0f, 0.0f, -1.0f/fz},
    {0.0f, 0.0f, 0.0f,  1.0f}
  };
  return PERSPECTIVE_1;
}

float[][] get_perspective_2_mat (float fx, float fz) {
  float[][] PERSPECTIVE_2 = {
    {1.0f, 0.0f, 0.0f, -1.0f/fx},
    {0.0f, 1.0f, 0.0f,  0.0f},
    {0.0f, 0.0f, 0.0f, -1.0f/fz},
    {0.0f, 0.0f, 0.0f,  1.0f}
  };
  return PERSPECTIVE_2;
}

float[][] make_copy (float[][] points) {
    int n = points.length;
    float[][] copy = new float[n][points[0].length];
    for (int i = 0; i < points.length; i++) {
        for (int j = 0; j < points[0].length; j++) {
            copy[i][j] = points[i][j];
        }
    }
    return copy;
}

void print_mat (float[][] mat) {
  for (int i = 0; i < mat.length; i++) {
    for (int j = 0; j < mat[0].length; j++) {
      print(mat[i][j] + "\t\t");
    }
    print("\n");
  }
  print("\n");
}

void print_mat (int[][] mat) {
  for (int i = 0; i < mat.length; i++) {
    for (int j = 0; j < mat[0].length; j++) {
      print(mat[i][j] + "\t\t");
    }
    print("\n");
  }
  print("\n");
}

void print_font (String str, PFont font, int x, int y, color c) {
  fill(c);
  textAlign(TOP);
  textFont(font);
  text(str, x, y);
}

Projection get_next_proj (Projection proj) {
  Projection p = Projection.CAVALIER;
  if (proj == Projection.CAVALIER) {
    p = Projection.CABINET;
  } else if (proj == Projection.CABINET) {
    p = Projection.ISOMETRIC;
  } else if (proj == Projection.ISOMETRIC) {
    p = Projection.PERSPECTIVE_1;
  } else if (proj == Projection.PERSPECTIVE_1) {
    p = Projection.PERSPECTIVE_2;
  } else if (proj == Projection.PERSPECTIVE_2) {
    p = Projection.CAVALIER;
  }
  return p;
}

String[] read_file (String filename) {
  String[] lines = loadStrings(filename);
  return lines;
}
