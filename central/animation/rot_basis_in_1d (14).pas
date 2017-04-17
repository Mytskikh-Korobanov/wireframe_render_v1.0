program rot_basis_in_1d;
// вращение базиса вокруг одной оси
// © Мыцких-Коробанов А. Ю., 2017

uses
  geom_obj, GraphABC, ABCObjects, Timers {привязка к PascalABC};

var
  count: real;

begin
  wind(400, 400, 'Вращение базиса вокруг одной оси');
  camera(150, 150, 150, pi/4, 1, 2, -1, -1, -1);
  LockDrawingObjects;
  LockDrawing;
  count := 0;
  while true do
  begin
    draw_basis(0, 0, 0, 0, 0, count, 1, 1, 1, 50, 50, 50);
    count := count + pi/16;
    RedrawObjects;
    Sleep(200);
    window.Clear;
  end;
end.
