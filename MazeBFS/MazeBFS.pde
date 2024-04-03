// 縦のマス目の数（5以上の奇数）
private final int ROWS = 31;

// 横のマス目の数（5以上の奇数）
private final int COLUMNS = 31;

// 描画時のマス目の1辺の長さ
private final int CELLSIZE = 20;

// 迷路を扱うためのインスタンス
MazeCreator creator;

// 迷路を歩くためのインスタンス
MazeWalker walker;

// ゲーム情報を描画するためのインスタンス
MazeDrawer drawer;

void settings() {
  size(COLUMNS*CELLSIZE, ROWS*CELLSIZE);
}

void setup() {
  // 迷路の初期設定
  creator = new MazeCreator(ROWS, COLUMNS);

  // 迷路を作成
  creator.dig();

  // プレイヤーを初期化
  walker = new MazeWalker(creator);

  // 描画インスタンスを初期化
  drawer = new MazeDrawer(creator, walker, CELLSIZE);

  // 現在の状況を描画
  drawer.update();
}

void draw() {
  // プレイヤーを動かして最終状態を描画
  walker.walk();
  drawer.update();

  noLoop();
}
