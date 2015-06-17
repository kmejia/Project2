import java.util.*;

class Block {
  Random rnd = new Random();
  float xCor, yCor;
  float speed = 5;
  int fillColor;
  Block left;
  Block right;
  Block up;
  Block below;
  Block next;
  Boolean toBeRemoved = false;
  int counter;
  boolean moving = true;
  public String toString() {
    String ans = "" ;
    return ans  + xCor+"," + yCor;
  }
  Block(int colour, int count) {
    //xCor= 25+50*rnd.nextInt(20);
    xCor = 25;
    yCor = 0;
    fillColor = colour;
    counter = count;
    next=null;
    below = null;
    //xCor = (rnd.nextInt(numCellsCol) * cellSize) + (cellSize / 2);
  }
  Block(int x, int y, int colour) {
    xCor = x;
    yCor = y; 
    fillColor = colour;
    next=null;
    below = null;
  }
  Block(int x, int y, int colour, int count) {
    xCor = x;
    yCor = y; 
    fillColor = colour;
    counter = count;
  }
  Block() {
    fillColor = 1;
  }

  void drawMe() {
    fill(fillColor);
    rect(xCor, yCor, cellSize, cellSize);
  }

  void move() {
    yCor += speed;
  }

  Block getNext() {
    return next;
  }

  void setNext(Block n) {
    next = n;
  }
  /* new content*/

  boolean willHave(int y, int c) {
    Block temp = this;
    //System.out.println(temp);
    while ( (temp!= null)&&((int)temp.yCor> y + 50 )) {
      temp = temp.getNext();
    }// at this point block it bottom of the column of 3 blockt to check
    if ( temp ==null) {
      return false;
    }  
    //        if (temp.fillColor ==c) {
    //    return true;
    //  }
    while ( (temp!= null)&&((int)temp.yCor> y -50 )) {
      if ((temp.fillColor ==c) && (temp.yCor==y)) {
        // System.out.println("A");
        temp.toBeRemoved = true;
        return true;
      } 
      temp = temp.getNext();
    }
    //at this point best case is temp is uppermost noude 
    //of 3 block colum this method checks 
    return false;
    //   if (temp==null) {
    //      return false;
    //    }
    //    if (temp.fillColor ==c) {
    //    return true;
    //  }
    //    
    //    return  temp.fillColor ==c;
  }
  boolean willCenterHave(int y, int c) {//works only for the center block(what's clicked)
    Block temp = this;
    while ( (temp!= null)&&((int)temp.yCor> y + 50 )) {
      //System.out.println(temp);
      temp = temp.getNext();
    }// at this point block it bottom of the column of 3 blockt to check
    if (temp==null) {
      return false;
    }
    if ((temp.fillColor ==c) && ((int)temp.yCor!=y)) {
      //System.out.println("A"+temp.yCor + c+this.yCor);             
      temp.toBeRemoved = true;
      return true;
    }
    while ( (temp!= null)&&((int)temp.yCor> y -50 )) {
      if ( (temp.fillColor ==c) && (temp.yCor!=y)) {//we dont count the block itself
        // System.out.println("B"); 
        return true;
      } 
      temp = temp.getNext();
    }
    //at this point best case is temp is uppermost noude 
    //of 3 block colum this method checks 
    if (temp==null) {
      return false;
    }
    if (temp.fillColor ==c) {
      // System.out.println("C");          
      temp.toBeRemoved = true;
      return true;
    }
    //System.out.println("D");      

    return  temp.fillColor ==c;
  }
  boolean hasFriends() {
    // System.out.println(fillColor); 
    int Y = (int)yCor;
    int i = (int)xCor / 50;
    Block left, center, right;
    center = bl[i + 0]; 
    //cases for when we click the left/right edges
    if (i==0) {
      right = bl[i + 1]; 
      return right.willHave(Y, fillColor ) ||
        center.willCenterHave(Y, fillColor) ;
    }
    if (i==19) {
      left = bl[i - 1];  
      return left.willHave(Y, fillColor ) ||
        center.willCenterHave(Y, fillColor) ;
    }

    //these should be the starting blocks 
    //of the linked list
    left = bl[i - 1]; 
    right = bl[i + 1];
    return left.willHave(Y, fillColor ) ||
      center.willCenterHave(Y, fillColor) || 
      right.willHave(Y, fillColor);
  }
  void removeBlock(Boolean yes) {
    if (yes) {//////////////System.out.println(yes);
      //      int c = fillColor;
      //      Block temp = bl[(int)xCor/50];
      //      while((temp.getNext()!=null) &&(temp.fillColor!=c)) {
      //        temp = temp.getNext();
      //      }//at this point temp's next has color c
      //      temp.setNext(null);//nodes with color c no longer attatched to linked list
      //  Block temp2 = this;
      //      while ((temp2!=null) && (temp2.getNext().fillColor == c)){
      /////  fillColor = #FF03FB;

      //      if ((int)xCor/50-1 >= 0){
      //        removeSingle((int)xCor/50 - 1, (int) yCor, fillColor);
      //      }
      //      if ((int)xCor/50-1 <= 19){
      //        removeSingle((int)xCor/50 +1, (int) yCor, fillColor);
      //      } 
      removeSingle((int)xCor/50, (int) yCor, fillColor);

      //  

      //      temp2 = temp2.getNext();
      //      }//at this point ever next should be in moving
      //      while (temp2!=null){
      //        movers.add(temp2);
      //        temp2 = temp2.getNext();
      //      }
    }
  }
  void removeSingle(int index, int y, int clr) {
    Block deleted = bl[index];
    Block piggyback = deleted;
    while (deleted.getNext () != null && deleted.yCor > y) {
      piggyback = deleted;
      deleted = deleted.getNext();
    }
    if (deleted.getNext() ==null) {//case where the tippy top block is deleted
      System.out.println("#Stupid");
      piggyback.setNext(null);
      deleted = null;
      killTheLower(piggyback);
      //      while (piggyback!=null && piggyback.toBeRemoved) {
      //        piggyback.getBelow().setNext(null);
      //        piggyback = piggyback.getBelow();
      //        update();
      //      }
    } else {
      killTargeted(deleted);
      //      System.out.println("#MoreStupid");
      //      Block temp = deleted.getNext();
      //      System.out.println(temp.getNext());
      //      piggyback.setNext(null);
      //      temp.setBelow(piggyback);
      //      deleted = null;
      //      shiftTheRest(temp);
      //      killTheLower(piggyback);
      //      while (temp!=null) {
      //        System.out.println("I like to ...");
      //        if (!temp.toBeRemoved) {
      //          System.out.println("MOVE IT!" + temp);
      //          movers.add(temp);//every thing above piggyback is in the movers arraylist
      //        }
      //        temp = temp.getNext();
      //      }
    }
  } 

