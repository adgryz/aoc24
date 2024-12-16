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
    List<List<String>> board = boardStr.split('\n').map((line) => line.split('')).toList();
    List<String> moves = movesStr.split('\n').join('').split('');
    Point robot = findRobotInitialPosition(board);
    moveRobot(board, robot, moves);

    for (var y = 0; y < board.length; y++) {
      for (var x = 0; x < board[0].length; x++) {
        if (board[y][x] == 'O') {
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

void moveRobot(List<List<String>> board, Point start, List<String> moves) {
  board[start.y][start.x] = '.';
  Map<String, Point> movesMap = {
    '>': Point(1, 0),
    'v': Point(0, 1),
    '<': Point(-1, 0),
    '^': Point(0, -1),
  };
  Point currentRobotPosition = Point(start.x, start.y);
  moves.forEach((move) {
    // print(move);

    Point posChange = movesMap[move] as Point;
    Point posCandidate = Point(currentRobotPosition.x + posChange.x, currentRobotPosition.y + posChange.y);
    if (posCandidate.x >= 0 &&
        posCandidate.y >= 0 &&
        posCandidate.x < board[0].length &&
        posCandidate.y < board.length) {
      if (board[posCandidate.y][posCandidate.x] == '.') {
        currentRobotPosition = Point(posCandidate.x, posCandidate.y);
      }
      if (board[posCandidate.y][posCandidate.x] == 'O') {
        // move boxes
        // print('TRYNA MOVE BOX');
        List<Point> boxesToMove = [];
        var isBox = true;
        var i = 0;
        while (isBox) {
          var checkedTile = Point(posCandidate.x + i * posChange.x, posCandidate.y + i * posChange.y);
          // print('Checked ' + checkedTile.toString());
          if (board[checkedTile.y][checkedTile.x] == '.') {
            // print('Ok we move ' + checkedTile.toString());
            isBox = false;
          }
          if (board[checkedTile.y][checkedTile.x] == 'O') {
            // print('Added box ' + checkedTile.toString());
            isBox = true;
            boxesToMove.add(Point(checkedTile.x, checkedTile.y));
          }
          if (board[checkedTile.y][checkedTile.x] == '#') {
            // print('We dont move ' + checkedTile.toString());
            isBox = false;
            boxesToMove = [];
          }
          i++;
        }
        // print(boxesToMove);
        if (boxesToMove.length > 0) {
          var firstBox = boxesToMove[0];
          board[firstBox.y][firstBox.x] = '.'; // empty in place of first
          currentRobotPosition = Point(posCandidate.x, posCandidate.y); // we can move if box is moved

          var lastBox = boxesToMove[boxesToMove.length - 1];
          var afterLastBox = Point(lastBox.x + posChange.x, lastBox.y + posChange.y);
          board[afterLastBox.y][afterLastBox.x] = 'O'; // box in place of one move after last
        }
      }
      if (board[posCandidate.y][posCandidate.x] != '#') {
        // HIT WALL DO NOTHING
      }
    }

    // printBoard(board, current);
    // print('\n');
  });
}
// ########
// #..O.O.#
// ##@.O..#
// #...O..#
// #.#.O..#
// #...O..#
// #......#
// ########

// <^^>>>vv<v>>v<<

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  String toString() => '($x,$y)';
}

void printBoard(List<List<String>> board, Point robot) {
  board[robot.y][robot.x] = '@';
  print(board.map((line) => line.join('')).join(('\n')));
  board[robot.y][robot.x] = '.';
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
