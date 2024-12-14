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

    var T = 100;
    var W = 101;
    var H = 103;
    // var W = 11;
    // var H = 7;

    List<Point> futureRobotPositions =
        robots.map((robot) => calculateFuturePosition(robot.p, robot.v, T, W, H)).toList();
    var result = calculateQuadrantsValuation(futureRobotPositions, W, H);
    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

Point calculateFuturePosition(Point currP, Point v, int seconds, int w, int h) {
  Point rawFutureP = Point(currP.x + seconds * v.x, currP.y + seconds * v.y);
  Point teleportedFutureP = Point(rawFutureP.x % w, rawFutureP.y % h);
  return teleportedFutureP;
}

int calculateQuadrantsValuation(List<Point> positions, int w, int h) {
  List<int> middleRows =
      h % 2 == 0 ? [(h / 2 - 1).toInt(), (h / 2).toInt()] : [((h - 1) / 2).toInt(), ((h - 1) / 2).toInt()];
  List<int> middleCols =
      w % 2 == 0 ? [(w / 2 - 1).toInt(), (w / 2).toInt()] : [((w - 1) / 2).toInt(), ((w - 1) / 2).toInt()];

  List<Point> q1 = [];
  List<Point> q2 = [];
  List<Point> q3 = [];
  List<Point> q4 = [];

  positions.forEach((p) {
    if (p.x < middleCols[0] && p.y < middleRows[0]) q1.add(p);
    if (p.x < middleCols[0] && p.y > middleRows[1]) q4.add(p);
    if (p.x > middleCols[1] && p.y < middleRows[0]) q2.add(p);
    if (p.x > middleCols[1] && p.y > middleRows[1]) q3.add(p);
  });

  return q1.length * q2.length * q3.length * q4.length;
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
