/**
 * 迷路を作ったり描画したりするためのクラス
 */

import java.util.List;

class MazeCreator {
  private boolean[][] isWall;        // そのマスが壁か否かを保存
  private List<Cell> startCells = new ArrayList<Cell>(); // スタート地点候補のリスト

  /**
   * コンストラクタ
   */
  public MazeCreator(int rows, int columns) {
    // rowsもしくはcolumnsが条件を満たさない場合には例外をスロー
    if (rows<5 || columns<5) {
      throw new IllegalArgumentException("縦・横それぞれ5マス以上が必要です。");
    }

    if (rows%2 == 0 || columns%2 == 0) {
      throw new IllegalArgumentException("縦・横のマス目は奇数である必要があります。");
    }

    // 外周のみ通路として初期化
    isWall = new boolean[rows][columns];
    for (int j=0; j<isWall[0].length; j++) {
      isWall[0][j] = false;
      isWall[isWall.length-1][j] = false;
    }

    for (int i=1; i<isWall.length-1; i++) {
      // 外周のみ通路として初期化
      isWall[i][0] = false;
      isWall[i][isWall[0].length-1] = false;
      for (int j=1; j<isWall[0].length-1; j++) {
        // 外周ではないので壁として初期化
        isWall[i][j] = true;
      }
    }
  }

  /**
   * 横のマスの数を返す
   */
  public int columns() {
    return isWall[0].length;
  }

  /**
   * 迷路を作る
   */
  public void dig() {
    // (奇数, 奇数)のポイントをランダムに選んで掘り始める
    Cell start = getStart();
    dig(start.row(), start.column());

    // 最初に通路とした外周を壁として埋め直す
    for (int j=0; j<isWall[0].length; j++) {
      isWall[0][j] = true;
      isWall[isWall.length-1][j] = true;
    }

    for (int i=1; i<isWall.length-1; i++) {
      // 外周のみ壁として埋め直す
      isWall[i][0] = true;
      isWall[i][isWall[0].length-1] = true;
    }
  }

  /**
   * ランダムに方角を選ぶ
   */
  public Direction getDirection() {
    int num = int(random(0, Direction.values().length));
    for (Direction d : Direction.values()) {
      if (d.id() == num) {
        return d;
      }
    }
    return null;
  }

  /**
   *  ランダムに(奇数, 奇数)のマスを選ぶ
   */
  public Cell getStart() {
    int r;
    int c;
    do {
      r = int(random(1, isWall.length));
      c = int(random(1, isWall[0].length));
    } while (r%2==0 || c%2==0);

    return new Cell(r, c);
  }

  /**
   * 指定したマスが壁かどうかを返す
   */
  public boolean isWall(int r, int c) {
    return isWall[r][c];
  }

  /**
   * 縦のマスの数を返す
   */
  public int rows() {
    return isWall.length;
  }

  /**
   * 指定したマスから穴を掘って迷路を作っていく
   */
  private void dig(int r, int c) {

    // 指定されたマスは通路とする
    // 次の始点候補としてリストに入れる
    open(r, c);

    boolean goUp = true;
    boolean goDown = true;
    boolean goLeft = true;
    boolean goRight = true;
    do {
      // 次に進む方向を決める
      Direction next = getDirection();

      if (next == Direction.UP) {
        if (r-2>0 && isWall[r-2][c]) {
          // 上方向に2マス行ったところが壁ならば道を伸ばす
          open(r-1, c);
          open(r-2, c);
          dig(r-2, c);
        } else {
          goUp = false;
        }
      } else if (next == Direction.DOWN) {
        if (r+2<isWall.length && isWall[r+2][c]) {
          // 下方向に2マス行ったところが壁ならば道を伸ばす
          open(r+1, c);
          open(r+2, c);
          dig(r+2, c);
        } else {
          goDown = false;
        }
      } else if (next == Direction.LEFT) {
        if (c-2>0 && isWall[r][c-2]) {
          // 左方向に2マス行ったところが壁ならば道を伸ばす
          open(r, c-1);
          open(r, c-2);
          dig(r, c-2);
        } else {
          goLeft = false;
        }
      } else if (next == Direction.RIGHT) {
        if (c+2<isWall[0].length && isWall[r][c+2]) {
          // 右方向に2マス行ったところが壁ならば道を伸ばす
          open(r, c+1);
          open(r, c+2);
          dig(r, c+2);
        } else {
          goRight = false;
        }
      }
    } while (goUp || goDown || goLeft || goRight);

    // 上下左右どこにも伸ばせないのでランダムな通路マスを次の始点として
    // 続きを掘る
    Cell cell = next(r, c);
    if (cell == null) {
      // もうスタート地点候補がない
      return;
    }
    dig(cell.row(), cell.column());
  }

  // リストの中から次のスタート地点を選ぶ
  private Cell next(int r, int c) {
    // 指定されたマスをリストから削除
    for (int i=0; i<startCells.size(); i++) {
      Cell item = startCells.get(i);
      if (item.row() == r && item.column() == c) {
        startCells.remove(i);
        break;
      }
    }

    // スタート候補なし
    if (startCells.size() == 0) {
      return null;
    }

    int idx = int(random(0, startCells.size()));
    Cell cell = startCells.get(idx);
    startCells.remove(idx);
    return cell;
  }

  // 指定したセルが壁ならば通路にする。
  // さらに(奇数, 奇数)ならば掘り始め候補に入れる
  private void open(int r, int c) {
    if (isWall[r][c]) {
      isWall[r][c] = false;
      if (r%2==1&& c%2==1) {
        startCells.add(new Cell(r, c));
      }
    }
  }
}
