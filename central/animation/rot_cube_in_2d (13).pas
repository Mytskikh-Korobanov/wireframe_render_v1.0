program rot_cube_in_2d;
// вращение куба по двум осям
// © Мыцких-Коробанов А. Ю., 2017

uses
  geom_obj, GraphABC, Timers {привязка к PascalABC};

var
  count: real;

begin
  wind(400, 400, 'Вращение куба по двум осям');
  camera(150, 150, 150, pi/4, 1, 2, -1, -1, -1);
  LockDrawing;
  count := 0;
  while true do
  begin
    draw_cube(0, 0, 0, 0, count, count, 1, 1, 1, 100);
    count := count + pi/16;
    Redraw;
    Sleep(200);
    window.Clear;
  end;
end.
