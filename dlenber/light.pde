class Vector {
  double x;
  double y;
  double z;
  
  Vector(double _x, double _y, double _y) {
    
  }
}

class Light {
  double ka;
  double kd;
  double ks;
}

double dot(Vector L, Vector N) {
  return L.x * N.x + L.y * N.y + L.z * N.z;
}

double length(Vector L) {
  
}

Vector cross(Vector L, Vector N) {
  return new Vector(L.y * N.z - L.z * N.y, L.z * N.x - L.x * N.z, L.x * N.y - L.y * N.x);
}

Vector normalize() {
  
}

color calc_ambient(double ka, color current) {
  double r = Math.round(red(current) * ka);
  double g = Math.round(green(current) * ka);
  double b = Math.round(blue(current) * ka);
}

color calc_diffuse(double kd, color current, Vector L, Vector N) {
  double r = red(current) * kd * dot(L, N);
  double g = green(current) * kd * dot(L, N);
  double b = blue(current) * kd * dot(L, N);
}

color calc_specular(int n, double ks, color current, Vector L, Vector N) {
  double r = red(current) * ks * pow(dot(L, N), n);
  double g = green(current) * ks * pow(dot(L, N), n);
  double b = blue(current) * ks * pow(dot(L, N), n);
}

color gouraud(double ka, double kd, double ks, Vector L, Vector N, color current) {
  
}
