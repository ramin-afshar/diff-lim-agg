class QuadTree {
  int maxObjects = 10;
  int maxLevels = 4;
  QuadTree[] nodes;
  int level;
  ArrayList<Circle> objects;
  Bounds bounds;

  QuadTree(int pLevel, Bounds pBounds) {
    level = pLevel;
    objects = new ArrayList();
    bounds = pBounds;
    nodes = new QuadTree [4];
  }

  void clear() {
    objects.clear(); 
    for (int i = 0; i < nodes.length; i++ ) {
      if (nodes[i] != null) {
        nodes[i].clear();
        nodes[i] = null;
      }
    }
  }

  void split() {
    int subWidth = (int)(bounds.bWidth/2);
    int subHeight = (int)(bounds.bHeight/2);
    int x = (int)bounds.x;
    int y = (int)bounds.y;

    nodes[0] = new QuadTree(level+1, new Bounds(x + subWidth, y, subWidth, subHeight));
    nodes[1] = new QuadTree(level+1, new Bounds(x, y, subWidth, subHeight));
    nodes[2] = new QuadTree(level+1, new Bounds(x, y + subHeight, subWidth, subHeight));
    nodes[3] = new QuadTree(level+1, new Bounds(x + subWidth, y + subHeight, subWidth, subHeight));
  }


  int getIndex(Circle circle) {
    int index = -1;
    double verticalMidpoint = bounds.x + (bounds.bWidth / 2);
    double horizontalMidpoint = bounds.y + (bounds.bHeight / 2);

    // Object can completely fit within the top quadrants
    boolean topQuadrant = (circle.position.y < horizontalMidpoint && circle.position.y + circle.radius < horizontalMidpoint);
    // Object can completely fit within the bottom quadrants
    boolean bottomQuadrant = (circle.position.y > horizontalMidpoint);

    // Object can completely fit within the left quadrants
    if (circle.position.x < verticalMidpoint && circle.position.x + circle.radius < verticalMidpoint) {
      if (topQuadrant) {
        index = 1;
      } else if (bottomQuadrant) {
        index = 2;
      }
    }
    // Object can completely fit within the right quadrants
    else if (circle.position.x > verticalMidpoint) {
      if (topQuadrant) {
        index = 0;
      } else if (bottomQuadrant) {
        index = 3;
      }
    }
    return index;
  }

  void insert(Circle circle) {
    if (nodes[0] != null) {
      int index = getIndex(circle);

      if (index != -1) {
        nodes[index].insert(circle);
        return;
      }
    }

    objects.add(circle);

    if (objects.size() > maxObjects && level < maxLevels) {
      if (nodes[0] == null) { 
        split();
      }

      int i = 0;
      while (i < objects.size()) {
        int index = getIndex(objects.get(i));
        if (index != -1) {
          nodes[index].insert(objects.get(i));
          objects.remove(i);
        } else {
          i++;
        }
      }
    }
  }


  ArrayList retrieve(ArrayList returnObjects, Circle circle) {
    int index = getIndex(circle);
    if (index != -1 && nodes[0] != null) {
      nodes[index].retrieve(returnObjects, circle);
    }

    returnObjects.addAll(objects);
    return returnObjects;
  }
}