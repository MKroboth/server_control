extension DropLastIfString on String {
  String dropLastWhile(bool Function(String) cond) {
    String last = this;
    String current = this;

    do {
      last = current;
      current = current.dropLastIf(cond);
    } while (last != current);
    return current;
  }

  String dropLastIf(bool Function(String) cond) {
    if (cond(this.substring(this.length - 1, this.length))) {
      return this.substring(0, this.length - 1);
    } else
      return this;
  }
}
