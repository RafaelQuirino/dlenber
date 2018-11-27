Universe universe;
Projection projection;
SinesAndCosines sincos;
int FPS = 24;

boolean thereWasEvent = false;

void setup () {
  smooth();
  frameRate(FPS);
  fullScreen();

  sincos = new SinesAndCosines();

  init_gui();
  init_events();
  projection = Projection.CAVALIER;

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

void draw () {
  background(back_color);

  long t0 = System.nanoTime();
  universe.update(projection,thereWasEvent);
  universe.render();
  universe.reset();
  long t1 = System.nanoTime();
  print("time: "+((double)(t1-t0)/1000000)+" ms\n");

  render_gui();
  thereWasEvent = run_events(universe);
}
