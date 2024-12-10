import 'dart:io';

void main() async {
  try {
    var isExample = false;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;
    var result = 0;

    List<List<String>> board =
        text.split('\n').map((line) => line.split('').toList()).toList();
    Map<String, List<Point>> antennasMap = {};
    List<Point> antinodes = [];
    var antennaRegExp = RegExp('[a-zA-Z0-9]');

// Build antennas map
    for (var y = 0; y < board.length; y++) {
      for (var x = 0; x < board[0].length; x++) {
        var field = board[y][x];
        if (antennaRegExp.hasMatch(field)) {
          if (antennasMap[field] == null) {
            antennasMap[field] = [Point(x, y)];
          } else {
            antennasMap[field]!.add(Point(x, y));
          }
        }
      }
    }
// Go through pairs and produce antinodes
    antennasMap.values.forEach((list) {
      for (var i = 0; i < list.length - 1; i++) {
        antinodes.add(list[i]);
        for (var j = i + 1; j < list.length; j++) {
          var first = list[i];
          var second = list[j];
          var diff = Point(first.x - second.x, first.y - second.y);

          var currX = first.x;
          var currY = first.y;
          while (currX + diff.x >= 0 &&
              currY + diff.y >= 0 &&
              currX + diff.x < board[0].length &&
              currY + diff.y < board.length) {
            var newNode = Point(currX + diff.x, currY + diff.y);
            antinodes.add(newNode);
            currX += diff.x;
            currY += diff.y;
          }

          currX = second.x;
          currY = second.y;
          while (currX - diff.x >= 0 &&
              currY - diff.y >= 0 &&
              currX - diff.x < board[0].length &&
              currY - diff.y < board.length) {
            var newNode = Point(currX - diff.x, currY - diff.y);
            antinodes.add(newNode);
            currX -= diff.x;
            currY -= diff.y;
          }
        }
      }
      ;
      antinodes.add(list[list.length - 1]);
    });

    // Find distinct Points
    var distinctAntinodes = antinodes
        .map((node) => node.toString())
        .toSet()
        .map((strNode) => fromString(strNode))
        .toList();

    result = distinctAntinodes.length;
    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  String toString() => '$x,$y';
  Point fromString(String stringPoint) => Point(
      int.parse(stringPoint.split(',')[0]),
      int.parse(stringPoint.split(',')[1]));
}

Point fromString(String stringPoint) {
  var parsed = stringPoint.split(',');
  return Point(int.parse(parsed[0]), int.parse(parsed[1]));
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
