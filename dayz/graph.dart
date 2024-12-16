import 'dart:collection';

const MAX_INT = 9999999999;

// Function to find the shortest distance of all the
// vertices from the source vertex S.
int dijkstra(Map<String, List<AdjListNode>> graph, String src, String target) {
  Map<String, int> distance = {};
  graph.keys.forEach((vid) => distance[vid] = MAX_INT);
  distance[src] = 0;
  List<AdjListNode> pq = [];
  pq.add(AdjListNode(src, 0));

  while (pq.length > 0) {
    pq.sort();
    AdjListNode current = pq.first;
    pq.removeAt(0);
    if (current.vertex == '7-9') {
      print('current: ' + graph[current.vertex].toString());
    }

    print(current.vertex);
    graph[current.vertex]?.forEach((n) {
      var currentDistance = distance[current.vertex] ?? 0;
      var nDistance = distance[n.vertex] ?? 0;
      // if (current.vertex == '7-9') {
      //   print('n: ' + n.toString());
      //   print(currentDistance.toString() + ' ' + n.weight.toString() + ' ' + nDistance.toString());
      // }
      if (currentDistance + n.weight < nDistance) {
        // if (current.vertex == '7-9') {
        //   print('n added: ' + n.toString());
        // }
        distance[n.vertex] = n.weight + currentDistance;
        pq.add(AdjListNode(n.vertex, nDistance));
      }
    });
  }

  return distance[target] ?? 0;
}

String getVID(y, x) {
  return '$y-$x';
}

String getPointVID(Point p) {
  var py = p.y;
  var px = p.x;
  return '$py-$px';
}

Set<String> DFS(Map<String, List<String>> graph, String start, Set<String> visited) {
  visited.add(start);
  graph[start]?.where((v) => !visited.contains(v)).forEach((next) => DFS(graph, next, visited));
  return visited;
}

void BFS(Map<String, List<String>> graph, String start) {
  var visited = Set<String>();
  var queue = Queue<String>();
  queue.add(start);
  visited.add(start);
  while (queue.isNotEmpty) {
    var vertex = queue.removeFirst();
    graph[vertex]?.where((neighbor) => !visited.contains(neighbor)).forEach((neighbor) {
      visited.add(neighbor);
      queue.addLast(neighbor);
    });
  }
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
        return Point(j, i);
      }
    }
  }
  return Point(-1, -1);
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  String toString() => '($x,$y)';
}
