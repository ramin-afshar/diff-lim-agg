ArrayList<Circle> circles;
int numcircles;
QuadTree quad;

void setup () {
  size (800, 600);
  //frameRate(1);
  background(255);
  numcircles = 500;
  circles = new ArrayList<Circle>();
  Circle c = new Circle();
  c.stuck = true;
  c.position = new PVector(width/2, height/2);
  circles.add(c);

  quad = new QuadTree ( 0, new Bounds (0, 0, 800, 600));

  for (int i = 0; i < numcircles; i++) {
    Circle hex = new Circle();
    hex.stuck = false;
    hex.position = giveRandomPosition();
    circles.add(hex);
  }
}

void draw () {
  background(255);
  distance();

  quad.clear();
  for (int i = 0; i < circles.size(); i++) {
    Circle c = circles.get(i); 
    if (c.stuck == true) {
      quad.insert(c);
      c.show(c.position);
    } else {
      c.walk();
    }
  }
}

PVector giveRandomPosition () {
  int dice = int(random (4));
  PVector pos = new PVector();
  if (dice == 0) {
    pos = new PVector(random(width), 0);
  } else if (dice == 1) {
    pos = new PVector(width, random(height));
  } else if (dice == 2) {
    pos = new PVector(random(width), height);
  } else if (dice == 3) {
    pos = new PVector(0, random(height));
  }
  return pos;
}

void distance() {

  ArrayList returnObjects = new ArrayList();
  for (int i = 0; i < circles.size(); i++) {
    returnObjects.clear();

    Circle circle = circles.get(i);

    if (circle.stuck != true) {
      quad.retrieve(returnObjects, circle);
      for (int x = 0; x < returnObjects.size(); x++) {

        Circle c2 = (Circle)returnObjects.get(x);
        Circle c = circles.get(i);

        float dx = c2.position.x - c.position.x;
        float dy = c2.position.y - c.position.y;
        float dist = dx * dx + dy * dy;
        if (dist < c.radius * c.radius ) {
          c.stuck = true;
        }
      }
    }
  }
}