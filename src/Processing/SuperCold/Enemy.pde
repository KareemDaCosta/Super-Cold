class Enemy {
  float x, y;
  float velocityX, velocityY;
  float cameraAngle;
  int firingCountdown;
  boolean firing;
  char movementLetter;
  int movementTimer;
  int dyingTimer;
  char dyingStage;
  float enemyWidth;
  float enemyHeight;
  PImage texture;

  Enemy(int startingX, int startingY) {
    x = startingX;
    y = startingY;
    firing = false;
    cameraAngle = 3 * QUARTER_PI;
    firingCountdown = 0;
    movementLetter = 'A';
    movementTimer = 20;
    enemyHeight = 8;
    dyingTimer = 0;
    dyingStage = 0;
    texture = loadImage("./Sprites/B15BA1.png");
    enemyWidth = (float) texture.width / (float) texture.height * enemyHeight;
  }
  
  void updatePosition(int newX, int newY) {
    x = newX;
    y = newY;
  }
  
  void updateVelocity(int newVelocityX, int newVelocityY) {
    velocityX = newVelocityX;
    velocityY = newVelocityY;
  }
  
  void fire() {
     firing = true;
     firingCountdown = 15;
  }
  
  void triggerDeath() {
    if(dyingStage == 0) {
     dyingTimer = 8;
     dyingStage = 1;
    }
  }
  
  void updateVariables() {
   if(movementTimer > 0) {
      movementTimer--;
      if(movementTimer == 0) {
         movementTimer = 5;
         if(movementLetter == 'A') {
            movementLetter = 'B'; 
         }
         else if(movementLetter == 'B') {
            movementLetter = 'C'; 
         }
         else if(movementLetter == 'C') {
            movementLetter = 'D'; 
         }
         else {
            movementLetter = 'A'; 
         }
      }
   }
   if(firingCountdown > 0) {
      firingCountdown--; 
      if(firingCountdown == 0) {
         firing = false;
      }
   }
   if(dyingTimer > 0) {
      dyingTimer--;
      if(dyingTimer == 0) {
         dyingTimer = 8;
         dyingStage++;
         if(dyingStage == 6) {
            //Trigger new game 
            enemyHeight = 8;
            dyingStage = 0;
            dyingTimer = 0;
         }
      }
    }
  } 
    
  float computeAngle(PVector v1, PVector v2) {
    float a = atan2(v2.y, v2.x) - atan2(v1.y, v1.x);
    if (a < 0) a += TWO_PI;
    return TWO_PI - a;
  }
  
  char getAngleChar(Camera player) {
    PVector camera_vector = new PVector(player.cameraX - x, player.cameraY - y);
    PVector movement_vector = new PVector(velocityX, velocityY);
    if(velocityX == 0 && velocityY == 0) {
      movement_vector = PVector.fromAngle(cameraAngle);
    }
    float angle = computeAngle(camera_vector, movement_vector);
    if(angle < QUARTER_PI / 2) {
      return '1';
    }
    else if (angle < 3 * QUARTER_PI / 2) {
      return '2'; 
    }
    else if (angle < 5 * QUARTER_PI/2) {
      return '3';
    }
    else if (angle < 7 * QUARTER_PI/2) {
      return '4'; 
    }
    else if (angle < 9 * QUARTER_PI/2) {
      return '5';
    }
    else if (angle < 11 * QUARTER_PI/2) {
      return '6'; 
    }
    else if (angle < 13 * QUARTER_PI/2) {
       return '7'; 
    }
    else if (angle < 15 * QUARTER_PI/2) {
       return '8'; 
    }
    else {
       return '1'; 
    }
    
  }
  
  void updateTexture(Camera player) {
    String image = "./Sprites/B15B";
    if(dyingStage > 0) {
      image += 'H';
      image += Integer.toString(dyingStage);
      image += ".png";
      enemyWidth = 5.5;
      if(dyingStage == 3) {
         enemyWidth += 1; 
      }
      if(dyingStage == 4) {
         enemyWidth += 2;
      }
      if(dyingStage == 5) {
         enemyWidth += 5; 
      }
      texture = loadImage(image);
      enemyHeight = (float) texture.height / (float) texture.width * enemyWidth;
    }
    else {
      if(firing) {
         image += 'F'; 
      }
      else if(velocityX != 0 || velocityY != 0) {
        image += movementLetter;
      }
      else {
        image += 'E';
      }
      image += getAngleChar(player);
      image += ".png";
      texture = loadImage(image);
      enemyWidth = (float) texture.width / (float) texture.height * enemyHeight;
    }
    
  }
}
