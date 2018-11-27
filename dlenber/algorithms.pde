//==============================================================================
// Rasterization algorithms
//==============================================================================

// Naive version
void lin_analitico (int xi, int yi, int xf, int yf, color thecolor) {
  float m = (float)(yf-yi) / (float)(xf-xi);
  float b = (float)(yi - (m * xi));

  for (int x=xi; x<=xf; x++){
    int y = (int) (m * x + b);
    putpixel(x,y,thecolor);
  }
}



// "Digital Differentiator Analyzer"
void lin_dda (int xi, int yi, int xf, int yf, color thecolor) {
  int dx = xf-xi, dy = yf-yi, steps;
  float incX, incY, x = xi, y = yi;

  if (abs(dx) > abs(dy)) steps = abs(dx);
  else steps = abs(dy);

  // Possible division by zero
  incX = dx / (float) steps; //if dy > dx this is dx/dy -> 1/m
  incY = dy / (float) steps; //if dx > dy this is dy/dx -> m

  putpixel((int)x, (int)y, thecolor);
  for (int k = 0; k < steps; k++) {
    x += incX;
    y += incY;
    putpixel((int)x, (int)y, thecolor);
  }
}



//------------------------------------------------------------------------------
// BRESENHAM LINE RASTERIZATION
//------------------------------------------------------------------------------
// Valid only for the octant in which the segment goes down and to the right
// (x0 <= x1 and y0 <= y1), and its horizontal projection x1-x0 is longer than
// the vertical projection y1-y0
// (the line has a positive slope whose absolute value is less than 1)
void lin_bres_special (int xi, int yi, int xf, int yf, color thecolor) {
  int dx = xf-xi, dy = yf-yi;
  int di = 2 * dy - dx;
  int twoDy = 2 * dy;
  int twoDyDx = 2 * (dy-dx);

  int x = xi, y = yi;
  putpixel(x,y,thecolor);

  while (x <= xf) {
    x++;
    if (di < 0)
      di += twoDy;
    else {
      y++;
      di += twoDyDx;
    }
    putpixel(x,y,thecolor);
  }
}

// Auxiliar function 1 for complete bresenham line rastering
void bres_line_low (int x0, int y0, int x1, int y1, color thecolor) {
  int dx = x1 - x0;
  int dy = y1-y0;
  int yi = 1;
  if (dy < 0) {
      yi = -1;
      dy = -dy;
  }
  int d = 2*dy - dx;
  int y = y0;

  for (int x = x0; x <= x1; x++) {
    putpixel(x,y,thecolor);
    if (d > 0) {
        y += yi;
        d -= 2*dx;
    }
    d += 2*dy;
  }
}

// Auxiliar function 2 for complete bresenham line rastering
void bres_line_high (int x0, int y0, int x1, int y1, color thecolor) {
    int dx = x1 - x0;
    int dy = y1 - y0;
    int xi = 1;
    if (dx < 0) {
        xi = -1;
        dx = -dx;
    }
    int d = 2*dx - dy;
    int x = x0;

    for (int y = y0; y <= y1; y++) {
        putpixel(x,y,thecolor);
        if (d > 0) {
            x += xi;
            d -= 2*dy;
        }
        d = d + 2*dx;
    }
}

