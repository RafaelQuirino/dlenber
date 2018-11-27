Universe universe;
Projection projection;
int FPS = 24;

void setup () {
  smooth();
  frameRate(FPS);
  fullScreen();

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

  universe.update(projection);
  universe.render();
  universe.reset();

  render_gui();
  run_events(universe);
}
