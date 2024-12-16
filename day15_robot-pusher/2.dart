import 'dart:io';

void main() async {
  try {
    var isExample = false;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;
    var result = 0;
    var parts = text.split('\n\n');
    var boardStr = parts[0];
    var movesStr = parts[1];
    Map<String, String> doublingMap = {
      "#": '##',
      "O": '[]',
      ".": '..',
      "@": '@.',
    };
    List<List<String>> board = boardStr
        .split('\n')
        .map((line) => line.split('').map((char) => (doublingMap[char] as String)).join('').split(''))
        .toList();
    List<String> moves = movesStr.split('\n').join('').split('');

    Point robot = findRobotInitialPosition(board);

// MOVE - DONE - with bugs
    moveRobot(board, robot, moves);

// RESULT - DONE
    for (var y = 0; y < board.length; y++) {
      for (var x = 0; x < board[0].length; x++) {
        if (board[y][x] == '[') {
          result += 100 * y + x;
        }
      }
    }
    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

Point findRobotInitialPosition(List<List<String>> board) {
  for (var i = 0; i < board.length; i++) {
    var line = board[i];
    for (var j = 0; j < line.length; j++) {
      if (line[j] == '@') {
        return Point(j, i);
      }
    }
  }
  return Point(-1, -1);
}

void moveRobot(List<List<String>> board, Point start, List<String> moves) async {
  board[start.y][start.x] = '.';
  Map<String, Point> movesMap = {
    '>': Point(1, 0),
    'v': Point(0, 1),
    '<': Point(-1, 0),
    '^': Point(0, -1),
  };
  Point currentRobotPosition = Point(start.x, start.y);

  moves.forEach((move) {
    // print('Move: ' + '\x1B[31m$move\x1B[0m');
    Point posChange = movesMap[move] as Point;
    Point posCandidate = Point(currentRobotPosition.x + posChange.x, currentRobotPosition.y + posChange.y);
    if (posCandidate.x >= 0 &&
        posCandidate.y >= 0 &&
        posCandidate.x < board[0].length &&
        posCandidate.y < board.length) {
      if (board[posCandidate.y][posCandidate.x] == '.') {
        currentRobotPosition = Point(posCandidate.x, posCandidate.y);
      }
      if (board[posCandidate.y][posCandidate.x] == '[' || board[posCandidate.y][posCandidate.x] == ']') {
        if (move == '^' || move == 'v') {
          Map<int, Set<int>> toBeMoved = {};
          var canMove = checkIfCanMove(board, toBeMoved, currentRobotPosition, posChange);
          if (canMove) {
            // print(toBeMoved);
            List<int> rowsToMove = toBeMoved.keys.toList();
            rowsToMove.sort((a, b) => move == '^' ? a.compareTo(b) : b.compareTo(a));
            rowsToMove.forEach((y) {
              var rowToMove = toBeMoved[y];
              if (rowToMove != null) {
                rowToMove.forEach((x) {
                  board[y + posChange.y][x + posChange.x] = board[y][x];
                  board[y][x] = '.';
                });
              }
            });

            board[currentRobotPosition.y][currentRobotPosition.x] = '.';
            currentRobotPosition = posCandidate;
          }
        } else if (move == '<' || move == '>') {
          List<Point> boxesToMove = [];
          var isBox = true;
          var i = 0;
          while (isBox) {
            var checkedTile = Point(posCandidate.x + i * posChange.x, posCandidate.y + i * posChange.y);
            if (board[checkedTile.y][checkedTile.x] == '.') {
              isBox = false;
            }
            if (board[checkedTile.y][checkedTile.x] == '#') {
              isBox = false;
              boxesToMove = [];
            }
            if (board[checkedTile.y][checkedTile.x] == '[' || board[checkedTile.y][checkedTile.x] == ']') {
              isBox = true;
              boxesToMove.add(Point(checkedTile.x, checkedTile.y));
            }
            i++;
          }

          if (boxesToMove.length > 0) {
            var firstBox = boxesToMove[0];
            board[firstBox.y][firstBox.x] = '.';
            currentRobotPosition = Point(posCandidate.x, posCandidate.y);

            var lastBox = boxesToMove[boxesToMove.length - 1];
            boxesToMove.forEach((box) => board[box.y][box.x] = board[box.y][box.x] == '[' ? ']' : '[');
            var afterLastBox = Point(lastBox.x + posChange.x, lastBox.y + posChange.y);
            board[afterLastBox.y][afterLastBox.x] = board[lastBox.y][lastBox.x] == '[' ? ']' : '[';
          }
        }
      }
    }
    board[currentRobotPosition.y][currentRobotPosition.x] = '.';
    // printBoard(board, currentRobotPosition, move);
  });
  // printBoard(board, currentRobotPosition);
}

bool checkIfCanMove(List<List<String>> board, Map<int, Set<int>> toBeMoved, Point currChecked, Point posChange) {
  Point posCandidate = Point(currChecked.x + posChange.x, currChecked.y + posChange.y);
  if (board[posCandidate.y][posCandidate.x] == '[') {
    var canMoveUp = checkIfCanMove(board, toBeMoved, posCandidate, posChange); // up
    var canMoveUpRight =
        checkIfCanMove(board, toBeMoved, Point(posCandidate.x + 1, posCandidate.y), posChange); // up right
    var canMove = canMoveUp && canMoveUpRight;
    if (canMove) {
      if (toBeMoved[currChecked.y] == null) {
        toBeMoved[currChecked.y] = Set();
      }
      toBeMoved[currChecked.y]?.add(currChecked.x);
    }
    return canMove;
  }
  if (board[posCandidate.y][posCandidate.x] == ']') {
    var canMoveUp = checkIfCanMove(board, toBeMoved, posCandidate, posChange); // up
    var canMoveUpLeft =
        checkIfCanMove(board, toBeMoved, Point(posCandidate.x - 1, posCandidate.y), posChange); // up left
    var canMove = canMoveUp && canMoveUpLeft;
    if (canMove) {
      if (toBeMoved[currChecked.y] == null) {
        toBeMoved[currChecked.y] = Set();
      }
      toBeMoved[currChecked.y]?.add(currChecked.x);
    }
    return canMove;
  }
  if (board[posCandidate.y][posCandidate.x] == '#') {
    toBeMoved[currChecked.y] = Set();
    return false;
  }

  if (board[posCandidate.y][posCandidate.x] == '.') {
    if (toBeMoved[currChecked.y] == null) {
      toBeMoved[currChecked.y] = Set();
    }
    toBeMoved[currChecked.y]?.add(currChecked.x);
    return true;
  }

  return true;
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  String toString() => '($x,$y)';
}

void printBoard(List<List<String>> board, Point robot, String move) {
  board[robot.y][robot.x] = '🤖';
  var boardStr = board.map((line) => line.join('')).join(('\n'));
  print(boardStr);
  board[robot.y][robot.x] = '.';
  print('\n');
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
