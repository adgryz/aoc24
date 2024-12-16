import 'dart:io';

const filePath = './example-1.txt';
// const filePath = './example-2.txt';
// const filePath = './problem-1.txt';

void main() async {
  try {
    var result = 0;
    var results = Set<int>();
    var text = await loadFile();
    var board = readBoard(text);

    Point startPosition = findPoint(board, 'S');
    Point endPosition = findPoint(board, 'E');
    buildPaths(board, startPosition, endPosition, '>', 0, Set(), results, "");
    // print(results);
    result = results.reduce((a, b) => a < b ? a : b);
    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

void buildPaths(List<List<String>> board, Point s, Point e, String orientation, int cost, Set<String> visitedVIDs,
    Set<int> results, String path) {
  var currentVID = getPointVID(s);
  var endVID = getPointVID(e);
  if (currentVID == endVID) {
    results.add(cost);
    // print(cost.toString() + ' Found path: ' + path);
  }

  var moves = [
    Point(-1, 0),
    Point(0, -1),
    Point(0, 1),
    Point(1, 0),
  ];

  Set<String> newVisited = Set.from(visitedVIDs);
  newVisited.add(currentVID);

  moves.forEach((move) {
    var moved = Point(s.x + move.x, s.y + move.y);
    if (moved.x >= 0 &&
        moved.y >= 0 &&
        moved.x < board[0].length &&
        moved.y < board.length &&
        board[moved.y][moved.x] != '#' &&
        !newVisited.contains(getPointVID(moved))) {
      var (rotationCost, newOrientation) = getRotationCost(orientation, s, moved);
      var moveCost = 1;
      var overallCost = moveCost + rotationCost;
      buildPaths(
          board, moved, e, newOrientation, cost + overallCost, newVisited, results, path = path + ' ' + currentVID);
    }
  });
}

(int, String) getRotationCost(String orientation, Point start, Point end) {
  var numberOfRotations = 0;
  var diffX = end.x - start.x;
  var diffY = end.y - start.y;
  var newOrientation = orientation;
  if ((orientation == '<' || orientation == '>') && diffY > 0) {
    numberOfRotations = 1;
    newOrientation = 'v';
  }
  if ((orientation == '<' || orientation == '>') && diffY < 0) {
    numberOfRotations = 1;
    newOrientation = '^';
  }
  if (orientation == '<' && diffX > 0) {
    numberOfRotations = 2;
    newOrientation = '>';
  }
  if (orientation == '>' && diffX < 0) {
    numberOfRotations = 2;
    newOrientation = '<';
  }

  if ((orientation == '^' || orientation == 'v') && diffX > 0) {
    numberOfRotations = 1;
    newOrientation = '>';
  }
  if ((orientation == '^' || orientation == 'v') && diffX < 0) {
    numberOfRotations = 1;
    newOrientation = '<';
  }
  if (orientation == '^' && diffY > 0) {
    numberOfRotations = 2;
    newOrientation = 'v';
  }
  if (orientation == 'v' && diffX < 0) {
    numberOfRotations = 2;
    newOrientation = '^';
  }

  // print(newOrientation + " with cost: " + (1000 * numberOfRotations).toString());
  return (1000 * numberOfRotations, newOrientation);
}

String getPointVID(Point p) {
  var py = p.y;
  var px = p.x;
  return '$py-$px';
}

Point findPoint(List<List<String>> board, String value) {
  for (var i = 0; i < board.length; i++) {
    var line = board[i];
    for (var j = 0; j < line.length; j++) {
      if (line[j] == value) {
        return Point(j, i);
      }
    }
  }
  return Point(-1, -1);
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  String toString() => '($x,$y)';
}

List<List<String>> readBoard(String boardStr) {
  return boardStr.split('\n').map((line) => line.split('')).toList();
}

void printBoard(List<List<String>> board) {
  var boardStr = board.map((line) => line.join('')).join(('\n'));
  print(boardStr);
}

Future<String> loadFile() async {
  try {
    var file = File(filePath);
    var text = await file.readAsString();
    return text;
  } catch (e) {
    print('Error reading file: $e');
  }

  return "";
}
