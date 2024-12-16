import 'dart:io';

const MAX_INT = 999999999999;

var MOVES = [
  Point(-1, 0),
  Point(1, 0),
  Point(0, -1),
  Point(0, 1),
];

// const filePath = './example-1.txt';
// const filePath = './example-2.txt';
// const filePath = './example-3.txt';
// const filePath = './example-4.txt'; // 513 they have it wrong ?
// const filePath = './example-5.txt'; // 532 they have it wrong ?
const filePath = './problem-1.txt';
var result = 0;

void main() async {
  try {
    var text = await loadFile();
    List<List<String>> board = readBoard(text);

    Point startPosition = findPoint(board, 'S');
    Point endPosition = findPoint(board, 'E');

    Map<String, List<AdjListNode>> graph = buildWeightedGraph(board);
    Map<String, String> orientationMap = {};
    Map<String, Set<String>> prevMap = {};

    orientationMap[getPointVID(startPosition)] = '>';
    Map<String, int> distances =
        dijkstra(graph, getPointVID(startPosition), getPointVID(endPosition), orientationMap, prevMap);

    List<List<int?>> distancesBoard = [];
    List<List<bool>> goodPaths = [];

    for (var y = 0; y < board.length; y++) {
      distancesBoard.add([]);
      goodPaths.add([]);
      for (var x = 0; x < board[0].length; x++) {
        distancesBoard[y].add(distances[getVID(y, x)]);
        goodPaths[y].add(false);
      }
    }

    floodPaths(distancesBoard, goodPaths, endPosition);
    printBoard(board);
    printBoolBoard(goodPaths);
    // printDistanceBoard(distancesBoard);

    print(result + 1); //END
  } catch (e) {
    print('Error reading file: $e');
  }
}

void floodPaths(List<List<int?>> distancesBoard, List<List<bool>> goodPaths, Point current) {
  MOVES.forEach((move) {
    if (current.y + move.y >= 0 &&
        current.y + move.y < distancesBoard.length &&
        current.x + move.x > 0 &&
        current.x + move.x < distancesBoard[0].length) {
      var movedY = current.y + move.y;
      var movedX = current.x + move.x;
      if (distancesBoard[movedY][movedX] != null && goodPaths[movedY][movedX] != true) {
        var currentDistance = distancesBoard[current.y][current.x];
        var movedDistance = distancesBoard[movedY][movedX];
        if (currentDistance != null && movedDistance != null && (currentDistance > movedDistance)) {
          goodPaths[movedY][movedX] = true;
          result++;
          floodPaths(distancesBoard, goodPaths, Point(movedY, movedX));
        }
        var d = distancesBoard[current.y][current.x];

        // IS JUNCTION T
        if (d != null &&
            distancesBoard[current.y][current.x + 1] == d + 1000 + 1 &&
            (distancesBoard[current.y + 1][current.x] == d - 1 || distancesBoard[current.y - 1][current.x] == d - 1) &&
            distancesBoard[movedY][movedX] == d + 1000 - 1 &&
            goodPaths[movedY][movedX] != true) {
          goodPaths[movedY][movedX] = true;
          result++;
          floodPaths(distancesBoard, goodPaths, Point(movedY, movedX));
        }

        // IS JUNCTION -|
        if (d != null &&
            distancesBoard[current.y - 1][current.x] == d + 1000 + 1 &&
            (distancesBoard[current.y][current.x - 1] == d - 1 || distancesBoard[current.y][current.x + 1] == d - 1) &&
            distancesBoard[movedY][movedX] == d + 1000 - 1 &&
            goodPaths[movedY][movedX] != true) {
          goodPaths[movedY][movedX] = true;
          result++;
          floodPaths(distancesBoard, goodPaths, Point(movedY, movedX));
        }
      }
    }
  });
}

Map<String, List<AdjListNode>> buildWeightedGraph(List<List<String>> board) {
  Map<String, List<AdjListNode>> graph = {};

  for (var y = 0; y < board.length; y++) {
    for (var x = 0; x < board[0].length; x++) {
      if (board[y][x] != '#') {
        MOVES.forEach((move) {
          if (board[y + move.y][x + move.x] != '#') {
            graph[getVID(y, x)] = [...?graph[getVID(y, x)], AdjListNode(getVID(y + move.y, x + move.x), 1)];
          }
        });
      }
    }
  }

  return graph;
}

