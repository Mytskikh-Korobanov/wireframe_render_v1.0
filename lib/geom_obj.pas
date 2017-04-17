unit geom_obj;
// модуль для построения геометрических объектов
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

{$F+}
interface
type
  func = function(x, y: real): real;
  
/// построение прямоугольного параллелипипеда
procedure draw_rec_par(x, y, z, rx, ry, rz, sx, sy, sz{система
  координат объекта}, dx, dy, dz{длины сторон}: real);
/// построение куба
procedure draw_cube(x, y, z, rx, ry, rz, sx, sy, sz{система
  координат объекта}, d{длина стороны}: real);
/// построение базиса
procedure draw_basis(x, y, z, rx, ry, rz, sx, sy, sz{система
  координат объекта}, dx, dy, dz{длины сторон}: real);
/// построение поверхности, заданной явной функцией
procedure draw_surface(x, y, z, rx, ry, rz, sx, sy, sz{система
  координат объекта}:real; operation{исследуемая функция}: func;
  x1, x2, y1, y2{границы исследования функции по x и по y}: real;
  ex, ey{точность построения по x и y}: real);
/// установка ширины, высоты и надписи окна
procedure wind(width, height: integer; s: string);
/// настройка камеры
procedure camera(x, y, z, hfov, near, far, forward_x, forward_y, forward_z: real);
/// настройка проецирующей системы косоугольного проецирования
procedure bevel_proj_sys(x, y, z: real; normal_x, normal_y, normal_z
{нормаль плоскости проекции, направленная в сторону объекта}, 
view_x, view_y, view_z{направление проецирования (от объекта
в системе отсчёта проективной системы}: real);
/// настройка проецирующей системы прямоугольного проецирования
procedure ort_proj_sys(x, y, z: real; normal_x, normal_y, normal_z
{нормаль плоскости проекции, направленная в сторону объекта}: real);

implementation
uses
  render, an_geom, GraphABC, ABCObjects; {привязка к PascalABC}
  
var
  ox, oy, oz: ObjectABC; {привязка к PascalABC}
  
procedure draw_rec_par;
var
  vertex{вершины}, tr_vertex{проекции вершин}: array [1..8] of vector3;
  b: boolean;
begin
  init_rend(x, y, z, rx, ry, rz, sx, sy, sz);
  vertex[1][1] := -1*dx/2;
  vertex[1][2] := -1*dy/2;
  vertex[1][3] := -1*dz/2;
  b := proj(vertex[1], tr_vertex[1]);
  vertex[2][1] := -1*dx/2;
  vertex[2][2] := -1*dy/2;
  vertex[2][3] := dz/2;
  b := proj(vertex[2], tr_vertex[2]);
  vertex[3][1] := dx/2;
  vertex[3][2] := -1*dy/2;
  vertex[3][3] := dz/2;
  b := proj(vertex[3], tr_vertex[3]);
  vertex[4][1] := dx/2;
  vertex[4][2] := -1*dy/2;
  vertex[4][3] := -1*dz/2;
  b := proj(vertex[4], tr_vertex[4]);
  vertex[5][1] := -1*dx/2;
  vertex[5][2] := dy/2;
  vertex[5][3] := -1*dz/2;
  b := proj(vertex[5], tr_vertex[5]);
  vertex[6][1] := -1*dx/2;
  vertex[6][2] := dy/2;
  vertex[6][3] := dz/2;
  b := proj(vertex[6], tr_vertex[6]);
  vertex[7][1] := dx/2;
  vertex[7][2] := dy/2;
  vertex[7][3] := dz/2;
  b := proj(vertex[7], tr_vertex[7]);
  vertex[8][1] := dx/2;
  vertex[8][2] := dy/2;
  vertex[8][3] := -1*dz/2;
  b := proj(vertex[8], tr_vertex[8]);
  line(round(tr_vertex[1][1]), round(tr_vertex[1][2]), round(tr_vertex[2][1]), round(tr_vertex[2][2]));
  line(round(tr_vertex[2][1]), round(tr_vertex[2][2]), round(tr_vertex[3][1]), round(tr_vertex[3][2]));
  line(round(tr_vertex[3][1]), round(tr_vertex[3][2]), round(tr_vertex[4][1]), round(tr_vertex[4][2]));
  line(round(tr_vertex[4][1]), round(tr_vertex[4][2]), round(tr_vertex[1][1]), round(tr_vertex[1][2]));
  line(round(tr_vertex[5][1]), round(tr_vertex[5][2]), round(tr_vertex[6][1]), round(tr_vertex[6][2]));
  line(round(tr_vertex[6][1]), round(tr_vertex[6][2]), round(tr_vertex[7][1]), round(tr_vertex[7][2]));
  line(round(tr_vertex[7][1]), round(tr_vertex[7][2]), round(tr_vertex[8][1]), round(tr_vertex[8][2]));
  line(round(tr_vertex[8][1]), round(tr_vertex[8][2]), round(tr_vertex[5][1]), round(tr_vertex[5][2]));
  line(round(tr_vertex[1][1]), round(tr_vertex[1][2]), round(tr_vertex[5][1]), round(tr_vertex[5][2]));
  line(round(tr_vertex[6][1]), round(tr_vertex[6][2]), round(tr_vertex[2][1]), round(tr_vertex[2][2]));
  line(round(tr_vertex[3][1]), round(tr_vertex[3][2]), round(tr_vertex[7][1]), round(tr_vertex[7][2]));
  line(round(tr_vertex[4][1]), round(tr_vertex[4][2]), round(tr_vertex[8][1]), round(tr_vertex[8][2]));
end;

procedure draw_cube;
begin
  draw_rec_par(x, y, z, rx, ry, rz, sx, sy, sz, d, d, d);
end;

procedure draw_basis;
var
  vertex{вершины}, tr_vertex{проекции вершин}: array [1..4] of vector3;
  b: boolean;
begin
  init_rend(x, y, z, rx, ry, rz, sx, sy, sz);
  vertex[1][1] := 0;
  vertex[1][2] := 0;
  vertex[1][3] := 0;
  b := proj(vertex[1], tr_vertex[1]);
  vertex[2][1] := dx;
  vertex[2][2] := 0;
  vertex[2][3] := 0;
  b := proj(vertex[2], tr_vertex[2]);
  vertex[3][1] := 0;
  vertex[3][2] := dy;
  vertex[3][3] := 0;
  b := proj(vertex[3], tr_vertex[3]);
  vertex[4][1] := 0;
  vertex[4][2] := 0;
  vertex[4][3] := dz;
  b := proj(vertex[4], tr_vertex[4]);
  line(round(tr_vertex[1][1]), round(tr_vertex[1][2]), round(tr_vertex[2][1]), round(tr_vertex[2][2]));
  line(round(tr_vertex[1][1]), round(tr_vertex[1][2]), round(tr_vertex[3][1]), round(tr_vertex[3][2]));
  line(round(tr_vertex[1][1]), round(tr_vertex[1][2]), round(tr_vertex[4][1]), round(tr_vertex[4][2]));
  if ox = nil
    then
    begin
      ox := new TextABC(round(tr_vertex[2][1]), round(tr_vertex[2][2]), 10, 'x', clBlack);
      oy := new TextABC(round(tr_vertex[3][1]), round(tr_vertex[3][2]), 10, 'y', clBlack);
      oz := new TextABC(round(tr_vertex[4][1]), round(tr_vertex[4][2])-15, 10, 'z', clBlack);
    end;
  ox.MoveTo(round(tr_vertex[2][1]), round(tr_vertex[2][2]));
  oy.MoveTo(round(tr_vertex[3][1]), round(tr_vertex[3][2]));
  oz.MoveTo(round(tr_vertex[4][1]), round(tr_vertex[4][2])-15);
end;

procedure draw_surface;
var
  vertex{вершины}, tr_vertex{проекции вершин}: array [,] of vector3;
  b: boolean;
  cx, cy: real;
begin
  init_rend(x, y, z, rx, ry, rz, sx, sy, sz);
  setlength(vertex, trunc((x2-x1)/ex)+1, trunc((y2-y1)/ey)+1);
  setlength(tr_vertex, trunc((x2-x1)/ex)+1, trunc((y2-y1)/ey)+1);
  cx := x1;
  while cx <= x2 do
  begin
    cy := y1;
      while cy <= y2 do
      begin
        vertex[trunc((cx-x1)/ex),trunc((cy-y1)/ey)][1] := cx;
        vertex[trunc((cx-x1)/ex),trunc((cy-y1)/ey)][2] := cy;
        vertex[trunc((cx-x1)/ex),trunc((cy-y1)/ey)][3] := operation(cx, cy);
        b := proj(vertex[trunc((cx-x1)/ex),trunc((cy-y1)/ey)], tr_vertex[trunc((cx-x1)/ex),trunc((cy-y1)/ey)]);
        cy := cy + ey;
      end;
    cx := cx + ex;
  end;
  cx := x1 + ex;
  while cx <= x2 do
  begin
    cy := y1;
      while cy <= y2 do
      begin
        line(round(tr_vertex[trunc((cx-x1)/ex),trunc((cy-y1)/ey)][1]), 
          round(tr_vertex[trunc((cx-x1)/ex),trunc((cy-y1)/ey)][2]), 
          round(tr_vertex[trunc((cx-x1-ex)/ex),trunc((cy-y1)/ey)][1]), 
          round(tr_vertex[trunc((cx-x1-ex)/ex),trunc((cy-y1)/ey)][2]));
        cy := cy + ey;
      end;
    cx := cx + ex;
  end;
  cx := x1;
  while cx <= x2 do
  begin
    cy := y1 + ey;
      while cy <= y2 do
      begin
        line(round(tr_vertex[trunc((cx-x1)/ex),trunc((cy-y1)/ey)][1]), 
          round(tr_vertex[trunc((cx-x1)/ex),trunc((cy-y1)/ey)][2]), 
          round(tr_vertex[trunc((cx-x1)/ex),trunc((cy-y1-ey)/ey)][1]), 
          round(tr_vertex[trunc((cx-x1)/ex),trunc((cy-y1-ey)/ey)][2]));
        cy := cy + ey;
      end;
    cx := cx + ex;
  end;
end;

procedure wind;
begin
  size_wind(width, height);
  SetWindowTitle(s);
  SetWindowSize(width, height);
  SetWindowIsFixedSize(true);
  Pen.Color := clCoral;
  SetPenStyle(psSolid);
end;

procedure camera;
var
  f{направление камеры}: vector3;
begin
  f[1] := forward_x;
  f[2] := forward_y;
  f[3] := forward_z;
  cam_set(x, y, z, hfov, near, far, f);
end;

procedure bevel_proj_sys;
var
  n{нормаль}, v{направление проецирования}: vector3;
begin
  n[1] := normal_x;
  n[2] := normal_y;
  n[3] := normal_z;
  v[1] := view_x;
  v[2] := view_y;
  v[3] := view_z;
  bevel_proj_sys_set(x, y, z, n, v);
end;

procedure ort_proj_sys;
var
  n{нормаль}: vector3;
begin
  n[1] := normal_x;
  n[2] := normal_y;
  n[3] := normal_z;
  ort_proj_sys_set(x, y, z, n);
end;

begin
  
end.
