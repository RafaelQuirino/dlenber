class Material {
  float Ka;    // Ambient reflection rate
  float Kd;    // Diffuse reflection rate
  float Ks;    // Specular reflection rate
  float alpha; // Brightness rate

  Material () {

  }
}

Material getStandardDiffuseMaterial () {
  Material diffuse = new Material();
  diffuse.Ka    = 0.2;
  diffuse.Kd    = 0.6;
  diffuse.Ks    = 0.5;
  diffuse.alpha = 20;

  return diffuse;
}
