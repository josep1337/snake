# snake
program Snake;

uses GraphABC, Utils;

const
  WIDTH = 600;
  HEIGHT = 600;
  CELL_SIZE = 20;
  MAX_X = WIDTH div CELL_SIZE;
  MAX_Y = HEIGHT div CELL_SIZE;

type
  Direction = (Left, Right, Up, Down);

var
  snake: array [1..100] of Point;
  snakeLength, score: integer;
  food: Point;
  direction: Direction;
  gameOver: boolean;

procedure DrawCell(p: Point; color: Color);
begin
  Brush.Color := color;
  FillRect(p.x * CELL_SIZE, p.y * CELL_SIZE, (p.x + 1) * CELL_SIZE, (p.y + 1) * CELL_SIZE);
end;

procedure DrawSnake;
var
  i: integer;
begin
  for i := 1 to snakeLength do
    DrawCell(snake[i], clGreen);
end;

procedure MoveSnake;
var
  i: integer;
begin
  // Move the snake body
  for i := snakeLength downto 2 do
    snake[i] := snake[i - 1];
  
  // Move the snake head in the current direction
  case direction of
    Left: Dec(snake[1].x);
    Right: Inc(snake[1].x);
    Up: Dec(snake[1].y);
    Down: Inc(snake[1].y);
  end;
  
  // Check if the snake hit the wall
  if (snake[1].x < 0) or (snake[1].x >= MAX_X) or (snake[1].y < 0) or (snake[1].y >= MAX_Y) then
    gameOver := True;
  
  // Check if the snake hit itself
  for i := 2 to snakeLength do
    if (snake[i].x = snake[1].x) and (snake[i].y = snake[1].y) then
      gameOver := True;
  
  // Check if the snake ate the food
  if (snake[1].x = food.x) and (snake[1].y = food.y) then
  begin
    Inc(snakeLength);
    snake[snakeLength] := snake[snakeLength - 1];
    Inc(score);
    GenerateFood;
  end;
end;

procedure DrawFood;
begin
  DrawCell(food, clRed);
end;

procedure GenerateFood;
begin
  repeat
    food.x := Random(MAX_X);
    food.y := Random(MAX_Y);
  until not SnakeIntersects(food);
end;

procedure DrawScore;
begin
  SetFontSize(20);
  TextOut(10, 10, 'Score: ' + score);
end;

procedure UpdateScreen;
begin
  ClearWindow;
  DrawSnake;
  DrawFood;
  DrawScore;
end;

procedure GameLoop;
begin
  while not gameOver do
  begin
    MoveSnake;
    UpdateScreen;
    Sleep(100);
  end;
end;

procedure InitGame;
begin
  // Initialize the snake
  snake[1] := Point.Create(MAX_X div 2, MAX_Y div 2);
  snake[2] := Point.Create(snake[1].x - 1, snake[1].y);
  snake[3] := Point.Create(snake[1].x - 2, snake[1].y);
  snakeLength := 3;
  
  // Initialize the food
  GenerateFood;
  
  // Initialize the game state
  score := 0;
  gameOver := False;
 
