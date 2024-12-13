import 'dart:io';

void main() async {
  try {
    var isExample = true;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;
    var lines = text.split('\n');
    List<List<String>> board = lines.map((line) => line.split("")).toList();

    var result = 0;
    var guardInitialPosition = findGuardInitialPosition(board);
    var guardY = guardInitialPosition[0];
    var guardX = guardInitialPosition[1];
    var guardDirection = 'U';

    // print('Starting position ' + guardX.toString() + " " + guardY.toString());
    result = moveGuardUntilOutside(board, guardX, guardY, guardDirection);

    print(result);
  } catch (e) {
    // print('Error reading file: $e');
  }
}

int moveGuardUntilOutside(List<List<String>> board, int initialGuardX, int initialGuardY, String initialDirection) {
  var directionMap = {
    "U": {"x": 0, "y": -1},
    "D": {"x": 0, "y": 1},
    "R": {"x": 1, "y": 0},
    "L": {"x": -1, "y": 0}
  };

  var directionChangeMap = {
    "U": "R",
    "R": "D",
    "D": "L",
    "L": "U",
  };

  var boardHeight = board.length;
  var boardWidth = board[0].length;
  var guardX = initialGuardX;
  var guardY = initialGuardY;
  var direction = initialDirection;
  board[guardY][guardX] = 'X';
  var guardVisitedPlaces = 1;

  var yModifier = 0;
  var xModifier = 0;
  while (guardY + yModifier >= 0 && guardX + xModifier >= 0 && guardY + yModifier < boardHeight && guardX + xModifier < boardWidth) {
    yModifier = directionMap[direction]?["y"] ?? 0;
    xModifier = directionMap[direction]?["x"] ?? 0;

    if (board[guardY + yModifier][guardX + xModifier] == '#') {
      direction = directionChangeMap[direction] ?? "";
      // print('Change dir to ' + direction);
    }

    yModifier = directionMap[direction]?["y"] ?? 0;
    xModifier = directionMap[direction]?["x"] ?? 0;
    var nextPosition = board[guardY + yModifier][guardX + xModifier];
    if (nextPosition == '.' || nextPosition == 'X') {
      guardY += yModifier;
      guardX += xModifier;
      if (board[guardY][guardX] == '.') {
        board[guardY][guardX] = 'X';
        guardVisitedPlaces++;
      }
      // print('New position ' + guardX.toString() + " " + guardY.toString());
    }
  }

  return guardVisitedPlaces;
}

List<int> findGuardInitialPosition(List<List<String>> board) {
  for (var i = 0; i < board.length; i++) {
    var line = board[i];
    for (var j = 0; j < line.length; j++) {
      if (line[j] == '^') {
        return [i, j];
      }
    }
  }
  return [-1, -1];
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
