class Light {
  double ka;
  double kd;
  double ks;
}

color calc_ambient(double ka, color current) {
  double r = Math.round(red(current) * ka);
  double g = Math.round(green(current) * ka);
  double b = Math.round(blue(current) * ka);
}

color calc_diffuse(double kd, color current, Vector L, Vector N) {
  
}

color calc_specular(double ks) {
  
}

color gouraud(double ka, double kd, double ks, Vector L, Vector N, color current) {
  
}