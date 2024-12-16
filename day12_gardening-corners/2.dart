import 'dart:io';

var area = 0;
var sides = 0;
var result = 0;

// 80 - debug CHECKED
// 436 - holes CHECKED
// 236 - E CHECKED
// 368 - AB CHECKED
// 1206 - example CHECKED

// NO NEI -> +4 SIDES
// 1 NEI -> +3 SIDES

void main() async {
  try {
    var isExample = false;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;
    List<List<dynamic>> garden = text.split('\n').map((line) => line.split('')).toList();
    List<List<bool>> visited = text.split('\n').map((line) => line.split('').map((e) => false).toList()).toList();
    goThroughGarden(garden, visited);
    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

void goThroughGarden(List<List<dynamic>> garden, List<List<bool>> visited) {
  for (var y = 0; y < garden.length; y++) {
    for (var x = 0; x < garden[0].length; x++) {
      if (visited[y][x] == false) {
        area = 0;
        sides = 0;
        List<Point> perimeterEdgePoints = [];
        floodTheField(garden, visited, garden[y][x], Point(x, y), perimeterEdgePoints);
        // print(garden[y][x] + ' Area: ' + area.toString() + ' Sides: ' + sides.toString());
        result += area * sides;
      }
    }
  }
}

void printBoolBoard(List<List<bool>> board) {
  print(board.map((line) => line.map((e) => e ? 'X' : 'O').join('')).join(('\n')));
}

void printBoard(List<List<String>> board) {
  print(board.map((line) => line.join('')).join(('\n')));
}

void floodTheField(List<List<dynamic>> garden, List<List<bool>> visited, String currentPlant, Point current,
    List<Point> perimeterEdgePoints) {
  visited[current.y][current.x] = true;
  var x = current.x;
  var y = current.y;

  var possibleMoves = [
    Point(x - 1, y),
    Point(x + 1, y),
    Point(x, y - 1),
    Point(x, y + 1),
  ];
  possibleMoves
      .where((move) => move.x >= 0 && move.y >= 0 && move.x < garden[0].length && move.y < garden.length) // In Board
      .where((move) => garden[move.y][move.x] == currentPlant) // Within plant
      .where((move) => visited[move.y][move.x] == false) // Not visited
      .forEach((move) {
    floodTheField(garden, visited, currentPlant, Point(move.x, move.y), perimeterEdgePoints);
  });

  sides += countCorners(garden, current);
  area++;
}

int countCorners(List<List<dynamic>> board, Point current) {
  var curValue = board[current.y][current.x];
  var corners = [
    [
      Point(current.x - 1, current.y),
      Point(current.x - 1, current.y - 1),
      Point(current.x, current.y - 1),
    ],
    [
      Point(current.x, current.y - 1),
      Point(current.x + 1, current.y - 1),
      Point(current.x + 1, current.y),
    ],
    [
      Point(current.x + 1, current.y),
      Point(current.x + 1, current.y + 1),
      Point(current.x, current.y + 1),
    ],
    [
      Point(current.x, current.y + 1),
      Point(current.x - 1, current.y + 1),
      Point(current.x - 1, current.y),
    ]
  ];

  var cornersCount = 0;

  corners.forEach((corner) {
    var first = corner[0];
    var diagonal = corner[1];
    var third = corner[2];

    var firstValue = safeValue(board, first);
    var diagonalValue = safeValue(board, diagonal);
    var thirdValue = safeValue(board, third);

    if (firstValue != curValue && thirdValue != curValue) {
      cornersCount++;
    }
    if (firstValue == curValue && diagonalValue != curValue && thirdValue == curValue) {
      cornersCount++;
    }
  });

  return cornersCount;
}

dynamic safeValue(List<List<dynamic>> board, Point current) {
  if (current.x >= board[0].length || current.y >= board.length || current.x < 0 || current.y < 0) {
    return null;
  }
  return board[current.y][current.x];
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  String toString() => '($x,$y)';
}

Future<String> loadExample() async {
  const filePath = './example-1.txt';
  return await loadFile(filePath);
}

Future<String> loadProblem() async {
  const filePath = './problem-1.txt';
  return await loadFile(filePath);
}

Future<String> loadFile(filePath) async {
  try {
    var file = File(filePath);
    var text = await file.readAsString();
    return text;
  } catch (e) {
    print('Error reading file: $e');
  }

  return "";
}
