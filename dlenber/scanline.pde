import java.util.List;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collections;

public static final int INF = (int) 1e9;

class lado {
	int ymin;
	int ymax;
	int xmin;
	double m;

	lado(int _ymin, int _ymax, int _xmin, double _m) {
		ymin = _ymin;
		ymax = _ymax;
		xmin = _xmin;
		m = _m;
	}
}

class Ponto implements Comparable<Ponto> {
	int x;
	int id;

	Ponto(int _x, int _id) {
		x = _x;
		id = _id;
	}

	public int compareTo(Ponto Ponto) {
		if (x != Ponto.x) {
			return (x < Ponto.x ? -1 : 1);
		} else if (id != Ponto.id) {
			return (id < Ponto.id ? -1 : 1);
		} else {
			return 0;
		}
	}
}

void linhaDDA(int xi, int yi, int xf, int yf) {
	int dx = xf - xi;
	int dy = yf - yi;
	int steps = max(abs(dx), abs(dy));
	double x = xi;
	double y = yi;
	double incx = 1.0 * dx / steps;
	double incy = 1.0 * dy / steps;
	point((int) x, (int) y);
	for (int k = 0; k < steps; k++) {
		x += incx;
		y += incy;
		point((int) x, (int) y);
	}
}

int sgn(int x) {
	if (x > 0) {
		return 1;
	} else if (x < 0) {
		return -1;
	} else {
		return 0;
	}
}

List<Ponto> fix(int now, lado[] s, List<Ponto> coords) {
	Ponto[] a = new Ponto[coords.size()];
	List<Ponto> ret = new ArrayList<Ponto>();
	for (int i = 0; i < a.length; i++) {
		a[i] = coords.get(i);
	}
	for (int i = 0; i < a.length; i++) {
		if (i + 1 == a.length || a[i + 1].x != a[i].x) {
			ret.add(a[i]);
		} else {
			int from = a[i].id;
			int to = a[i + 1].id;
			if (sgn(s[from].ymax - now) != sgn(s[to].ymax - now)) {
				ret.add(a[i]);
			} else {
				ret.add(a[i]);
				ret.add(a[i + 1]);
			}
			i++;
		}
	}
	return ret;
}

void my_fill_poly_scanline(float[][] points, int[] pointIndexes, int numpoints, color thecolor) {
	int low = INF;
	int high = -INF;
	int[][] P = new int[points.length][2];
	int[][] L = new int[numpoints][2];
	lado[] s = new lado[L.length];
	for (int i = 0; i < points.length; i++) {
		P[i][0] = (int) Math.round(points[i][0]);
		P[i][1] = (int) Math.round(points[i][1]);
	}
	for (int i = 0; i < numpoints; i++) {
		L[i][0] = pointIndexes[i];
		L[i][1] = pointIndexes[(i + 1) % numpoints];
	}
	for (int i = 0; i < L.length; i++) {
		int from = L[i][0];
		int to = L[i][1];
		low = min(low, P[from][1]);
		low = min(low, P[to][1]);
		high = max(high, P[from][1]);
		high = max(high, P[to][1]);
	}
	for (int i = 0; i < L.length; i++) {
		int from = L[i][0];
		int to = L[i][1];
		int ymin = min(P[from][1], P[to][1]);
		int ymax = max(P[from][1], P[to][1]);
		int xmin = (P[from][1] == ymin ? P[from][0] : P[to][0]);
		int dx = P[to][0] - P[from][0];
		int dy = P[to][1] - P[from][1];
		double m = (dy == 0) ? 0.0 : (1.0 * dx / dy);
		s[i] = new lado(ymin, ymax, xmin, m);
	}
	stroke(thecolor);
	for (int now = low; now <= high; now++) {
		List<Ponto> coords = new ArrayList();
		for (int i = 0; i < s.length; i++) {
			int ymin = s[i].ymin;
			int ymax = s[i].ymax;
			if (now > ymax || now < ymin || ymin == ymax) {
				continue;
			}
			int x = (int) round((float) (s[i].xmin + s[i].m * (now - ymin)));
			coords.add(new Ponto(x, i));
		}
		Collections.sort(coords);
		coords = fix(now, s, coords);
		for (int i = 0; i + 1 < coords.size(); i += 2) {
			Ponto from = coords.get(i);
			Ponto to = coords.get(i + 1);
			// linhaDDA(from.x, now, to.x, now);
      line(from.x,now,to.x,now);
		}
	}
}

