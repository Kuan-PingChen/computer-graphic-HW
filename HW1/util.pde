public void CGLine(float x1, float y1, float x2, float y2) {
    // TODO HW1
    // You need to implement the "line algorithm" in this section.
    // You can use the function line(x1, y1, x2, y2); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).
    // For instance: drawPoint(114, 514, color(255, 0, 0)); signifies drawing a red
    // point at (114, 514).
// 在 util 檔案中

    int colorVal = color(0); // 預設黑色，你可以改成參數傳入顏色

    int x0 = round(x1);
    int y0 = round(y1);
    int xEnd = round(x2);
    int yEnd = round(y2);

    int dx = abs(xEnd - x0);
    int dy = abs(yEnd - y0);

    int sx = (x0 < xEnd) ? 1 : -1; // x 方向增減
    int sy = (y0 < yEnd) ? 1 : -1; // y 方向增減

    int err = dx - dy; // 誤差值

    while (true) {
        drawPoint(x0, y0, colorVal); // 畫一個像素

        if (x0 == xEnd && y0 == yEnd) break; // 到終點了
        int e2 = 2 * err;
        if (e2 > -dy) {
            err -= dy;
            x0 += sx;
        }
        if (e2 < dx) {
            err += dx;
            y0 += sy;
        }
    }


    /*
     stroke(0);
     noFill();
     line(x1,y1,x2,y2);
    */
}

public void CGCircle(float a, float b, float r) {
    // TODO HW1
    // You need to implement the "circle algorithm" in this section.
    // You can use the function circle(x, y, r); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).
// ===== util.pde / util.java =====

// 在 (cx, cy) 為圓心、半徑 r 的圓上畫點
  int col = color(0);          // 你也可以改成參數帶入顏色
  int xc = round(a);
  int yc = round(b);
  int R  = max(0, round(r));   // 取整數半徑，避免負值

  // 特例：半徑為 0
  if (R == 0) { 
    drawPoint(xc, yc, col);
    return;
  }

  int x = 0;
  int y = R;
  int d = 1 - R;               // Midpoint 的初始決策變數

  // 先畫出初始八對稱點
  plot8(xc, yc, x, y, col);

  // 每次 x 加 1，依 d 決定 y 是否減 1
  while (x < y) {
    x++;
    if (d < 0) {
      // 選 E 像素
      d += 2 * x + 1;
    } else {
      // 選 SE 像素
      y--;
      d += 2 * (x - y) + 1;
    }
    plot8(xc, yc, x, y, col);
  }
}

// 以 (xc, yc) 為圓心，把 (x, y) 映到 8 個對稱點
void plot8(int xc, int yc, int x, int y, int col) {
  drawPoint(xc + x, yc + y, col);
  drawPoint(xc - x, yc + y, col);
  drawPoint(xc + x, yc - y, col);
  drawPoint(xc - x, yc - y, col);

  drawPoint(xc + y, yc + x, col);
  drawPoint(xc - y, yc + x, col);
  drawPoint(xc + y, yc - x, col);
  drawPoint(xc - y, yc - x, col);


    /*
    stroke(0);
    noFill();
    circle(x,y,r*2);
    */
}

public void CGEllipse(float a, float b, float r1, float r2) {
    // TODO HW1
    // You need to implement the "ellipse algorithm" in this section.
    // You can use the function ellipse(x, y, r1,r2); to verify the correct answer.
    // However, remember to comment out the function before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).

// ===== util.pde / util.java =====

// 以 (cx, cy) 為中心，r1 為 x 方向半徑，r2 為 y 方向半徑

  int col = color(0);
  int xc = round(a), yc = round(b);
  int rx = max(0, round(abs(r1)));
  int ry = max(0, round(abs(r2)));

  // 特例：線或點
  if (rx == 0 && ry == 0) { drawPoint(xc, yc, col); return; }
  if (rx == 0) { // 退化成垂直線段
    for (int y = -ry; y <= ry; y++) drawPoint(xc, yc + y, col);
    return;
  }
  if (ry == 0) { // 退化成水平線段
    for (int x = -rx; x <= rx; x++) drawPoint(xc + x, yc, col);
    return;
  }

  // 中點橢圓演算法分兩個區域
  float rx2  = 1L * rx * rx;     // 用 long 避免溢位
  float ry2  = 1L * ry * ry;
  float twoRx2 = 2L * rx2;
  float twoRy2 = 2L * ry2;

  // 區域 1：斜率 > -1（|dy/dx| < 1）
  float x = 0;
  float y = ry;
  float px = 0;
  float py = twoRx2 * y;

  // 初始決策變數
  float p1 = ry2 - rx2 * ry + rx2 / 4;

  plot4(xc, yc, (int)x, (int)y, col); // 首點

  while (px < py) { // 直到斜率達到 -1 的分界
    x++;
    px += twoRy2;
    if (p1 < 0) {
      p1 += ry2 + px;
    } else {
      y--;
      py -= twoRx2;
      p1 += ry2 + px - py;
    }
    plot4(xc, yc, (int)x, (int)y, col);
  }

  // 區域 2：斜率 <= -1（|dy/dx| >= 1）
  float p2 = ry2 * (x + 0.5) * (x + 0.5) + rx2 * (y - 1) * (y - 1) - rx2 * ry2;
  while (y > 0) {
    y--;
    py -= twoRx2;
    if (p2 > 0) {
      p2 += rx2 - py;
    } else {
      x++;
      px += twoRy2;
      p2 += rx2 - py + px;
    }
    plot4(xc, yc, (int)x, (int)y, col);
  }
}

