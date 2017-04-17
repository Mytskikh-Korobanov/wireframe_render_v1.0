program elliptic_paraboloid;
// реализация wire-frame рендера
// построение поверхности эллиптического параболоида
// © Мыцких-Коробанов А. Ю., 2017

uses
  geom_obj;

function fun(x, y: real): real;
// исследуемая функция (эллиптический параболоид)
begin
  fun := (sqr(x) + sqr(y))/2;
end;

begin
  wind(400, 400, 'Эллиптический параболоид');
  camera(1750, 1750, 1750, pi/48, 1, 2, -1, -1, -1);
  draw_surface(0, 0, -30, 0, 0, pi/6, 2, 2, 1, fun, -10, 10, -10, 10, 1, 1);
end.
