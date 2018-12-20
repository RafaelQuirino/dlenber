class Light3D {
  float Ii;      // Light ray intensity
  color mycolor; // Light color
  int R, G, B;   // Light RGB color
  Object3D lamp; // The lamp location

  Light3D () {

  }
}

Light3D getStandardLight (float x, float y, float z) {
  Light3D light = new Light3D();
  light.Ii = 2.0f;
  light.R = 255;
  light.G = 255;
  light.B = 255;

  float[][] points = {{x,y,z,1}};
  int[][] lines = {{0,0}};
  light.lamp = new Object3D(points,lines);

  return light;
}
