/*** 

Atenção: Cuidado para não usar trechos deste código em 
trabalhos individuais pois as funções abaixo já foram usadas
em trabalhos individuais anteriores, o que seria considerado plágio 
e portanto todos os envolvidos teriam sua nota dos trabalhos reduzida.

Para usar a classe, basta abrir o processing e executar o programa
A saída será composta de coordenadas dos pontos, índices de linhas,
índices de faces e o objeto será mostrado na tela

***/

/*import java.util.List;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collections;

public static final int N = 256;
public static final double EPS = 1e-9;
public static final double PI = Math.cos(-1.0);

int sgn(double value) {
    if (value > EPS) {
        return 1;
    } else if (value < -EPS) {
        return -1;
    } else {
        return 0;
    }
}

class Point implements Comparable<Point> {
    double x;
    double y;
    double z;

    Point(double _x, double _y, double _z) {
        x = _x;
        y = _y;
        z = _z;
    }

    Point subtract(Point other) {
        return new Point(x - other.x, y - other.y, z - other.z);
    }

    Point divide(double value) {
        return new Point(x / value, y / value, z / value);
    }

    double dot(Point other) {
        return x * other.x + y * other.y + z * other.z;
    }

    Point cross(Point other) {
        return new Point(y * other.z - z * other.y, z * other.x - x * other.z, x * other.y - y * other.x);
    }

    double length() {
        return Math.sqrt(x * x + y * y + z * z);
    }

    public int compareTo(Point other) {
        if (sgn(x - other.x) != 0) {
            return (sgn(x - other.x) < 0) ? -1 : 1;
        } else if (sgn(y - other.y) != 0) {
            return (sgn(y - other.y) < 0) ? -1 : 1;
        } else if (sgn(z - other.z) != 0) {
            return (sgn(z - other.z) < 0) ? -1 : 1;
        } else {
            return 0;
        }
    }
}

class Face {
    List<Integer> vertices;

    Face() {
        vertices = new ArrayList();
    }

    Face(List<Integer> tvertices) {
        this.vertices = tvertices;
    }

    Face(int _a, int _b, int _c) {
        vertices = new ArrayList();
        vertices.add(_a);
        vertices.add(_b);
        vertices.add(_c);
    }
}

class Arame {
    int n;
    int m;
    int K;
    int cx;
    int cy;
    int projection;
    int[][] L;
    int[][] mark;
    double tx;
    double ty;
    double tz;
    double sx;
    double sy;
    double sz;
    double R;
    double G;
    double B;
    double[][] P;
    List<Face> faces;
    Point[] points;

    Arame() { 
        n = 10 + get_number(5);
        sx = 1;
        sy = 1;
        sz = 1;
        cx = 150 + get_number(300);
        cy = 150 + get_number(300);
        mark = new int[N][N];
        faces = new ArrayList();
        gera_poliedro();
        System.out.println("# Objeto X");
        System.out.println(this.P.length + " " + this.m + " " + this.faces.size());
        for (int i = 0; i < this.P.length; i++) {
            System.out.printf("%.5f %.5f %.5f\n", P[i][0], P[i][1], P[i][2]);
        }
        for (int i = 0; i < this.m; i++) {
            System.out.println(L[i][0] + " "+  L[i][1]);
        }
        for (int i = 0; i < this.faces.size(); i++) {
            Face now = this.faces.get(i);
            System.out.println(3 + " " + now.vertices.get(0) + " " + now.vertices.get(1) + " " + now.vertices.get(2) + " 255 0 0");
        }
        System.out.println("0 0 0");
        System.out.println("1 1 1");
        System.out.println(this.cx + " " + this.cy + " " + 0);
    }

    double mix(Point a, Point b, Point c) {
        return a.dot(b.cross(c));
    }

    double volume(Point a, Point b, Point c, Point d) {
        return mix(b.subtract(a), c.subtract(a), d.subtract(a));
    }

    Point[] unique(Point[] now) {
        List<Point> tmp = new ArrayList();
        tmp.add(now[0]);
        for (int i = 1; i < now.length; i++) {
            int dx = sgn(now[i].x - now[i - 1].x);
            int dy = sgn(now[i].y - now[i - 1].y);
            int dz = sgn(now[i].z - now[i - 1].z);
            if (dx != 0 || dy != 0 || dz != 0) {
                tmp.add(now[i]);
            }
        }
        Point[] res = new Point[tmp.size()];
        for (int i = 0; i < res.length; i++) {
            res[i] = tmp.get(i);
        }
        return res;
    }

    void find() {
        for (int i = 2; i < points.length; i++) {
            Point ndir = (points[0].subtract(points[i])).cross(points[1].subtract(points[i]));
            if (sgn(ndir.x) == 0 && sgn(ndir.y) == 0 && sgn(ndir.z) == 0) {
                continue;
            }
            Point tmp = points[i];
            points[i] = points[2];
            points[2] = tmp;
            for (int j = i + 1; j < points.length; j++) {
                if (sgn(volume(points[0], points[1], points[2], points[j])) != 0) {
                    tmp = points[j];
                    points[j] = points[3];
                    points[3] = tmp;
                    faces.add(new Face(0, 1, 2));
                    faces.add(new Face(0, 2, 1));
                    return;
                }
            }
        }
    }

    Point[] hull() {
        int tim = 0;
        faces.clear();
        for (int i = 0; i < mark.length; i++) {
            Arrays.fill(mark[i], 0);
        }
        Arrays.sort(points);
        points = unique(points).clone();
        find();
        for (int i = 3; i < points.length; i++) {
            tim++;
            List<Face> tmp = new ArrayList();
            for (int j = 0; j < faces.size(); j++) {
                Face now = faces.get(j);
                int a = now.vertices.get(0);
                int b = now.vertices.get(1);
                int c = now.vertices.get(2);
                if (sgn(volume(points[i], points[a], points[b], points[c])) < 0) {
                    mark[a][b] = mark[b][a] = tim;
                    mark[b][c] = mark[c][b] = tim;
                    mark[a][c] = mark[c][a] = tim;
                } else {
                    tmp.add(faces.get(j));
                }
            }
            faces.clear();
            for (int j = 0; j < tmp.size(); j++) {
                faces.add(tmp.get(j));
            }
            for (int j = 0; j < tmp.size(); j++) {
                Face now = faces.get(j);
                int a = now.vertices.get(0);
                int b = now.vertices.get(1);
                int c = now.vertices.get(2);
                if (mark[a][b] == tim) {
                    faces.add(new Face(b, a, i));
                }
                if (mark[b][c] == tim) {
                    faces.add(new Face(c, b, i));
                }
                if (mark[c][a] == tim) {
                    faces.add(new Face(a, c, i));
                }
            }
        }
        Point[] res = new Point[faces.size()];
        for (int i = 0; i < faces.size(); i++) {
            Face now = faces.get(i);
            int a = now.vertices.get(0);
            int b = now.vertices.get(1);
            int c = now.vertices.get(2);
            Point tmp = (points[a].subtract(points[b])).cross(points[c].subtract(points[b]));
            res[i] = tmp.divide(tmp.length());
        }
        Arrays.sort(res);
        res = unique(res).clone();
        return res;
    }

    void gera_poliedro() { 
        points = new Point[n];
        for (int i = 0; i < n; i++) {
            double x = 30 + get_number(20);
            double y = 30 + get_number(20);
            double z = 30 + get_number(20);
            points[i] = new Point(x, y, z);
        }
        points = hull().clone();
        Arrays.sort(points);
        P = new double[points.length][4];
        for (int i = 0; i < points.length; i++) {
            points[i].x *= 80;
            points[i].y *= 80;
            points[i].z *= 80;
            P[i] = new double[]{points[i].x, points[i].y, points[i].z, 1.0};
        }
        points = hull().clone();
        m = 3 * faces.size();
        L = new int[m][2];
        for (int i = 0; i < faces.size(); i++) {
            int k = i * 3;
            Face now = faces.get(i);
            int a = now.vertices.get(0);
            int b = now.vertices.get(1);
            int c = now.vertices.get(2);
            L[k++] = new int[]{a, b};
            L[k++] = new int[]{a, c};
            L[k++] = new int[]{b, c};
        }
    }
}

class Universo {
    int at;
    List<Arame> objects;

    Universo() {
        at = 0;
        objects = new ArrayList();
        objects.add(new Arame());
    }

    void print() {
        Arame solid = objects.get(0);
        double[][] now = solid.P;
        stroke(color(255, 0, 0));
        for (int j = 0; j < solid.faces.size(); j++) {
            Face face = solid.faces.get(j);
            for (int k = 0; k < face.vertices.size(); k++) {
                int from = face.vertices.get(k);
                int to = face.vertices.get((k + 1) % face.vertices.size());
                int x1 = solid.cx + (int) Math.round(now[from][0]);
                int y1 = solid.cy + (int) Math.round(now[from][1]);
                int x2 = solid.cx + (int) Math.round(now[to][0]);
                int y2 = solid.cy + (int) Math.round(now[to][1]);
                linhaDDA(x1, 640 - y1, x2, 640 - y2);
            }
        }
    }
}

Universo universo;

void setup() {
    size(720, 640);
    noSmooth();
    background(0);
    universo = new Universo();
}

int get_number(int limit) {
    return (int) random(limit);
}

void draw() {
    background(0);
    universo.print();
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
}*/