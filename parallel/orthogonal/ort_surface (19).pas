program ort_surface;
// реализация wire-frame рендера
// прямоугольная изометрия поверхности
// © Мыцких-Коробанов А. Ю., 2017

uses
  geom_obj;
  
function fun(x, y: real): real;
// исследуемая функция (эллиптический параболоид)
begin
  fun := cos(sqrt(sqr(x)+sqr(y)));
end;

begin
  wind(400, 400, 'Прямоугольная изометрия поверхности');
  ort_proj_sys(150, 150, 150, -1, -1, -1);
  draw_surface(0, 0, 0, 0, 0, 0, 8, 8, 8, fun, -10, 10, -10, 10, 1, 1);
end.