void my_fill_poly_gourard(
  float[] illuminations, Object3D obj, float[][] points, int[] pointIndexes, int numpoints,
  color thecolor, int r, int g, int b
)
{
	int low = INF;
	int high = -INF;
	int[][] P = new int[points.length][2];
	int[][] L = new int[numpoints][2];
	lado[] s = new lado[L.length];
	for (int i = 0; i < points.length; i++) {
		P[i][0] = (int) Math.round(points[i][0]);
		P[i][1] = (int) Math.round(points[i][1]);
	}
	for (int i = 0; i < numpoints; i++) {
		L[i][0] = pointIndexes[i];
		L[i][1] = pointIndexes[(i + 1) % numpoints];
	}
	for (int i = 0; i < L.length; i++) {
		int from = L[i][0];
		int to = L[i][1];
		low = min(low, P[from][1]);
		low = min(low, P[to][1]);
		high = max(high, P[from][1]);
		high = max(high, P[to][1]);
	}
	for (int i = 0; i < L.length; i++) {
		int from = L[i][0];
		int to = L[i][1];
		int ymin = min(P[from][1], P[to][1]);
		int ymax = max(P[from][1], P[to][1]);
		int xmin = (P[from][1] == ymin ? P[from][0] : P[to][0]);
		int dx = P[to][0] - P[from][0];
		int dy = P[to][1] - P[from][1];
		double m = (dy == 0) ? 0.0 : (1.0 * dx / dy);
		s[i] = new lado(ymin, ymax, xmin, m);
	}

  stroke(thecolor);

	for (int now = low; now <= high; now++) {
		List<Ponto> coords = new ArrayList();
		for (int i = 0; i < s.length; i++) {
			int ymin = s[i].ymin;
			int ymax = s[i].ymax;
			if (now > ymax || now < ymin || ymin == ymax) {
				continue;
			}
			int x = (int) round((float) (s[i].xmin + s[i].m * (now - ymin)));
			coords.add(new Ponto(x, i));
		}
		Collections.sort(coords);
		coords = fix(now, s, coords);
		for (int i = 0; i + 1 < coords.size(); i += 2) {
			Ponto from = coords.get(i);
			Ponto to = coords.get(i + 1);

      //linhaDDA(from.x, now, to.x, now);
      // line(from.x, now, to.x, now);
      //------------------------------------------------------------------------
      // GOURARD
      //------------------------------------------------------------------------
      int y = now;
      // for (int x = from.x; x <= to.x; x++) {
        int x = from.x;
        float[] distances = new float[numpoints];
        float[] u = {(float)x, (float)y};
        for (int k = 0; k < numpoints; k++) {
          float[] v = {points[k][0], points[k][1]};
          distances[k] = dist_vectors(u,v);
        }
        float l = 0.0f;
        float dist_sum = 0.0;
        for (int k = 0; k < numpoints; k++) {
          dist_sum += distances[k];
          l += distances[k]*illuminations[k];
        }
        float illumination = l/dist_sum;
        float[] rgb = shade_color(r,g,b,illumination);
        stroke(color(rgb[0],rgb[1],rgb[2]));
        line(from.x, now, to.x, now);
      // }
      //------------------------------------------------------------------------
		}
	}
}

void my_fill_poly_gourard_2(
  float[] illuminations, Object3D obj, float[][] points, int[] pointIndexes, int numpoints,
  color thecolor, int r, int g, int b
)
{
	int low = INF;
	int high = -INF;
	int[][] P = new int[points.length][2];
	int[][] L = new int[numpoints][2];
	lado[] s = new lado[L.length];
	for (int i = 0; i < points.length; i++) {
		P[i][0] = (int) Math.round(points[i][0]);
		P[i][1] = (int) Math.round(points[i][1]);
	}
	for (int i = 0; i < numpoints; i++) {
		L[i][0] = pointIndexes[i];
		L[i][1] = pointIndexes[(i + 1) % numpoints];
	}
	for (int i = 0; i < L.length; i++) {
		int from = L[i][0];
		int to = L[i][1];
		low = min(low, P[from][1]);
		low = min(low, P[to][1]);
		high = max(high, P[from][1]);
		high = max(high, P[to][1]);
	}
	for (int i = 0; i < L.length; i++) {
		int from = L[i][0];
		int to = L[i][1];
		int ymin = min(P[from][1], P[to][1]);
		int ymax = max(P[from][1], P[to][1]);
		int xmin = (P[from][1] == ymin ? P[from][0] : P[to][0]);
		int dx = P[to][0] - P[from][0];
		int dy = P[to][1] - P[from][1];
		double m = (dy == 0) ? 0.0 : (1.0 * dx / dy);
		s[i] = new lado(ymin, ymax, xmin, m);
	}

  stroke(thecolor);

	for (int now = low; now <= high; now++) {
		List<Ponto> coords = new ArrayList();
		for (int i = 0; i < s.length; i++) {
			int ymin = s[i].ymin;
			int ymax = s[i].ymax;
			if (now > ymax || now < ymin || ymin == ymax) {
				continue;
			}
			int x = (int) round((float) (s[i].xmin + s[i].m * (now - ymin)));
			coords.add(new Ponto(x, i));
		}
		Collections.sort(coords);
		coords = fix(now, s, coords);
		for (int i = 0; i + 1 < coords.size(); i += 2) {
			Ponto from = coords.get(i);
			Ponto to = coords.get(i + 1);

      //linhaDDA(from.x, now, to.x, now);
      // line(from.x, now, to.x, now);
      //------------------------------------------------------------------------
      // GOURARD
      //------------------------------------------------------------------------
      int y = now;
      int inc = 4;
      for (int x = from.x; x <= to.x; x+=inc) {
        // int x = from.x;
        float[] distances = new float[numpoints];
        float[] u = {(float)x, (float)y};
        for (int k = 0; k < numpoints; k++) {
          float[] v = {points[k][0], points[k][1]};
          distances[k] = dist_vectors(u,v);
        }
        float l = 0.0f;
        float dist_sum = 0.0;
        for (int k = 0; k < numpoints; k++) {
          dist_sum += distances[k];
          l += distances[k]*illuminations[k];
        }
        float illumination = l/dist_sum;
        float[] rgb = shade_color(r,g,b,illumination);
        stroke(color(rgb[0],rgb[1],rgb[2]));
        line(x, now, min(x+inc,to.x), now);
      }
      //------------------------------------------------------------------------
		}
	}
}

