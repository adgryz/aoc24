import 'dart:io';

const examplePath = './example-1.txt';
const problemPath = './problem-1.txt';

void main() async {
  try {
    var isExample = false;
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
    board[guardY][guardX] = 'U';

    result = goThroughAllBoards(board, guardX, guardY, guardDirection);
    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

int goThroughAllBoards(List<List<String>> board, int initialGuardX,
    int initialGuardY, String initialDirection) {
  var loopsCount = 0;
  for (var i = 0; i < board.length; i++) {
    for (var j = 0; j < board[0].length; j++) {
      var boardCopy = copyBoard(board);
      if (board[i][j] == '.' && !(i == initialGuardY && j == initialGuardX)) {
        boardCopy[i][j] = '#';
        // var boardPrintCopy = copyBoard(boardCopy);
        // boardPrintCopy[i][j] = 'O';
        var isInLoop = checkIfGuardianInLoop(
            boardCopy, initialGuardX, initialGuardY, initialDirection);
        if (isInLoop) {
          loopsCount++;
        }
      }
    }
  }

  return loopsCount;
}

List<List<String>> copyBoard(List<List<String>> board) {
  return board.map((innerList) => List<String>.from(innerList)).toList();
}

void printBoard(List<List<String>> board) {
  print(board.map((line) => line.join('')).join(('\n')));
}

bool checkIfGuardianInLoop(List<List<String>> board, int initialGuardX,
    int initialGuardY, String initialDirection) {
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
  board[guardY][guardX] = initialDirection;

  var yModifier = 0;
  var xModifier = 0;
  while (guardY + yModifier >= 0 &&
      guardX + xModifier >= 0 &&
      guardY + yModifier < boardHeight &&
      guardX + xModifier < boardWidth) {
    yModifier = directionMap[direction]?["y"] ?? 0;
    xModifier = directionMap[direction]?["x"] ?? 0;

    // Check for direction change
    if (board[guardY + yModifier][guardX + xModifier] == '#') {
      direction = directionChangeMap[direction] ?? "";
      // print('Change dir to ' + direction);
    }

    yModifier = directionMap[direction]?["y"] ?? 0;
    xModifier = directionMap[direction]?["x"] ?? 0;
    // Do a move and 'save' it on the map as direction
    if (board[guardY + yModifier][guardX + xModifier] != '#') {
      guardY += yModifier;
      guardX += xModifier;

      // IF there is already our direction here - that means that it is a loop
      if (board[guardY][guardX].contains(direction)) {
        return true;
      }

      board[guardY][guardX] += direction;

      // print('New position ' + guardX.toString() + " " + guardY.toString());
    }
  }

  return false;
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
  return await loadFile(examplePath);
}

Future<String> loadProblem() async {
  return await loadFile(problemPath);
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
