boolean[] keys;

enum Keys {
  q(0), e(1), a(2), d(3), w(4), s(5),
  r(6), y(7), f(8), h(9), t(10), g(11),
  u(12), o(13), j(14), l(15), i(16), k(17),
  one(18), two(19), three(20), four(21), five(22),
  six(23), seven(24), eight(25), nine(26), zero(27),
  p(28), plus(29), minus(30),
  // Transformations in relations to the Universe
  z(31), x(32), c(33), v(34), b(35), n(36);

  private final int value;
  Keys(final int newValue) {
    value = newValue;
  }
  public int id() {
    return value;
  }
}

boolean[] init_keys () {
  boolean[] keys = new boolean[Keys.values().length];
  for (int i = 0; i < keys.length; i++)
    keys[i] = false;
  return keys;
}

void init_events () {
  keys = init_keys();
}

void run_events (Universe universe) {

  Object3D obj = universe.objects[0];
  Config config = universe.config;

  if (keys[Keys.q.id()]) obj.translate(Axis.Z,Direction.POSITIVE);
  if (keys[Keys.e.id()]) obj.translate(Axis.Z,Direction.NEGATIVE);
  if (keys[Keys.d.id()]) obj.translate(Axis.X,Direction.POSITIVE);
  if (keys[Keys.a.id()]) obj.translate(Axis.X,Direction.NEGATIVE);
  if (keys[Keys.w.id()]) obj.translate(Axis.Y,Direction.POSITIVE);
  if (keys[Keys.s.id()]) obj.translate(Axis.Y,Direction.NEGATIVE);

  if (keys[Keys.r.id()]) obj.rotate(Axis.Z,Direction.POSITIVE);
  if (keys[Keys.y.id()]) obj.rotate(Axis.Z,Direction.NEGATIVE);
  if (keys[Keys.f.id()]) obj.rotate(Axis.X,Direction.POSITIVE);
  if (keys[Keys.h.id()]) obj.rotate(Axis.X,Direction.NEGATIVE);
  if (keys[Keys.t.id()]) obj.rotate(Axis.Y,Direction.POSITIVE);
  if (keys[Keys.g.id()]) obj.rotate(Axis.Y,Direction.NEGATIVE);

  if (keys[Keys.u.id()]) obj.scale(Axis.Z,Direction.POSITIVE);
  if (keys[Keys.o.id()]) obj.scale(Axis.Z,Direction.NEGATIVE);
  if (keys[Keys.j.id()]) obj.scale(Axis.X,Direction.POSITIVE);
  if (keys[Keys.l.id()]) obj.scale(Axis.X,Direction.NEGATIVE);
  if (keys[Keys.i.id()]) obj.scale(Axis.Y,Direction.POSITIVE);
  if (keys[Keys.k.id()]) obj.scale(Axis.Y,Direction.NEGATIVE);

  if (keys[Keys.one.id()])   projection = Projection.CAVALIER;
  if (keys[Keys.two.id()])   projection = Projection.CABINET;
  if (keys[Keys.three.id()]) projection = Projection.ISOMETRIC;
  if (keys[Keys.four.id()])  projection = Projection.PERSPECTIVE_1;
  if (keys[Keys.five.id()])  projection = Projection.PERSPECTIVE_2;

  if (keys[Keys.zero.id()]) {
    universe.initStates();
    obj.initStates();
  }

  if (keys[Keys.plus.id()])  obj.scale(Axis.ALL_3, Direction.POSITIVE);
  if (keys[Keys.minus.id()]) obj.scale(Axis.ALL_3, Direction.NEGATIVE);

  // Universe Transformations
  // if (keys[Keys.z.id()]) universe.translate(Axis.Z,Direction.POSITIVE);
  // if (keys[Keys.x.id()]) universe.translate(Axis.Z,Direction.NEGATIVE);
  // if (keys[Keys.c.id()]) universe.rotate(Axis.Z,Direction.POSITIVE);
  // if (keys[Keys.v.id()]) universe.rotate(Axis.Z,Direction.NEGATIVE);
  // if (keys[Keys.b.id()]) universe.scale(Axis.Z,Direction.POSITIVE);
  // if (keys[Keys.n.id()]) universe.scale(Axis.Z,Direction.NEGATIVE);

  // Universe Transformations in Axis Z ----------------------------------------
  if (keys[Keys.z.id()]) {
    if (universe.translateUniverse)
      universe.translate(Axis.Z,Direction.POSITIVE);
    if (universe.rotateUniverse)
      universe.rotate(Axis.Z,Direction.POSITIVE);
    if (universe.scaleUniverse)
      universe.scale(Axis.Z,Direction.POSITIVE);
  }
  if (keys[Keys.x.id()]) {
    if (universe.translateUniverse)
      universe.translate(Axis.Z,Direction.NEGATIVE);
    if (universe.rotateUniverse)
      universe.rotate(Axis.Z,Direction.NEGATIVE);
    if (universe.scaleUniverse)
      universe.scale(Axis.Z,Direction.NEGATIVE);
  }
  //----------------------------------------------------------------------------

  // Universe Transformations in Axis X ----------------------------------------
  if (keys[Keys.c.id()]) {
    if (universe.translateUniverse)
      universe.translate(Axis.X,Direction.POSITIVE);
    if (universe.rotateUniverse)
      universe.rotate(Axis.X,Direction.POSITIVE);
    if (universe.scaleUniverse)
      universe.scale(Axis.X,Direction.POSITIVE);
  }
  if (keys[Keys.v.id()]) {
    if (universe.translateUniverse)
      universe.translate(Axis.X,Direction.NEGATIVE);
    if (universe.rotateUniverse)
      universe.rotate(Axis.X,Direction.NEGATIVE);
    if (universe.scaleUniverse)
      universe.scale(Axis.X,Direction.NEGATIVE);
  }
  //----------------------------------------------------------------------------

  // Universe Transformations in Axis Y ----------------------------------------
  if (keys[Keys.b.id()]) {
    if (universe.translateUniverse)
      universe.translate(Axis.Y,Direction.POSITIVE);
    if (universe.rotateUniverse)
      universe.rotate(Axis.Y,Direction.POSITIVE);
    if (universe.scaleUniverse)
      universe.scale(Axis.Y,Direction.POSITIVE);
  }
  if (keys[Keys.n.id()]) {
    if (universe.translateUniverse)
      universe.translate(Axis.Y,Direction.NEGATIVE);
    if (universe.rotateUniverse)
      universe.rotate(Axis.Y,Direction.NEGATIVE);
    if (universe.scaleUniverse)
      universe.scale(Axis.Y,Direction.NEGATIVE);
  }
  //----------------------------------------------------------------------------
}

