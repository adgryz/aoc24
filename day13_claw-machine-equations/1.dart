import 'dart:io';

// A - costs 3
// B - costs 1
// MAX 100 presses on button per prize
// AX AY BX BY
// c*AX + d*BX = X
// c*AY + d*BY = Y

// 1ST
// 80*94 + 40*22 = 8400
// 80*34 + 40*67 = 5400
// 80*3  + 40*1  = 280

// 2ND
// X

// 3RD
// 38,86,200

//  What is the fewest tokens you would have to spend to win all possible prizes?
void main() async {
  try {
    var isExample = false;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;
    var regexp = RegExp(r'\d+');
    var result = 0;
    var lines = text.split('\n').map((line) => regexp.allMatches(line).toList()).toList();
    List<Problem> problems = [];

    for (var i = 0; i < lines.length; i += 4) {
      var aLine = lines[i];
      var bLine = lines[i + 1];
      var prizeLine = lines[i + 2];
      Point A = Point(
        parse(aLine[0]),
        parse(aLine[1]),
      );
      Point B = Point(
        parse(bLine[0]),
        parse(bLine[1]),
      );
      Point Prize = Point(
        parse(prizeLine[0]),
        parse(prizeLine[1]),
      );
      problems.add(Problem(A, B, Prize));
    }

    // problems.forEach((problem) => print(problem));
    problems.map((problem) => solveEquations(problem)).forEach((cost) => result += cost);
    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

int parse(dynamic v) {
  return int.parse(v.group(0) ?? '');
}

int solveEquations(Problem p) {
// c*A.x + d*B.x = Prize.x
// c*A.y + d*B.y = Prize.y

// c*A.x*B.y + d*B.x*B.y = Prize.x*B.y
// -c*A.y*(B.x) - d*B.y*B.x = -Prize.y*B.x

// c(A.x*B.y-A.y*B.x) = Prize.x*B.y-Prize.y*B.x
// d = (Prize.x - c*A.x)/B.x
  var A = p.A;
  var B = p.B;
  var Prize = p.Prize;

  var c = (Prize.x * B.y - Prize.y * B.x) / (A.x * B.y - A.y * B.x);
  var d = (Prize.x - c * A.x) / B.x;
  if (c == c.toInt() && c <= 100 && d == d.toInt() && d <= 100) {
    return 3 * c.toInt() + d.toInt();
  }
  return 0;
  // return Counts(c == c.toInt() ? c.toInt() : -1, d == d.toInt() ? d.floor() : -1);
}

class Problem {
  Point A;
  Point B;
  Point Prize;

  Problem(this.A, this.B, this.Prize);

  @override
  String toString() => 'A:$A, B$B | Prize:$Prize';
}

class Counts {
  int aCount;
  int bCount;

  Counts(this.aCount, this.bCount);

  @override
  String toString() => '($aCount,$bCount)';
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
