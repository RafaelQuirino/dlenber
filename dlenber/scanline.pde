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

void setup() {
	size(640, 640);
	noSmooth();
    background(0);
}

int get_number(int limit) {
	return (int) random(limit);
}

color get_color() {
	int r = get_number(255);
	int g = get_number(255);
	int b = get_number(255);
	return color(r, g, b);
}

int[][] get_polygon() {
	int n = 6 + get_number(20);
	int mid = 200 + get_number(50);
	n += n % 2;
	int[][] P = new int[n][2];
	P[0][0] = 120 + get_number(50);
	for (int i = 1; i < n / 2; i++) {
		P[i][0] = P[i - 1][0] + 20 + get_number(35);
	}
	for (int i = 0; i < n / 2; i++) {
		P[i][1] = mid - 40 - get_number(90);
	}
	P[n - 1][0] = 120 + get_number(50);
	for (int i = n - 2; i >= n / 2; i--) {
		P[i][0] = P[i + 1][0] + 20 + get_number(35);
	}
	for (int i = n / 2; i < n; i++) {
		P[i][1] = mid + 40 + get_number(90);
	}
	return P;
}

void draw() {
	background(0);
	int preenche = get_number(255) % 2;
	color cor_linha = get_color();
	color cor_preenchimento = get_color();
	int[][] P = get_polygon();
	int[][] L = new int[P.length][2];
	for (int i = 0; i < P.length; i++) {
		L[i][0] = i;
		L[i][1] = (i + 1) % P.length;
	}
	scanline(P, L, cor_linha, (preenche == 0), cor_preenchimento);
	delay(5000);
}

void keyPressed() {
	if (key == ESC) {
		exit();
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

void scanline(int[][] P, int[][] L, color cor_linha, boolean preenche, color cor_preenchimento) {
	if (preenche) {
		int low = INF;
		int high = -INF;
		lado[] s = new lado[L.length];
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
		stroke(cor_preenchimento);
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
				linhaDDA(from.x, now, to.x, now);
			}
		}
	}
	stroke(cor_linha);
	for (int i = 0; i < L.length; i++) {
		int from = L[i][0];
		int to = L[i][1];
		int x1 = P[from][0];
		int y1 = P[from][1];
		int x2 = P[to][0];
		int y2 = P[to][1];
		linhaDDA(x1, y1, x2, y2);
	}
}