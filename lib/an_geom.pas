unit an_geom;
// модуль аналитической геометрии
  
const
  N = 4;
  M = 3;

type
  vector4 = array [1..N] of real;
  vector3 = array [1..M] of real;
  matrix = array [1..N, 1..N] of real;
  
// операции с векторами
function length(a: vector3): real; // длина вектора
var
  i: integer; res: real;
begin
  res := 0;
  for i := 1 to M do
    res := res + sqr(a[i]);
  res := sqrt(res);
  length := res;
end;

function norm(a: vector3): vector3; // нормирование вектора
var
  i: integer; res: vector3;
begin
  for i := 1 to M do
    res[i] := a[i]/length(a);
  norm := res;
end;

function vect_mul(a, b: vector3): vector3; // векторное умножение
var
  res: vector3;
begin
  res[1] := a[2]*b[3] - b[2]*a[3];
  res[2] := b[1]*a[3] - a[1]*b[3];
  res[3] := a[1]*b[2] - b[1]*a[2];
  vect_mul := res;
end;

function transl(a: vector3): vector4; // перевод в однородные координаты
var
  i: integer; res: vector4;
begin
  for i := 1 to M do
    res[i] := a[i];
  res[4] := 1;
  transl := res;
end;

function transl_in3(a: vector4): vector3; // перевод из однородных координат
var
  i: integer; res: vector3;
begin
  for i := 1 to M do
    res[i] := a[i];
  transl_in3 := res;
end;

function mul_sc(l: real; a: vector4): vector4; // скалярное умножение
var
  i: integer; res: vector4;
begin
  for i := 1 to N do
    res[i] := a[i]*l;
  mul_sc := res;
end;

// операции с матрицами
procedure mul_mxm(a, b: matrix; var res: matrix); // умножение матриц
var
  i, j, k: integer;
begin
  for i := 1 to N do
    for j := 1 to N do
    begin
      res[i,j] := 0;
      for k := 1 to N do
        res[i,j] := res[i,j] + a[i,k]*b[k,j]
    end;
end;

procedure mul_vxm(a: vector4; b: matrix; var res: vector4); // умножение вектора на матрицу
var
  i, j: integer;
begin
  for i := 1 to N do
  begin
    res[i] := 0;
    for j := 1 to N do
      res[i] := res[i] + a[j]*b[j,i]
  end;
end;

begin

end.