void my_fill_poly_gourard_3(
  float[][] illuminations, Light3D light, Object3D obj,
  float[][] points, int[] pointIndexes, int numpoints,
  color thecolor, int r, int g, int b
)
{
	int low = INF;
	int high = -INF;
	int[][] P = new int[points.length][2];
	int[][] L = new int[numpoints][2];
	lado[] s = new lado[L.length];
	for (int i = 0; i < points.length; i++) {
		P[i][0] = (int) Math.round(points[i][0]);
		P[i][1] = (int) Math.round(points[i][1]);
	}
	for (int i = 0; i < numpoints; i++) {
		L[i][0] = pointIndexes[i];
		L[i][1] = pointIndexes[(i + 1) % numpoints];
	}
	for (int i = 0; i < L.length; i++) {
		int from = L[i][0];
		int to = L[i][1];
		low = min(low, P[from][1]);
		low = min(low, P[to][1]);
		high = max(high, P[from][1]);
		high = max(high, P[to][1]);
	}
	for (int i = 0; i < L.length; i++) {
		int from = L[i][0];
		int to = L[i][1];
		int ymin = min(P[from][1], P[to][1]);
		int ymax = max(P[from][1], P[to][1]);
		int xmin = (P[from][1] == ymin ? P[from][0] : P[to][0]);
		int dx = P[to][0] - P[from][0];
		int dy = P[to][1] - P[from][1];
		double m = (dy == 0) ? 0.0 : (1.0 * dx / dy);
		s[i] = new lado(ymin, ymax, xmin, m);
	}

  stroke(thecolor);

	for (int now = low; now <= high; now++) {
		List<Ponto> coords = new ArrayList();
		for (int i = 0; i < s.length; i++) {
			int ymin = s[i].ymin;
			int ymax = s[i].ymax;
			if (now > ymax || now < ymin || ymin == ymax) {
				continue;
			}
			int x = (int) round((float) (s[i].xmin + s[i].m * (now - ymin)));
			coords.add(new Ponto(x, i));
		}
		Collections.sort(coords);
		coords = fix(now, s, coords);
		for (int i = 0; i + 1 < coords.size(); i += 2) {
			Ponto from = coords.get(i);
			Ponto to = coords.get(i + 1);

      //linhaDDA(from.x, now, to.x, now);
      // line(from.x, now, to.x, now);
      //------------------------------------------------------------------------
      // GOURARD
      //------------------------------------------------------------------------
      int y = now;
      int inc = 4;
      for (int x = from.x; x <= to.x; x+=inc) {
        // int x = from.x;
        float[] distances = new float[numpoints];
        float[] u = {(float)x, (float)y};
        for (int k = 0; k < numpoints; k++) {
          float[] v = {points[k][0], points[k][1]};
          distances[k] = dist_vectors(u,v);
        }

        float l_diff = 0.0f;
        float l_spec = 0.0f;
        float dist_sum = 0.0;
        for (int k = 0; k < numpoints; k++) {
          dist_sum += distances[k];
          l_diff += distances[k]*illuminations[k][0];
          l_diff += distances[k]*illuminations[k][1];
          l_spec += distances[k]*illuminations[k][2];
        }

        float illumination_diff = l_diff/dist_sum;
        float illumination_spec = l_spec/dist_sum;

				// float[] rgb = shade_color(r,g,b,illumination_diff);
				int[] rgb = shade_color_2(r,g,b,illumination_diff);
        color c = interpolate_colors(
          (int)rgb[0],
          (int)rgb[1],
          (int)rgb[2],
          light.R,light.G,light.B,
          illumination_spec
        );
        stroke(c);

        line(x, now, min(x+inc,to.x), now);
      }
      //------------------------------------------------------------------------
		}
	}
}
