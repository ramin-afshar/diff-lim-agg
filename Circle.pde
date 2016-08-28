class Circle {

  float radius = 10;
  PVector position;
  boolean stuck = false;
  PVector bias = new PVector(width/2, height/2);


  void show (PVector pos) {

    position = pos;
    fill(0);
    ellipse(position.x, position.y, radius, radius);
  }


  void walk () {

    fill(0);
    ellipse(position.x, position.y, radius, radius);

    int dice = int(random(10));

    if (dice == 0) {
      PVector newVector = new PVector();
      PVector.sub(position, bias, newVector);
      newVector.normalize();
      newVector.mult(-4);
      position.add(newVector);
    } else {

      position.x += random(-2, 2);
      position.y += random(-2, 2);
    }
  }
}