void key_down (boolean[] keys, char key) {
  if (key == 'q' || key == 'Q') keys[Keys.q.id()] = true;
  if (key == 'e' || key == 'E') keys[Keys.e.id()] = true;
  if (key == 'd' || key == 'D') keys[Keys.d.id()] = true;
  if (key == 'a' || key == 'A') keys[Keys.a.id()] = true;
  if (key == 'w' || key == 'W') keys[Keys.w.id()] = true;
  if (key == 's' || key == 'S') keys[Keys.s.id()] = true;

  if (key == 'r' || key == 'R') keys[Keys.r.id()] = true;
  if (key == 'y' || key == 'Y') keys[Keys.y.id()] = true;
  if (key == 'f' || key == 'F') keys[Keys.f.id()] = true;
  if (key == 'h' || key == 'H') keys[Keys.h.id()] = true;
  if (key == 't' || key == 'T') keys[Keys.t.id()] = true;
  if (key == 'g' || key == 'G') keys[Keys.g.id()] = true;

  if (key == 'u' || key == 'U') keys[Keys.u.id()] = true;
  if (key == 'o' || key == 'O') keys[Keys.o.id()] = true;
  if (key == 'j' || key == 'J') keys[Keys.j.id()] = true;
  if (key == 'l' || key == 'L') keys[Keys.l.id()] = true;
  if (key == 'i' || key == 'I') keys[Keys.i.id()] = true;
  if (key == 'k' || key == 'K') keys[Keys.k.id()] = true;

  if (key == '1') keys[Keys.one.id()]   = true;
  if (key == '2') keys[Keys.two.id()]   = true;
  if (key == '3') keys[Keys.three.id()] = true;
  if (key == '4') keys[Keys.four.id()]  = true;
  if (key == '5') keys[Keys.five.id()]  = true;
  if (key == '6') keys[Keys.six.id()]   = true;
  if (key == '7') keys[Keys.seven.id()] = true;
  if (key == '8') keys[Keys.eight.id()] = true;
  if (key == '9') keys[Keys.nine.id()]  = true;
  if (key == '0') keys[Keys.zero.id()] = true;

  if (key == '+') keys[Keys.plus.id()]  = true;
  if (key == '-') keys[Keys.minus.id()] = true;

  if (key == 'p' || key == 'P') projection = get_next_proj(projection);

  if (key == 'z' || key == 'Z') keys[Keys.z.id()] = true;
  if (key == 'x' || key == 'X') keys[Keys.x.id()] = true;
  if (key == 'c' || key == 'C') keys[Keys.c.id()] = true;
  if (key == 'v' || key == 'V') keys[Keys.v.id()] = true;
  if (key == 'b' || key == 'B') keys[Keys.b.id()] = true;
  if (key == 'n' || key == 'N') keys[Keys.n.id()] = true;
}