// 將 (x, y) 映射到四象限
void plot4(int xc, int yc, int x, int y, int col) {
  drawPoint(xc + x, yc + y, col);
  drawPoint(xc - x, yc + y, col);
  drawPoint(xc + x, yc - y, col);
  drawPoint(xc - x, yc - y, col);


    /*
    stroke(0);
    noFill();
    ellipse(x,y,r1*2,r2*2);
    */

}

// ===== util.pde / util.java =====



// De Casteljau：三次 Bézier 在參數 t 對應的點
static Vector3 bezierPoint(Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3, float t) {
  // 一階
  float x01 = lerp(p0.x, p1.x, t), y01 = lerp(p0.y, p1.y, t);
  float x12 = lerp(p1.x, p2.x, t), y12 = lerp(p1.y, p2.y, t);
  float x23 = lerp(p2.x, p3.x, t), y23 = lerp(p2.y, p3.y, t);
  // 二階
  float x012 = lerp(x01, x12, t), y012 = lerp(y01, y12, t);
  float x123 = lerp(x12, x23, t), y123 = lerp(y12, y23, t);
  // 三階
  return new Vector3(lerp(x012, x123, t), lerp(y012, y123, t), 0);
}



public void CGCurve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4) {
    // TODO HW1
    // You need to implement the "bezier curve algorithm" in this section.
    // You can use the function bezier(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x,
    // p4.y); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).
  int col = color(0);

  // 依幾何長度自動決定取樣數，避免太疏或太密
  float L = 0;
  L += dist(p1.x, p1.y, p2.x, p2.y);
  L += dist(p2.x, p2.y, p3.x, p3.y);
  L += dist(p3.x, p3.y, p4.x, p4.y);
  int samples = max(12, min(512, round(L * 1.5f))); // 可調：0.5f 決定密度

  // 逐段連線（用你已完成的 CGLine）
    /*
  Vector3 prev = bezierPoint(p1, p2, p3, p4, 0f);

  for (int i = 1; i <= samples; i++) {
    float t = i / (float) samples;
    Vector3 cur = bezierPoint(p1, p2, p3, p4, t);
    CGLine(prev.x, prev.y, cur.x, cur.y); // 連成平滑曲線
    prev = cur;
  }
  */

  // 如果想改成直接點繪（非連線），把上面 for 換成以下這段即可：
  for (int i = 0; i <= samples; i++) {
    float t = i / (float) samples;
    Vector3 q = bezierPoint(p1, p2, p3, p4, t);
    drawPoint(round(q.x), round(q.y), col);
  }
    /*
    stroke(0);
    noFill();
    bezier(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,p4.x,p4.y);
    */
}

public void CGEraser(Vector3 p1, Vector3 p2) {
    // TODO HW1
    // You need to erase the scene in the area defined by points p1 and p2 in this
    // section.
    // p1 ------
    // |       |
    // |       |
    // ------ p2
    // The background color is color(250);
    // You can use the mouse wheel to change the eraser range.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).
    // ===== util.pde / util.java =====

// 以 p1、p2 兩點定義的矩形區域進行「清除」（畫成背景色）

  // 背景色：依你的畫布背景調整
  final int bg = color(255, 255, 255, 255);

  // 轉整數並取得矩形邊界（支援 p1、p2 任意順序）
  int x0 = round(min(p1.x, p2.x));
  int x1 = round(max(p1.x, p2.x));
  int y0 = round(min(p1.y, p2.y));
  int y1 = round(max(p1.y, p2.y));

  // 夾到畫布範圍，避免越界
  x0 = max(0, min(width  - 1, x0));
  x1 = max(0, min(width  - 1, x1));
  y0 = max(0, min(height - 1, y0));
  y1 = max(0, min(height - 1, y1));

  // 掃描填白（不使用 rect）
  for (int y = y0; y <= y1; y++) {
    for (int x = x0; x <= x1; x++) {
      drawPoint(x, y, bg);
    }
  }
}




public void drawPoint(float x, float y, color c) {
    stroke(c);
    point(x, y);
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}
