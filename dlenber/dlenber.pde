Universe universe;
Projection projection;

void setup () {
  smooth();
  frameRate(60);
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
  universe.addObject(universe.getCube());
}

void draw () {
  background(back_color);

  universe.update(projection);
  universe.render();
  universe.reset();

  render_gui();
  run_events(universe);
}
