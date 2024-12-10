import 'dart:io';

var result = 0;
void main() async {
  try {
    var isExample = false;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;

    List<List<int>> board = text.split('\n').map((line) => line.split('').map((v) => int.parse(v)).toList()).toList();
    List<Point> initialPositions = findTrailInitialPositions(board);
    initialPositions.forEach((initialPosition) =>
        moveOnTrail(initialPosition, board, board[0].length, board.length, 0, initialPosition, initialPosition));

    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

void moveOnTrail(Point position, List<List<int>> board, maxX, int maxY, int value, Point prev, Point initialPosition) {
  var x = position.x;
  var y = position.y;

  var possibleMoves = [
    Point(x - 1, y),
    Point(x + 1, y),
    Point(x, y - 1),
    Point(x, y + 1),
  ];

  possibleMoves
      .where((move) => !(move.x == prev.x && move.y == prev.y))
      .where((move) => move.x >= 0 && move.y >= 0 && move.x < maxX && move.y < maxY) // in board
      .where((move) => board[move.y][move.x] == value + 1)
      .forEach((move) {
    if (board[move.y][move.x] == 9) {
      result++;
    } else {
      moveOnTrail(move, board, maxX, maxY, board[move.y][move.x], position, initialPosition);
    }
  });
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  String toString() => '($x,$y)';
}

List<Point> findTrailInitialPositions(List<List<int>> board) {
  List<Point> positions = [];
  for (var i = 0; i < board.length; i++) {
    var line = board[i];
    for (var j = 0; j < line.length; j++) {
      if (line[j] == 0) {
        positions.add(Point(j, i));
      }
    }
  }
  return positions;
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