void key_up (boolean[] keys, char key) {
  if (key == 'q' || key == 'Q') keys[Keys.q.id()] = false;
  if (key == 'e' || key == 'E') keys[Keys.e.id()] = false;
  if (key == 'd' || key == 'D') keys[Keys.d.id()] = false;
  if (key == 'a' || key == 'A') keys[Keys.a.id()] = false;
  if (key == 'w' || key == 'W') keys[Keys.w.id()] = false;
  if (key == 's' || key == 'S') keys[Keys.s.id()] = false;

  if (key == 'r' || key == 'R') keys[Keys.r.id()] = false;
  if (key == 'y' || key == 'Y') keys[Keys.y.id()] = false;
  if (key == 'f' || key == 'F') keys[Keys.f.id()] = false;
  if (key == 'h' || key == 'H') keys[Keys.h.id()] = false;
  if (key == 't' || key == 'T') keys[Keys.t.id()] = false;
  if (key == 'g' || key == 'G') keys[Keys.g.id()] = false;

  if (key == 'u' || key == 'U') keys[Keys.u.id()] = false;
  if (key == 'o' || key == 'O') keys[Keys.o.id()] = false;
  if (key == 'j' || key == 'J') keys[Keys.j.id()] = false;
  if (key == 'l' || key == 'L') keys[Keys.l.id()] = false;
  if (key == 'i' || key == 'I') keys[Keys.i.id()] = false;
  if (key == 'k' || key == 'K') keys[Keys.k.id()] = false;

  if (key == '1') keys[Keys.one.id()]   = false;
  if (key == '2') keys[Keys.two.id()]   = false;
  if (key == '3') keys[Keys.three.id()] = false;
  if (key == '4') keys[Keys.four.id()]  = false;
  if (key == '5') keys[Keys.five.id()]  = false;
  if (key == '6') keys[Keys.six.id()]   = false;
  if (key == '7') keys[Keys.seven.id()] = false;
  if (key == '8') keys[Keys.eight.id()] = false;
  if (key == '9') keys[Keys.nine.id()]  = false;
  if (key == '0') keys[Keys.zero.id()]  = false;

  if (key == '+') keys[Keys.plus.id()]  = false;
  if (key == '-') keys[Keys.minus.id()] = false;

  if (key == 'z' || key == 'Z') keys[Keys.z.id()] = false;
  if (key == 'x' || key == 'X') keys[Keys.x.id()] = false;
  if (key == 'c' || key == 'C') keys[Keys.c.id()] = false;
  if (key == 'v' || key == 'V') keys[Keys.v.id()] = false;
  if (key == 'b' || key == 'B') keys[Keys.b.id()] = false;
  if (key == 'n' || key == 'N') keys[Keys.n.id()] = false;
}

//==============================================================================
// Reading keyboard events
//==============================================================================
void keyPressed () {
  key_down(keys,key);
}

void keyReleased () {
  key_up(keys,key);
}
//==============================================================================

//==============================================================================
// Reading mouse events
//==============================================================================
void mouseClicked () {
  axis_box.listen(mouseX,mouseY,universe);
  grid_box.listen(mouseX,mouseY,universe);
  translation_box.listen(mouseX,mouseY,universe);
  rotation_box.listen(mouseX,mouseY,universe);
  scale_box.listen(mouseX,mouseY,universe);
}
//==============================================================================
