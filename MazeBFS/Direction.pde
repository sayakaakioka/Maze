public enum Direction {
  UP(0),
    DOWN(1),
    LEFT(2),
    RIGHT(3);

  private final int id;

  private Direction(int id) {
    this.id = id;
  }

  /**
   * コード値を返す
   */
  public int id() {
    return this.id;
  }
}
