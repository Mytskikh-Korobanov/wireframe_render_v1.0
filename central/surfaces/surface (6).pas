program surface;
// реализация wire-frame рендера
// построение поверхности функции
// © Мыцких-Коробанов А. Ю., 2017

uses
  geom_obj;

function fun(x, y: real): real;
// исследуемая функция
begin
  fun := cos(sqrt(sqr(x)+sqr(y)));
end;

begin
  wind(400, 400, 'Wire-frame рендер');
  camera(1750, 1750, 1750, pi/256, 1, 2, -1, -1, -1);
  draw_surface(0, 0, 0, 0, 0, pi/6, 1, 1, 1, fun, -10, 10, -10, 10, 1, 1);
end.
