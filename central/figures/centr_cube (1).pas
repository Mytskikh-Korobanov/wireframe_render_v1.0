program centr_cube_near;
// реализация центрального проецирования куба вблизи
// © Мыцких-Коробанов А. Ю., 2017

uses
  geom_obj;

begin
  wind(400, 400, 'Центральное проекцирование куба (близко)');
  camera(150, 150, 150, pi/4, 1, 2, -1, -1, -1);
  draw_cube(0, 0, 0, 0, 0, 0, 1, 1, 1, 100);
end.