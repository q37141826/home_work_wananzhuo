




import 'package:scoped_model/scoped_model.dart';

NumModle countModel = NumModle();


class NumModle extends Model {
  int _count = 0;

  void setcount(int value) {
    _count = value;
  }

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  static NumModle getModlel(){
    return countModel;
  }
}