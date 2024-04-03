/**
 * 迷路作成時に掘り始めるマスの情報を保存するためのクラス
 */
class Cell {
  private final int row;
  private final int column;

  public Cell(int row, int column) {
    this.row = row;
    this.column = column;
  }

  public int column() {
    return this.column;
  }

  public int row() {
    return this.row;
  }
}
