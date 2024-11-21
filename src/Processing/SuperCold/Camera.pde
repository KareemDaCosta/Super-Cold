float xoff = 0;
float yoff = 10000;

int fov = 90;

void camera_draw(Particle particle, ArrayList<Boundary> walls) {
  background(0);

  // Handle key presses for movement and rotation
  if (keyPressed) {
    if (keyCode == LEFT) {
      particle.rotate(-0.03);
    } else if (keyCode == RIGHT) {
      particle.rotate(0.03);
    } else if (keyCode == UP) {
      particle.move(2);
    } else if (keyCode == DOWN) {
      particle.move(-2);
    }
  }
  particle.show();

  // Render 3D-like scene on the right half of the canvas
  ArrayList<Float> scene = particle.look(walls);
  float w = (float) sceneW / scene.size();
  
  pushMatrix();
  translate(sceneW, 0); // Move to the right half of the canvas
  for (int i = 0; i < scene.size(); i++) {
    noStroke();
    float sq = scene.get(i) * scene.get(i);
    float wSq = sceneW * sceneW;
    float b = map(sq, 0, wSq, 255, 0); // Brightness
    float h = map(scene.get(i), 0, sceneW, sceneH, 0); // Height
    fill(b);
    rectMode(CENTER);
    rect(i * w + w / 2, sceneH / 2, w + 1, h);
  }
  popMatrix();
}

class Particle {
  PVector pos;
  float heading;
  float fov;

  Particle() {
    pos = new PVector(sceneW / 2, sceneH / 2);
    heading = 0;
    fov = radians(60);
  }

  void updateFOV(int angle) {
    fov = radians(angle);
  }

  void rotate(float angle) {
    heading += angle;
  }

  void move(float amount) {
    PVector forward = PVector.fromAngle(heading);
    forward.setMag(amount);
    pos.add(forward);
  }

  ArrayList<Float> look(ArrayList<Boundary> walls) {
    ArrayList<Float> scene = new ArrayList<Float>();
    int totalRays = 360;
    float angleStep = fov / totalRays;
    
    for (float angle = heading - fov / 2; angle < heading + fov / 2; angle += angleStep) {
      PVector rayDir = PVector.fromAngle(angle);
      float minDist = Float.MAX_VALUE;
      for (Boundary wall : walls) {
        PVector pt = cast(rayDir, wall);
        if (pt != null) {
          float d = PVector.dist(pos, pt);
          if (d < minDist) {
            minDist = d;
          }
        }
      }
      scene.add(minDist);
    }
    return scene;
  }

  PVector cast(PVector dir, Boundary wall) {
    float x1 = wall.x1;
    float y1 = wall.y1;
    float x2 = wall.x2;
    float y2 = wall.y2;

    float x3 = pos.x;
    float y3 = pos.y;
    float x4 = pos.x + dir.x;
    float y4 = pos.y + dir.y;

    float den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if (den == 0) return null;

    float t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;
    float u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den;

    if (t > 0 && t < 1 && u > 0) {
      float px = x1 + t * (x2 - x1);
      float py = y1 + t * (y2 - y1);
      return new PVector(px, py);
    } else {
      return null;
    }
  }

  void show() {
    fill(255);
    ellipse(pos.x, pos.y, 8, 8);
  }
}
