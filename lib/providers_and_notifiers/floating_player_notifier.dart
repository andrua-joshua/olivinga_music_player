import 'package:flutter/material.dart';

///
///This will be used for showing of the floating player controls
///
//ignore: camel_case_types
class floatingPlayerNotifier with ChangeNotifier {
  bool _started = false;

  //using the singleton pattern to ensure that same information is being 
  // based on just like any other using this same class
  floatingPlayerNotifier._();
  static final floatingPlayerNotifier _singleObj = floatingPlayerNotifier._();
  factory floatingPlayerNotifier() => _singleObj;

  bool get started => _started;
  

  void setStarted(bool start) {
    _started = start;
    notifyListeners();
  }
}
