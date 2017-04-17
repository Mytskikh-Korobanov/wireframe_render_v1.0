program plane;
// реализация wire-frame рендера
// построение плоскости
// © Мыцких-Коробанов А. Ю., 2017

uses
  geom_obj;

function fun(x, y: real): real;
// исследуемая функция (плоскость xOy)
begin
  fun := 0;
end;

begin
  wind(400, 400, 'Плоскость');
  camera(-25, 0, 25, pi/4, 1, 2, 1, 0, -1);
  draw_surface(0, 0, 0, 0, 0, 0, 1, 1, 1, fun, -10, 10, -10, 10, 1, 1);
end.
