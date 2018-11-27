Universe universe;
Projection projection;
SinesAndCosines sincos;
int FPS = 24;

void setup () {
  smooth();
  frameRate(FPS);
  fullScreen();

  init_gui();
  init_events();
  projection = Projection.CAVALIER;
  sincos = new SinesAndCosines();

  universe = new Universe (
    -100,  100,
    -100,  100,
    -100,  100,
    width, height
  );

  Object3D objects[] = universe.importFigure("figure.dat");
  for (int i = 0; i < objects.length; i++)
    universe.addObject(objects[i]);
  universe.printObjects();
}

int flag = 0;
int rate = 2;

void draw () {

  long t0 = System.nanoTime();
  universe.update(projection);
  // Trying to reduce computations ------------------------
  if (flag != 0) {
    background(back_color);
    universe.render();
    render_gui();
  }
  flag = (flag+1)%rate;
  //-------------------------------------------------------
  universe.reset();
  long t1 = System.nanoTime();
  print("time: "+((double)(t1-t0)/1000000)+" ms\n");

  run_events(universe);
}
