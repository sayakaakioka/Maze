/**
* 迷路を解くためのクラス
*/
class MazeWalker {
  // 迷路情報
  private final MazeCreator creator;

  // プレイヤーのスタート位置
  private final int startRow;
  private final int startColumn;

  // プレイヤーのゴール位置
  private final int goalRow;
  private final int goalColumn;

  // プレイヤーの足跡
  private boolean[][] walked;
  private List<Cell> footSteps;

  public MazeWalker(MazeCreator creator) {
    this.creator = creator;
    this.footSteps = new ArrayList<Cell>();
    this.walked = new boolean[creator.rows()][creator.columns()];
    for (int i=0; i<walked.length; i++) {
      for (int j=0; j<walked[0].length; j++) {
        walked[i][j] = false;
      }
    }

    // 壁ではないところにプレイヤーをランダムに配置
    Cell cell;
    do {
      cell = creator.getStart();
    } while (creator.isWall(cell.row(), cell.column()));
    this.startRow = cell.row();
    this.startColumn = cell.column();

    // 壁でもスタート位置でもないところをゴールに設定
    do {
      cell = creator.getStart();
    } while (creator.isWall(cell.row(), cell.column()) && !cell.equals(new Cell(this.startRow, this.startColumn)));
    this.goalRow = cell.row();
    this.goalColumn = cell.column();
  }

  /**
   * ゴール位置ならばtrueを返す
   */
   public boolean isGoal(int r, int c){
     if(r == goalRow && c == goalColumn){
       return true;
     }
     return false;
   }

  /**
   * スタート位置ならばtrueを返す
   */
  public boolean isStart(int r, int c) {
    if (r == startRow && c == startColumn) {
      return true;
    }
    return false;
  }

  /**
   *初期位置から歩き始める
   */
  public void walk() {
    walk(startRow, startColumn);
  }

  /**
   * プレイヤーが歩いたことがあるならばtrueを返す
   */
  public boolean walkerWalked(int r, int c) {
    return walked[r][c];
  }

  // 指定した位置から歩く
  private boolean walk(int r, int c) {
    // 歩いたことがなければ状態と足跡リストを更新
    if (!walked[r][c]) {
      walked[r][c] = true;
      footSteps.add(new Cell(r, c));
    }

    // ゴールだったら終了
    if (goalRow == r && goalColumn == c) {
      return true;
    }

    boolean proceeded = false;

    // 深さ優先探索で歩く
    // 上方向が壁でなく歩いたことがなければ歩く
    if (r-1>0 && !creator.isWall(r-1, c) && !walked[r-1][c]) {
      if (walk(r-1, c)) {
        return true;
      }
      proceeded = true;
    }

    // 下方向が壁でなく歩いたことがなければ歩く
    if (r+1<creator.rows() && !creator.isWall(r+1, c) && !walked[r+1][c]) {
      if (walk(r+1, c)) {
        return true;
      }
      proceeded = true;
    }

    // 左方向が壁でなく歩いたことがなければ歩く
    if (c-1>0 && !creator.isWall(r, c-1) && !walked[r][c-1]) {
      if (walk(r, c-1)) {
        return true;
      }
      proceeded = true;
    }

    // 右方向が壁でなく歩いたことがなければ歩く
    if (c+1<creator.columns() && !creator.isWall(r, c+1) && !walked[r][c+1]) {
      if (walk(r, c+1)) {
        return true;
      }
      proceeded = true;
    }

    // これ以上は歩けない
    if (!proceeded) {
      int idx = footSteps.size();

      // 戻れれば戻って続ける
      if (idx != 0) {
        Cell next = footSteps.get(idx-1);
        footSteps.remove(idx-1);
        if (walk(next.row(), next.column())) {
          return true;
        }
      }
    }
    return false;
  }
}
