/**
 * 迷路を解くためのクラス
 */

import java.util.ArrayList;
import java.util.Arrays;

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
  private int[][] cost;

  public MazeWalker(MazeCreator creator) {
    this.creator = creator;
    this.cost = new int[creator.rows()][creator.columns()];
    for (int i=0; i<cost.length; i++) {
      for (int j=0; j<cost[0].length; j++) {
        cost[i][j] = -1;
      }
    }

    // 壁ではないところにプレイヤーをランダムに配置
    Cell cell = creator.getCell();
    this.startRow = cell.row();
    this.startColumn = cell.column();

    // 壁でもスタート位置でもないランダムなマスをゴールに設定
    do {
      cell = creator.getCell();
    } while (cell.row() == this.startRow && cell.column() == this.startColumn);
    this.goalRow = cell.row();
    this.goalColumn = cell.column();
  }

  /**
   * 指定されたマスのスタートマスからのコストを返す
   */
  public int cost(int r, int c) {
    return cost[r][c];
  }

  /**
   * ゴール位置ならばtrueを返す
   */
  public boolean isGoal(int r, int c) {
    if (r == goalRow && c == goalColumn) {
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
  public boolean walked(int r, int c) {
    if (cost[r][c] >=0) {
      return true;
    }
    return false;
  }

  // 指定した位置から歩く
  private void walk(int r, int c) {
    ArrayList<Cell> listByCost = new ArrayList<Cell>();

    // 始点はコストゼロ。コストゼロのマスは始点のみ。
    // 始点のみをコストごとのリストに追加。
    listByCost.add(new Cell(r, c));

    // 始点を歩いた場所としてマーク
    cost[r][c] = 0;

    // ゴールが見つかったかどうか
    boolean goalFound = false;

    // 探索中のマスへのスタート地点からのコスト
    int currentCost = 1;
    while (!goalFound) {
      // ひとつ前に探索していたコストのマス集合のうち、
      // 各ノードからコスト+1で行くことができるノードのリストを作成
      ArrayList<Cell> list = new ArrayList<Cell>();
      for (Cell cell : listByCost) {
        int lastR = cell.row();
        int lastC = cell.column();

        // 上のマスを追加
        if (lastR-1>0 && !creator.isWall(lastR-1, lastC) && !walked(lastR-1, lastC)) {
          cost[lastR-1][lastC] = currentCost;
          list.add(new Cell(lastR-1, lastC));

          // このマスがゴールならばループを抜ける
          if (isGoal(lastR-1, lastC)) {
            goalFound = true;
            break;
          }
        }

        // 下のマスを追加
        if (lastR+1>0 && !creator.isWall(lastR+1, lastC) && !walked(lastR+1, lastC)) {
          cost[lastR+1][lastC] = currentCost;
          list.add(new Cell(lastR+1, lastC));

          // このマスがゴールならばループを抜ける
          if (isGoal(lastR+1, lastC)) {
            goalFound = true;
            break;
          }
        }

        // 左のマスを追加
        if (lastC-1>0 && !creator.isWall(lastR, lastC-1) && !walked(lastR, lastC-1)) {
          cost[lastR][lastC-1] = currentCost;
          list.add(new Cell(lastR, lastC-1));

          // このマスがゴールならばループを抜ける
          if (isGoal(lastR, lastC-1)) {
            goalFound = true;
            break;
          }
        }

        // 右のマスを追加
        if (lastC+1>0 && !creator.isWall(lastR, lastC+1) && !walked(lastR, lastC+1)) {
          cost[lastR][lastC+1] = currentCost;
          list.add(new Cell(lastR, lastC+1));

          // このマスがゴールならばループを抜ける
          if (isGoal(lastR, lastC+1)) {
            goalFound = true;
            break;
          }
        }
      } // end of for

      // 出来上がったリストでコストごとのリストを上書き
      listByCost = (ArrayList<Cell>)list.clone();

      // まだ見つかっていなければ次のコストへ
      currentCost++;
    } // end of while
  }
}
