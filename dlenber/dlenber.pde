Universe universe;
Projection projection;

void setup () {
  smooth();
  frameRate(60);
  fullScreen();

  init_gui();
  init_events();
  projection = Projection.CAVALIER;
  // projection = Projection.PERSPECTIVE_1;

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
