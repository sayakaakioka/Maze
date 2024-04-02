class MazeDrawer {
  private final MazeCreator creator;
  private final MazeWalker walker;
  private final int cellSize;

  public MazeDrawer(MazeCreator creator, MazeWalker walker, int cellSize) {
    this.creator = creator;
    this.walker = walker;
    this.cellSize = cellSize;
  }

  /**
   * 現在の状況を描画
   */
  public void update() {
    for (int i=0; i<creator.rows(); i++) {
      for (int j=0; j<creator.columns(); j++) {
        if (creator.isWall(i, j)) {
          drawWall(i, j);
        } else {
          if (walker.walkerWalked(i, j)) {
            if (walker.isStart(i, j)) {
              drawStart(i, j);
            } else if (walker.isGoal(i, j)) {
              drawGoal(i, j);
            } else {
              drawFootStep(i, j);
            }
          } else {
            drawAisle(i, j);
          }
        }
      }
    }
  }

  // 指定された位置に足跡を描く
  private void drawFootStep(int r, int c) {
    stroke(200, 200, 0);
    fill(200, 200, 0);
    rect(c*this.cellSize, r*this.cellSize, this.cellSize, this.cellSize);
  }
  
  // 指定された位置にゴール地点を描く
  private void drawGoal(int r, int c) {
    stroke(0, 128, 0);
    fill(0, 128, 0);
    rect(c*this.cellSize, r*this.cellSize, this.cellSize, this.cellSize);
  }

  // 指定された位置にスタート地点を描く
  private void drawStart(int r, int c) {
    stroke(255, 0, 0);
    fill(255, 0, 0);
    rect(c*this.cellSize, r*this.cellSize, this.cellSize, this.cellSize);
  }

  // 指定されたマスを壁として描く
  private void drawWall(int r, int c) {
    stroke(0, 0, 0);
    fill(90, 90, 90);
    rect(c*this.cellSize, r*this.cellSize, this.cellSize, this.cellSize);
  }

  // 指定されたマスを通路として描く
  private void drawAisle(int r, int c) {
    stroke(255, 255, 255);
    fill(200, 200, 200);
    rect(c*this.cellSize, r*this.cellSize, this.cellSize, this.cellSize);
  }
}
