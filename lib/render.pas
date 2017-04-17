unit render;
// Модуль для проецирования.
// Поддерживаются центральное и параллельное (косоугольное и прямоугольное)
// виды проецирования.
// Важно: после настройки проецирующей системы необходимо инициализировать
// рендер (для применения параметров)!
// Важно: перед сменой режима проецирования через переменные central и ort
// необходимо, чтобы данный режим был описан (была настроена проецирующая 
// система и был инициализирован рендер после этого)!
// © Мыцких-Коробанов А. Ю., 2017
{
  Это свободная программа: вы можете перераспространять ее и/или изменять
  ее на условиях Стандартной общественной лицензии GNU в том виде, в каком
  она была опубликована Фондом свободного программного обеспечения; либо
  версии 3 лицензии, либо (по вашему выбору) любой более поздней версии.

  Эта программа распространяется в надежде, что она будет полезной,
  но БЕЗО ВСЯКИХ ГАРАНТИЙ; даже без неявной гарантии ТОВАРНОГО ВИДА
  или ПРИГОДНОСТИ ДЛЯ ОПРЕДЕЛЕННЫХ ЦЕЛЕЙ. Подробнее см. в Стандартной
  общественной лицензии GNU.

  Вы должны были получить копию Стандартной общественной лицензии GNU
  вместе с этой программой. Если это не так, см.
  <http://www.gnu.org/licenses/>.
}

interface
uses
  an_geom;

var
  // режимы проецирования
  central: boolean; // если true, то центральное проецирование, иначе - параллельное
  // режимы косоугольного проецирования
  ort: boolean; // если true, то прямоугольное проецирование, иначе - косоугольное
   
/// инициализация окна
procedure size_wind (_width, _height: integer);
/// инициализация рендера (ей должна предшествовать настройка проецирующей 
/// системы (плоскости проекции и направления проецирования или камеры)
procedure init_rend(x, y, z{положение}, rx, ry, rz{поворот вокруг оси},
  sx, sy, sz{масштаб по оси}: real);
