import 'dart:io';

// p=0,4 v=3,-3
// p=6,3 v=-1,-3
// p=10,3 v=-1,2
// p=2,0 v=2,-1
// p=0,0 v=1,3
// p=3,0 v=-2,-2
// p=7,6 v=-1,-3
// p=3,0 v=-1,-2
// p=9,3 v=2,3
// p=7,3 v=-1,2
// p=2,4 v=2,-3
// p=9,5 v=-3,-3

void main() async {
  try {
    var isExample = false;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;
    List<Robot> robots = text.split('\n').map((line) {
      var parts = line.split(' ');
      var pCords = parts[0].substring(2).split(',').map((v) => int.parse(v)).toList();
      var vCords = parts[1].substring(2).split(',').map((v) => int.parse(v)).toList();
      Point p = Point(pCords[0], pCords[1]);
      Point v = Point(vCords[0], vCords[1]);
      return Robot(p, v);
    }).toList();

    var W = 101;
    var H = 103;
    // var W = 11;
    // var H = 7;

    for (var i = 0; i < 10000; i++) {
      List<Point> futureRobotPositions =
          robots.map((robot) => calculateFuturePosition(robot.p, robot.v, i, W, H)).toList();
      var hasSquare = checkIfHasSquare(futureRobotPositions, W, H, 3);
      if (hasSquare) {
        printBoard(futureRobotPositions, W, H, i);
      }
    }

    // print(futureRobotPositions);
  } catch (e) {
    print('Error reading file: $e');
  }
}

void printBoard(List<Point> robots, int W, int H, int n) {
  List<List<String>> grid = List.generate(H, (row) => List.generate(W, (col) => '_'));
  robots.forEach((robot) => grid[robot.y][robot.x] = '#');
  var text = grid.map((row) => row.join('')).join('\n');
  var filePath = './s-$n.txt';
  File file = File(filePath);
  file.writeAsString(text);
}

Point calculateFuturePosition(Point currP, Point v, int seconds, int w, int h) {
  Point rawFutureP = Point(currP.x + seconds * v.x, currP.y + seconds * v.y);
  Point teleportedFutureP = Point(rawFutureP.x % w, rawFutureP.y % h);
  return teleportedFutureP;
}

bool checkIfHasSquare(List<Point> robots, int W, int H, int size) {
  List<List<String>> grid = List.generate(H, (row) => List.generate(W, (col) => '_'));
  robots.forEach((robot) => grid[robot.y][robot.x] = '#');

  var hasSquare = false;
  for (var r = 0; r < robots.length; r++) {
    var score = 0;
    var robot = robots[r];
    SquareLoop:
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        if (robot.y + j == H || robot.x + i == W) {
          score = 0;
          break SquareLoop;
        }
        if (grid[robot.y + j][robot.x + i] == '#') {
          score++;
        }
      }
    }

    if (score == size * size) {
      hasSquare = true;
    }
  }

  return hasSquare;
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  String toString() => '($x,$y)';
}

class Robot {
  Point p;
  Point v;

  Robot(this.p, this.v);

  @override
  String toString() => '[p:$p, v:$v]';
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