Map<String, int> dijkstra(Map<String, List<AdjListNode>> graph, String src, String target,
    Map<String, String> orientationMap, Map<String, Set<String>> prevMap) {
  Map<String, int> distance = {};
  graph.keys.forEach((vid) => distance[vid] = MAX_INT);
  distance[src] = 0;
  List<AdjListNode> pq = [];
  pq.add(AdjListNode(src, 0));

  while (pq.length > 0) {
    pq.sort();
    AdjListNode current = pq.first;
    pq.removeAt(0);

    graph[current.vertex]?.forEach((n) {
      var currentDistance = distance[current.vertex] ?? 0;
      var (rotationCost, newOrientation) = getRotationCost(
          orientationMap[current.vertex] ?? '', getPointFromVID(current.vertex), getPointFromVID(n.vertex));
      var nDistance = distance[n.vertex] ?? 0;
      if (currentDistance + n.weight + rotationCost <= nDistance) {
        distance[n.vertex] = n.weight + currentDistance + rotationCost;
        orientationMap[n.vertex] = newOrientation;

        prevMap[n.vertex]?.add(current.vertex);
        if (currentDistance + n.weight + rotationCost < nDistance) {
          prevMap[n.vertex] = Set();
          prevMap[n.vertex]?.add(current.vertex);
        }

        pq.add(AdjListNode(n.vertex, nDistance));
      }
    });
  }
  return distance;
}

(int, String) getRotationCost(String orientation, Point start, Point end) {
  var diffX = end.x - start.x;
  var diffY = end.y - start.y;
  if ((orientation == '<' || orientation == '>') && diffY > 0) {
    return (1000, 'v');
  }
  if ((orientation == '<' || orientation == '>') && diffY < 0) {
    return (1000, '^');
  }
  if ((orientation == '^' || orientation == 'v') && diffX > 0) {
    return (1000, '>');
  }
  if ((orientation == '^' || orientation == 'v') && diffX < 0) {
    return (1000, '<');
  }
  return (0, orientation);
}

String getVID(int y, int x) {
  return '$y-$x';
}

String getPointVID(Point p) {
  var py = p.y;
  var px = p.x;
  return '$py-$px';
}

Point getPointFromVID(String vid) {
  var parts = vid.split('-');
  var y = int.parse(parts[0]);
  var x = int.parse(parts[1]);
  return Point(y, x);
}

class AdjListNode implements Comparable<AdjListNode> {
  String vertex;
  int weight;

  AdjListNode(this.vertex, this.weight);

  @override
  String toString() => '($vertex: $weight)';

  @override
  int compareTo(AdjListNode other) {
    return weight.compareTo(other.weight);
  }
}

Point findPoint(List<List<String>> board, String value) {
  for (var i = 0; i < board.length; i++) {
    var line = board[i];
    for (var j = 0; j < line.length; j++) {
      if (line[j] == value) {
        return Point(i, j);
      }
    }
  }
  return Point(-1, -1);
}

class Point {
  int y;
  int x;

  Point(this.y, this.x);

  @override
  String toString() => '($y,$x)';
}

List<List<String>> readBoard(String boardStr) {
  return boardStr.split('\n').map((line) => line.split('')).toList();
}

void printDistanceBoard(List<List<dynamic>> board) {
  var boardStr = board
      .map((line) => line
          .map((k) => k == null
              ? '....'
              : k < 1000
                  ? '000' + k.toString()
                  : k)
          .join(' '))
      .join(('\n'));
  print(boardStr);
}

void printBoard(List<List<dynamic>> board) {
  var boardStr = board.map((line) => line.join('')).join(('\n'));
  print(boardStr);
}

void printBoolBoard(List<List<dynamic>> board) {
  var boardStr = board.map((line) => line.map((x) => x == true ? '\x1B[31mO\x1B[0m' : 'X').join('')).join(('\n'));
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