/// получение проекции вершины
function proj(x{вершина}: vector3; var res{проекция}: vector3): boolean;
// функция истинна, если вершина отображается на экране,
// иначе - функция ложна
// центральное проецирование
/// настройка камеры
procedure cam_set(x, y, z, _hfov, _near, _far: real; _forward: vector3);
// параллельное проецирование
// косоугольное проецирование
/// настройка проецирующей системы косоугольного проецирования
procedure bevel_proj_sys_set(x, y, z: real; normal{нормаль плоскости проекции,
направленная в сторону объекта}, view{направление проецирования (от объекта
в системе отсчёта проективной системы}: vector3);
// прямоугольное проецирование
/// настройка проецирующей системы прямоугольного проецирования
procedure ort_proj_sys_set(x, y, z: real; normal{нормаль плоскости проекции,
направленная в сторону объекта}: vector3);
  
implementation 
var
  // описание проецирующей системы
  cx, cy, cz {координаты}: real;
  _for{нормаль к плоскости проекции}, up, right: vector3;
  // описание камеры
  near, far{ближняя и дальняя плоскость отсечения}: real;
  hfov, vfov {вертикальный и горизонтальный углы зрения}: real;
  // косоугольное проецирование
  s{направление проецирования}: vector3;
  // описание окна
  height, width {размеры}: integer;
  // вспомогательные переменные
  centr_tr, bevel_tr, ort_tr{преобразования пространства}: matrix;

// переход из локальной системы координат в мировую
procedure  local_cs(x, y, z{положение}, rx, ry, rz{поворот вокруг оси},
  sx, sy, sz{масштаб по оси}: real; var res: matrix);
var
  i, j: integer;
  s, r, t, r1, r2, r3, pr: matrix;
begin
  // инициализация матриц нулями
  for i := 1 to N do
    for j := 1 to N do
      s[i,j] := 0;
  for i := 1 to N do
    for j := 1 to N do
      r[i,j] := 0;
  for i := 1 to N do
    for j := 1 to N do
      t[i,j] := 0;
  for i := 1 to N do
    for j := 1 to N do
      r1[i,j] := 0;
  for i := 1 to N do
    for j := 1 to N do
      r2[i,j] := 0;
  for i := 1 to N do
    for j := 1 to N do
      r3[i,j] := 0;
  // заполнение матрицы масштабирования
  s[1,1] := sx;
  s[2,2] := sy;
  s[3,3] := sz;
  s[4,4] := 1;
  // заполнение матрицы вращения относительно x
  r1[1,1] := 1;
  r1[2,2] := cos(rx);
  r1[2,3] := sin(rx);
  r1[3,2] := -1*sin(rx);
  r1[3,3] := cos(rx);
  r1[4,4] := 1;
  // заполнение матрицы вращения относительно y
  r2[2,2] := 1;
  r2[1,1] := cos(ry);
  r2[1,3] := sin(ry);
  r2[3,1] := -1*sin(ry);
  r2[3,3] := cos(ry);
  r2[4,4] := 1;
  // заполнение матрицы вращения относительно z
  r3[3,3] := 1;
  r3[1,1] := cos(rz);
  r3[1,2] := sin(rz);
  r3[2,1] := -1*sin(rz);
  r3[2,2] := cos(rz);
  r3[4,4] := 1;
  // заполнение матрицы вращения
  mul_mxm(r1, r2, pr);
  mul_mxm(pr, r3, r);
  // заполнение матрицы перемещения
  t[1,1] := 1;
  t[2,2] := 1;
  t[3,3] := 1;
  t[4,4] := 1;
  t[4,1] := x;
  t[4,2] := y;
  t[4,3] := z;
  // формирование матрицы трансформации системы координат
  mul_mxm(s, r, pr);
  mul_mxm(pr, t, res);
end;

procedure cam_set;
var
  up1: vector3;
begin
  central := true;
  cx := x;
  cy := y;
  cz := z;
  near := _near;
  far := _far;
  hfov := _hfov;
  vfov := hfov * height / width;
  _for := _forward;
  // направление вверх в мировой системе координат
  up1[1] := 0;
  up1[2] := 0;
  up1[3] := 1;
  // определение базиса системы координат камеры
  right := vect_mul(up1, _for);
  up := vect_mul(_for, right);
  // нормирование базиса
  _for := norm(_for);
  up := norm(up);
  right := norm(right);
end;

procedure bevel_proj_sys_set;
var
  up1: vector3;
begin
  central := false;
  ort := false;
  cx := x;
  cy := y;
  cz := z;
  _for := normal;
  s := view;
  // направление вверх в мировой системе координат
  up1[1] := 0;
  up1[2] := 0;
  up1[3] := 1;
  // определение базиса проецирующей системы
  right := vect_mul(up1, _for);
  up := vect_mul(_for, right);
  // нормирование базиса
  _for := norm(_for);
  up := norm(up);
  right := norm(right);
end;

procedure ort_proj_sys_set;
var
  f{направление проецирования}: vector3;
begin
  f[1] := 0;
  f[2] := 0;
  f[3] := -1;
  bevel_proj_sys_set(x, y, z, normal, f);
  ort := true;
end;

// общие подпрограммы для всех способов проецирования
// перенос мировой системы координат в систему координат проецирующей системы
procedure proj_sys_cs(var res: matrix);
var
  t, r: matrix; i, j: integer;
begin
  // инициализация матриц нулями
  for i := 1 to N do
    for j := 1 to N do
      t[i,j] := 0;
  for i := 1 to N do
    for j := 1 to N do
      r[i,j] := 0;
  // матрица перемещения мировой системы координат
  t[1,1] := 1;
  t[2,2] := 1;
  t[3,3] := 1;
  t[4,4] := 1;
  t[4,1] := -1*cx;
  t[4,2] := -1*cy;
  t[4,3] := -1*cz;
  // совмещение орт проецирующей системы с ортами мировой системы координат
  r[4,4] := 1;
  for i := 1 to M do
    r[i,1] := right[i];
  for i := 1 to M do
    r[i,2] := up[i];
  for i := 1 to M do
    r[i,3] := _for[i];
  // вычисление матрицы трансформации
  mul_mxm(t, r, res);
end;

procedure init_rend;
var
  m1, m2: matrix;
begin
  local_cs(x, y, z, rx, ry, rz, sx, sy, sz, m1);
  proj_sys_cs(m2);
  if central then mul_mxm(m1, m2, centr_tr)
    else if ort then mul_mxm(m1, m2, ort_tr)
      else mul_mxm(m1, m2, bevel_tr)
end;

function proj;
var
  pr, pr2, pr3, ndc_vect: vector4;
  right, left, bottom, top: real;
  clip, scr, tr: matrix;
  i, j: integer;
begin
  if central
    then
    begin
      mul_vxm(transl(x), centr_tr, pr);
      right := sin(hfov/2) / cos(hfov/2) * near;
      left := -1*right;
      top := sin(vfov/2) / cos(vfov/2) * near;
      bottom := -1*top;
      // формирование матрицы отсечения
      // инициализация матрицы нулями
      for i := 1 to N do
        for j := 1 to N do
          clip[i,j] := 0;
      clip[1,1] := 2 / (right - left);
      clip[2,2] := 2 / (top - bottom);
      clip[3,1] := (left + right) / (right - left);
      clip[3,2] := (top + bottom) / (bottom - top);
      clip[3,3] := (far + near) / (far - near);
      clip[3,4] := 1;
      clip[4,3] := 2*far / (near-far);
      // применение матрицы отсечения
      mul_vxm(pr, clip, pr2);
      // определение видиности вершины
      if (abs(pr2[1]) <= abs(pr2[4])) and (abs(pr2[2]) <= abs(pr2[4]))
        and (abs(pr2[3]) <= abs(pr2[4])) then proj := true
        else proj := false;
      // получение нормализованных координат устройства
      ndc_vect := mul_sc(1/pr2[4], pr2);
      // формирование матрицы перехода из NDC в координаты экрана
      // инициализация матрицы нулями
      for i := 1 to N do
        for j := 1 to N do
          scr[i,j] := 0;
      scr[1,1] := (width - 1) / 2;
      scr[4,1] := (width - 1) / 2;
      scr[2,2] := (1 - height) / 2;
      scr[4,2] := (height - 1) / 2;
      scr[3,3] := 1;
      scr[4,4] := 1;
      // получение экранных координат
      mul_vxm(ndc_vect, scr, pr3);
      res := transl_in3(pr3);
    end
    else
    begin
      // формирование матрицы параллельного проецирования
      // инициализация матрицы нулями
      for i := 1 to N do
        for j := 1 to N do
          tr[i,j] := 0;
      tr[1,1] := 1;
      tr[2,2] := 1;
      tr[3,3] := 1;
      tr[4,4] := 1;
      tr[3,1] := -1*s[1]/s[3];
      tr[3,2] := -1*s[2]/s[3];
      if ort then mul_vxm(transl(x), ort_tr, pr)
        else mul_vxm(transl(x), bevel_tr, pr);
      mul_vxm(pr, tr, pr2);
      pr2[1] := pr2[1] + width/2;
      pr2[2] := height/2 - pr2[2];
      res := transl_in3(pr2);
    end;
end;

procedure size_wind;
begin
  width := _width;
  height := _height;
end;

begin

end.
