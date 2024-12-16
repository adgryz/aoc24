import 'dart:io';

const MAX_INT = 999999999999;

const filePath = './example-1.txt';
// const filePath = './example-2.txt';
// const filePath = './example-3.txt';
// const filePath = './example-4.txt';
// const filePath = './example-5.txt';
// const filePath = './problem-1.txt';

void main() async {
  try {
    var result = 0;
    var text = await loadFile();
    var board = readBoard(text);

    Point startPosition = findPoint(board, 'S');
    Point endPosition = findPoint(board, 'E');

    Map<String, List<AdjListNode>> graph = buildWeightedGraph(board);
    Map<String, String> orientationMap = {};
    Map<String, String> prevMap = {};

    orientationMap[getPointVID(startPosition)] = '>';
    result = dijkstra(graph, getPointVID(startPosition), getPointVID(endPosition), orientationMap, prevMap);

    var curr = getPointVID(endPosition);
    while (curr != getPointVID(startPosition)) {
      curr = prevMap[curr] ?? "";
      var p = getPointFromVID(curr);
      board[p.y][p.x] = '\x1B[31mO\x1B[0m';
    }
    printBoard(board);
    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

Map<String, List<AdjListNode>> buildWeightedGraph(List<List<String>> board) {
  var moves = [
    Point(-1, 0),
    Point(1, 0),
    Point(0, -1),
    Point(0, 1),
  ];

  Map<String, List<AdjListNode>> graph = {};

  for (var y = 0; y < board.length; y++) {
    for (var x = 0; x < board[0].length; x++) {
      if (board[y][x] != '#') {
        moves.forEach((move) {
          if (board[y + move.y][x + move.x] != '#') {
            graph[getVID(y, x)] = [...?graph[getVID(y, x)], AdjListNode(getVID(y + move.y, x + move.x), 1)];
          }
        });
      }
    }
  }

  return graph;
}

int dijkstra(Map<String, List<AdjListNode>> graph, String src, String target, Map<String, String> orientationMap,
    Map<String, String> prevMap) {
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
      if (currentDistance + n.weight + rotationCost < nDistance) {
        distance[n.vertex] = n.weight + currentDistance + rotationCost;
        orientationMap[n.vertex] = newOrientation;
        prevMap[n.vertex] = current.vertex;
        pq.add(AdjListNode(n.vertex, nDistance));
      }
    });
  }

  print(distance);
  return distance[target] ?? 0;
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

String getVID(y, x) {
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
