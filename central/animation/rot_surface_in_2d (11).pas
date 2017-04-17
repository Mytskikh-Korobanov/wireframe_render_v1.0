program rot_surface_in_2d;
// реализация wire-frame рендера
// вращение поверхности по двум осям
// © Мыцких-Коробанов А. Ю., 2017

uses
  geom_obj, GraphABC, Timers {привязка к PascalABC};

var
  count: real;

function fun(x, y: real): real;
// исследуемая функция (плоскость xOy)
begin
  fun := cos(sqrt(sqr(x)+sqr(y)));
end;

begin
  wind(400, 400, 'Вращение поверхности по двум осям');
  camera(-25, 0, 25, pi/4, 1, 2, 1, 0, -1);
  LockDrawing;
  count := 0;
  while true do
  begin
    draw_surface(0, 0, 0, 0, count, count, 1, 1, 1, fun, -10, 10, -10, 10, 1, 1);
    count := count + pi/16;
    Redraw;
    Sleep(200);
    window.Clear;
  end;
end.
