program plane;
// реализация wire-frame рендера
// построение плоскости
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