// Complete bresenham algorithm, valid for all cases
void lin_bres (int x0, int y0, int x1, int y1, color thecolor) {
  if (abs(y1 - y0) < abs(x1 - x0)) {
    if (x0 > x1) bres_line_low(x1, y1, x0, y0, thecolor);
    else         bres_line_low(x0, y0, x1, y1, thecolor);
  }
  else {
    if (y0 > y1) bres_line_high(x1, y1, x0, y0, thecolor);
    else         bres_line_high(x0, y0, x1, y1, thecolor);
  }
}
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
// BRESENHAM CIRCLE RASTERIZATION
//------------------------------------------------------------------------------
void circ_bres(int x0, int y0, int radius, color thecolor) {
  int x = radius-1;
  int y = 0;
  int dx = 1;
  int dy = 1;
  int err = dx - (radius << 1);

  while (x >= y)
  {
    putpixel(x0 + x, y0 + y, thecolor);
    putpixel(x0 + y, y0 + x, thecolor);
    putpixel(x0 - y, y0 + x, thecolor);
    putpixel(x0 - x, y0 + y, thecolor);
    putpixel(x0 - x, y0 - y, thecolor);
    putpixel(x0 - y, y0 - x, thecolor);
    putpixel(x0 + y, y0 - x, thecolor);
    putpixel(x0 + x, y0 - y, thecolor);

    if (err <= 0) {
      y++;
      err += dy;
      dy += 2;
    }

    if (err > 0) {
      x--;
      dx += 2;
      err += dx - (radius << 1);
    }
  }
}
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// POLYGON FILLING ALGORITHMS
//------------------------------------------------------------------------------
void scanline_fill (float[][] points, int[] pointIndexes, int numpoints, color thecolor) {
  int n = numpoints;

  // Setting poly constants;
  int MAX_POLY_CORNERS = 128;
  int polyX[] = new int[n];
  int polyY[] = new int[n];
  for (int i = 0; i < n; i++) {
    polyX[i] = (int) points[pointIndexes[i]][0];
    polyY[i] = (int) points[pointIndexes[i]][1];
  }
  // Setting "image" size constants
  int minX=polyX[0], maxX=polyX[0], minY=polyY[0], maxY=polyY[0];
  for (int i = 1; i < n; i++) {
    int x = polyX[i], y = polyY[i];
    if (x < minX) minX = x;
    if (x > maxX) maxX = x;
    if (y < minY) minY = y;
    if (y > maxY) maxY = y;
  }
  int IMAGE_TOP=minY, IMAGE_BOT=maxY, IMAGE_LEFT=minX, IMAGE_RIGHT=maxX;
  int polyCorners = n;

  int nodes, pixelX, pixelY, i, j, swap;
  int nodeX[] = new int[MAX_POLY_CORNERS];

  //  Loop through the rows of the image.
  for (pixelY=IMAGE_TOP; pixelY<IMAGE_BOT; pixelY++) {

    //  Build a list of nodes.
    nodes=0;
    j=polyCorners-1;
    for (i=0; i<polyCorners; i++) {
      if (polyY[i]<(double) pixelY && polyY[j]>=(double) pixelY
      ||  polyY[j]<(double) pixelY && polyY[i]>=(double) pixelY) {
        nodeX[nodes++] = (int) (polyX[i]+(pixelY-polyY[i])/(polyY[j]-polyY[i])
        *(polyX[j]-polyX[i]));
      }
      j=i;
    }

    //  Sort the nodes, via a simple “Bubble” sort.
    i=0;
    while (i<nodes-1) {
      if (nodeX[i]>nodeX[i+1]) {
        swap=nodeX[i]; nodeX[i]=nodeX[i+1]; nodeX[i+1]=swap;
        if (i !=  0) i--;
      }
      else {
        i++;
      }
    }

    //  Fill the pixels between node pairs.
    for (i=0; i<nodes; i+=2) {
      if (nodeX[i  ] >= IMAGE_RIGHT) break;
      if (nodeX[i+1] > IMAGE_LEFT ) {
        if (nodeX[i  ] < IMAGE_LEFT ) nodeX[i  ] = IMAGE_LEFT ;
        if (nodeX[i+1] > IMAGE_RIGHT) nodeX[i+1] = IMAGE_RIGHT;
        for (pixelX=nodeX[i]; pixelX<nodeX[i+1]; pixelX++)
          putpixel(pixelX,pixelY,thecolor);
      }
    }
  }
}

void scanline_fill_2 (float[][] points, int[] pointIndexes, int numpoints, color thecolor) {
  fill(thecolor);
  beginShape();
  for (int i = 0; i < numpoints; i++) {
    vertex((int)points[pointIndexes[i]][0], (int)points[pointIndexes[i]][1]);
  }
  endShape(CLOSE);
  fill(fill_color);
}
//==============================================================================



//==============================================================================
// Math algorithms
//==============================================================================
float[][] dot (float[][] A, float[][] B) {
  int r1 = A.length;
  int c1 = A[0].length;
  int c2 = B[0].length;
  float[][] AB = new float[r1][c2];
  for(int i = 0; i < r1; i++) {
    for (int j = 0; j < c2; j++) {
      AB[i][j] = 0.0f;
      for (int k = 0; k < c1; k++) {
        AB[i][j] += A[i][k] * B[k][j];
      }
    }
  }
  return AB;
}



float[][] add (float[][] A, float[][] B) {
  float[][] AplusB = new float[A.length][A[0].length];
  for(int i = 0; i < A.length; i++) {
    for (int j = 0; j < A[0].length; j++) {
      AplusB[i][j] = A[i][j] + B[i][j];
    }
  }
  return AplusB;
}



float[][] sub (float[][] A, float[][] B) {
  float[][] AminusB = new float[A.length][A[0].length];
  for(int i = 0; i < A.length; i++) {
    for (int j = 0; j < A[0].length; j++) {
      AminusB[i][j] = A[i][j] - B[i][j];
    }
  }
  return AminusB;
}
//==============================================================================