  void shiftTheRest(Block first) {
    int emergency = 10;
    System.out.println("CHECK THIS OUT " + first);
    while (first!=null && emergency>0) {
      System.out.println(emergency);
      emergency--;
      Block temp = first;
      Block next;
      if (!first.toBeRemoved) {
        System.out.println("REALLY THO?");
        next = first.getNext();
        temp.setNext(null);
        movers.add(temp);
        if (first != null) {
          System.out.println(temp + " " + temp.fillColor + " " + first + " " + first.fillColor);
        }
      } else {
        System.out.println("iStupid");
        if (temp.getNext()!=null && temp.getNext().getNext()!=null) {
          next = temp.getNext().getNext();
        } else {
          next = null;
        }
      }
      first = next;
      update();
    }
  }

  void killTheLower(Block piggyback) {
    while (piggyback!=null && piggyback.toBeRemoved) {
      piggyback = piggyback.getBelow();      
      piggyback.setNext(null);
      update();
    }
    piggyback.setNext(null);
  }

  void killTargeted(Block first) {
    Block start = bl[(int)first.xCor/50];
    Block head = start.getNext();
    while (head.getNext() != null) {      
      if (head.toBeRemoved) {
        System.out.println("WHY?");
        Block follow = head.getBelow();
        follow.setNext(null);
        if (head.getNext()!= null) {
          movers.add(head.getNext());
        } 
        update();
      }
      head = head.getNext();
    }
  }

  Block getLeft() {
    return left;
  }

  void setLeft() {
  }

  Block getRight() {
    return right;
  }

  Block getBelow() {
    return below;
  }

  void setBelow(Block b) {
    below = b;
  }
}

