import 'dart:io';

var area = 0;
var perimeter = 0;
var result = 0;

// 140 - debug
// 772 - holes
// 1930 - example

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
        perimeter = 0;
        floodTheField(garden, visited, garden[y][x], Point(x, y));
        // printBoolBoard(visited);
        // print(area);
        // print(perimeter);
        // print('----------------');
        result += area * perimeter;
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

void floodTheField(List<List<dynamic>> garden, List<List<bool>> visited, String currentPlant, Point current) {
  visited[current.y][current.x] = true;
  var x = current.x;
  var y = current.y;

  var possibleMoves = [
    Point(x - 1, y),
    Point(x + 1, y),
    Point(x, y - 1),
    Point(x, y + 1),
  ];

  var noPerimeterMoves = possibleMoves
      .where((move) => move.x >= 0 && move.y >= 0 && move.x < garden[0].length && move.y < garden.length)
      .where((move) => garden[move.y][move.x] == currentPlant);

  possibleMoves
      .where((move) => move.x >= 0 && move.y >= 0 && move.x < garden[0].length && move.y < garden.length) // In Board
      .where((move) => garden[move.y][move.x] == currentPlant) // Within plant
      .where((move) => visited[move.y][move.x] == false) // Not visited
      .forEach((move) {
    floodTheField(garden, visited, currentPlant, Point(move.x, move.y));
  });

  perimeter += (4 - noPerimeterMoves.length);
  area++;
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
