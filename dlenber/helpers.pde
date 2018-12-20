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

float[][] get_rot_mat (float anglex, float angley, float anglez) {
  int ax = (int) anglex;
  int ay = (int) angley;
  int az = (int) anglez;
  float[][] rotmat = dot(get_rot_mat_x(ax),get_rot_mat_y(ay));
  rotmat = dot(rotmat,get_rot_mat_z(az));
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

float[][] get_sc_mat (float factorx, float factory, float factorz) {
  float f1 = factorx;
  float f2 = factory;
  float f3 = factorz;
  float[][] scmat = {
    {1.0f+f1,  0.0f,    0.0f,    0.0f},
    {0.0f,     1.0f+f2, 0.0f,    0.0f},
    {0.0f,     0.0f,    1.0f+f3, 0.0f},
    {0.0f,     0.0f,    0.0f,    1.0f}
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

float[][] get_tr_mat (float dx, float dy, float dz) {
  float[][] trmat = {
    {1.0f,  0.0f, 0.0f, 0.0f},
    {0.0f,  1.0f, 0.0f, 0.0f},
    {0.0f,  0.0f, 1.0f, 0.0f},
    {  dx,    dy,   dz, 1.0f}
  };
  return trmat;
}

float[][] get_cavalier_mat () {
  float[][] CAVALIER = {
    { 1.0f,             0.0f,             0.0f, 0.0f},
    { 0.0f,             1.0f,             0.0f, 0.0f},
    {-(sqrt(2)/2)*0.5,  -(sqrt(2)/2)*0.5, 1.0f, 0.0f},
    { 0.0f,             0.0f,             0.0f, 1.0f}
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
    {sqrt(2)/2.0f, -1.0f/sqrt(6), 1.0f, 0.0f},
    {0.0f,          0.0f,         0.0f, 1.0f}
  };
  return ISOMETRIC;
}

float[][] get_perspective_1_mat (float fz) {
  float[][] PERSPECTIVE_1 = {
    {1.0f, 0.0f,  0.0f,  0.0f},
    {0.0f, 1.0f,  0.0f,  0.0f},
    {0.0f, 0.0f,  1.0f, -1.0f/fz},
    {0.0f, 0.0f,  0.0f,  1.0f}
  };
  return PERSPECTIVE_1;
}

float[][] get_perspective_2_mat (float fx, float fz) {
  float[][] PERSPECTIVE_2 = {
    {1.0f, 0.0f, 0.0f, -1.0f/fx},
    {0.0f, 1.0f, 0.0f,  0.0f},
    {0.0f, 0.0f, 1.0f, -1.0f/fz},
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

float magnitude_vector (float[] vector) {
  float mag = 0.0f;
  for (int i = 0; i < vector.length; i++) {
    mag += vector[i]*vector[i];
  }
  mag = sqrt(mag);

  return mag;
}

void normalize_vector (float[] vector) {
  float mag = magnitude_vector(vector);

  if (mag > 0) {
    for (int i = 0; i < vector.length; i++) {
      vector[i] = vector[i]/mag;
    }
  }
}

float dot_vectors (float[] u, float[] v) {
  float dot = 0.0f;
  for (int i = 0; i < u.length; i++) {
    dot += u[i] * v[i];
  }

  return dot;
}

float cos_vectors (float[] u, float[] v) {
  float magu = magnitude_vector(u);
  float magv = magnitude_vector(v);
  return dot_vectors(u,v) / (magu*magv);
}

float dist_vectors (float[] u, float[] v) {
  float sum = 0.0f;
  for (int i = 0; i < u.length; i++) {
    sum += pow((u[i]-v[i]),2);
  }
  return sqrt(sum);
}

void print_vector (float[] vector) {
  String s = "[";
  for (int i = 0; i < vector.length-1; i++)
    s += vector[i] + ",";
  s += vector[vector.length-1] + "]";
  print(s+"\n");
}

float[] rgbToHsl (int R, int G, int B) {
  float r = (float)R/255.0;
  float g = (float)G/255.0;
  float b = (float)B/255.0;

  float max = max(r, g, b), min = min(r, g, b);
  float h, s, l = ((float)(max+min))/2.0;

  if (max == min) {
    h = s = 0.0f; // achromatic
  } else {
    float d = (float)max - (float)min;
    s = l > 0.5 ? d / (2.0f-max-min) : d/(float)(max + min);

    if      (max == r) h = (g - b) / d + (g < b ? 6.0f : 0.0f);
    else if (max == g) h = (b - r) / d + 2.0f;
    else               h = (r - g) / d + 4.0f;

    h /= 6.0f;
  }

  float[] hsl = {h,s,l};

  return hsl;
}

float hue2rgb (float p, float q, float t) {
  if (t < 0.0f) t += 1.0f;
  if (t > 1.0f) t -= 1.0f;
  if (t < 1.0f/6.0f) return p + (q - p) * 6.0f * t;
  if (t < 1.0f/2.0f) return q;
  if (t < 2.0f/3.0f) return p + (q - p) * (2.0f/3.0f - t) * 6.0f;
  return p;
}

int[] hslToRgb (float h, float s, float l) {
  float r, g, b;

  if (s == 0) {
    r = g = b = l; // achromatic
  } else {
    float q = l < 0.5 ? l * (1.0f + s) : l + s - l * s;
    float p = 2.0f * l - q;

    r = hue2rgb(p, q, h + (1.0f/3.0f));
    g = hue2rgb(p, q, h);
    b = hue2rgb(p, q, h - (1.0f/3.0f));
  }

  int[] rgb = {(int)r*255, (int)g*255, (int)b*255};
  return rgb;
}

void print_rgb (int[] rgb) {
  print("rbg: ("+rgb[0]+","+rgb[1]+","+rgb[2]+")\n");
}

void print_hsl (float[] hsl) {
  print("hsl: ("+hsl[0]+","+hsl[1]+","+hsl[2]+")\n");
}

void print_separator() {
  print("===================================================================\n");
}

float[] shade_color (int r, int g, int b, float illumination) {
  float[] rgb = new float[3];
  float l = illumination+0.1;
  // float l = illumination > 0.5 ? 1+(illumination-0.5) : illumination;
  rgb[0] = ((float)r)*(l);
  rgb[1] = ((float)g)*(l);
  rgb[2] = ((float)b)*(l);

  return rgb;
}

int[] shade_color_2 (int r, int g, int b, float illumination) {
  float alpha = 1.0;
  float l = 255 * illumination;
  float aR = l;
  float aG = l;
  float aB = l;
  float newR = r + (aR - r) * alpha;
  float newG = g + (aG - g) * alpha;
  float newB = b + (aB - b) * alpha;

  int[] rgb = {(int)newR, (int)newG, (int)newB};
  int rsum = (int)(rgb[0]/2.0) + r;
  int gsum = (int)(rgb[1]/2.0) + g;
  int bsum = (int)(rgb[2]/2.0) + b;
  rgb[0] = rsum > 255 ? 255 : rsum;
  rgb[1] = gsum > 255 ? 255 : gsum;
  rgb[2] = bsum > 255 ? 255 : bsum;

  return rgb;
}
