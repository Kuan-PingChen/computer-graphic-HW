HW1 — 基本繪圖演算法實作

本作業實作電腦圖學中的基本幾何繪圖演算法，包括：

直線（Line）

圓（Circle）

橢圓（Ellipse）

三次 Bézier 曲線（Cubic Bézier Curve）

所有圖形皆以逐像素方式繪製（drawPoint(x, y, color)），不得呼叫 Processing 內建的 line()、circle()、ellipse()、bezier() 等函式。

✏️ 1. 畫線演算法（Line Drawing）

採用 Bresenham / Midpoint Line Algorithm
適用於所有八個象限，利用誤差值 err 決定像素步進方向。

核心思想：

取起點 (x0, y0)、終點 (xEnd, yEnd)，計算

dx = |xEnd - x0|
dy = |yEnd - y0|
sx = x0 < xEnd ? 1 : -1
sy = y0 < yEnd ? 1 : -1
err = dx - dy


每次繪製目前 (x, y) 後：

計算 e2 = 2 * err

若 e2 > -dy：往 x 方向前進，err -= dy

若 e2 < dx：往 y 方向前進，err += dx

重複直到 (x, y) 到達終點。

優點：

僅使用整數運算

無需浮點除法

適合所有斜率（不需特殊分支）

⭕ 2. 畫圓演算法（Midpoint Circle Algorithm）

利用圓的 八向對稱性，只需計算第一個八分圓，再映射至其他區域。

核心思想：

起始點 (x, y) = (0, r)，決策變數：

d = 1 - r


每次 x 增加 1：

若 d < 0 → 選東像素，d += 2x + 1

否則 → 選東南像素，y-- 並 d += 2(x - y) + 1

利用 plot8(xc, yc, x, y) 一次畫八個對稱點：

(±x, ±y) 與 (±y, ±x)


當 x ≥ y 時停止。

優點：

不使用三角函數

僅整數加減運算

對稱繪製效率高

🟠 3. 畫橢圓演算法（Midpoint Ellipse Algorithm）

與畫圓類似，但橢圓在 x、y 方向半徑不同，需分兩區域處理斜率。

區域劃分：

區域 1（|dy/dx| < 1）：x 增 1 為主，決策變數 p1 控制 y 是否減少

區域 2（|dy/dx| ≥ 1）：y 減 1 為主，決策變數 p2 控制 x 是否增加

核心變數：
rx2 = rx²
ry2 = ry²
twoRx2 = 2*rx²
twoRy2 = 2*ry²

區域 1 初始：
x = 0
y = ry
p1 = ry² - rx²*ry + (1/4)*rx²

區域 1 更新：
x++
if p1 < 0:
  p1 += ry² + 2x*ry²
else:
  y--
  p1 += ry² + 2x*ry² - 2y*rx²

區域 2 初始：
p2 = ry²*(x+0.5)² + rx²*(y-1)² - rx²*ry²

區域 2 更新：
y--
if p2 > 0:
  p2 += rx² - 2y*rx²
else:
  x++
  p2 += rx² - 2y*rx² + 2x*ry²


每次更新後利用 plot4() 同步繪製四象限對稱點 (±x, ±y)。

🧭 4. 三次 Bézier 曲線（Cubic Bézier Curve）

採用 De Casteljau 演算法 計算參數 t ∈ [0,1] 對應的曲線點。

核心步驟：

對控制點 p0, p1, p2, p3：

線性內插：

p01 = lerp(p0, p1, t)
p12 = lerp(p1, p2, t)
p23 = lerp(p2, p3, t)


二階：

p012 = lerp(p01, p12, t)
p123 = lerp(p12, p23, t)


三階：

point = lerp(p012, p123, t)


依據幾何長度決定取樣數，逐點連線或打點繪製曲線。

📌 小結
圖形	演算法	對稱性	特點
線	Bresenham/Midpoint	無	高效整數法，適用所有斜率
圓	Midpoint Circle	8 向	利用對稱，整數運算快速
橢圓	Midpoint Ellipse	4 向	分區域控制斜率，精確對稱繪製
Bézier 曲線	De Casteljau	N/A	穩定、可漸進細分，適合動畫與曲線繪製

<img width="353" height="239" alt="painting" src="https://github.com/user-attachments/assets/1a7c727b-407b-411d-a825-a16c7b36cc2c" />
