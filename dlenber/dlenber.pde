Universe universe;
Projection projection;
SinesAndCosines sincos;
int FPS = 30;

void setup () {
  smooth();
  fullScreen();
  // frameRate(FPS);

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

  universe.mode = Mode.WIREFRAME;

  Object3D objects[] = universe.importFigure("figure.dat");
  for (int i = 0; i < objects.length; i++)
    universe.addObject(objects[i]);
  universe.printObjects();
}

int flag = 0;
int rate = 3;
int counter = 0;
int limit   = FPS;
float fps      = FPS;
float last_fps = FPS;

void draw () {
  long t0 = System.nanoTime();

  universe.update(projection);

  // Trying to reduce computations ------------------------
  // Render 1 of each 2 frames...
  if (flag == 0) {
    background(back_color);
    universe.render();
    render_gui(last_fps);
  }
  //-------------------------------------------------------

  universe.reset();
  run_events(universe);

  long t1 = System.nanoTime();
  float time = (float)((t1-t0)/1000000.0);
  // print("time: "+time+" ms\n");

  if (flag == 0) last_fps = fps;
  if (counter == 0) fps = 1000.0/time;
  flag = (flag+1)%rate;
  counter = (counter+1)%limit;
}
