import 'package:expense_logo/login/model/user_model.dart';
import 'package:expense_logo/login/service/database_service.dart';
import 'package:expense_logo/util/apputil.dart';

import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  DatabaseService databaseService;

  AuthProvider(this.databaseService);

  bool isVisible = false;
  bool isLoading = false;
  String? error;

  void setPasswordFieldStatus() {
    isVisible = !isVisible;
    notifyListeners();
  }

  Future registerUser(User user) async {
    isLoading = true;
    error = null;
    notifyListeners(); // await Future.delayed(Duration(seconds: 3));
    try {
      await databaseService.registerUser(user);
    } catch (e) {
      error = e.toString();
      AppUtil.showToast(error!);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> isUserExists(User user) async {
    try {
      isLoading = true;
      notifyListeners();
      error = null;
      await Future.delayed(Duration(seconds: 5));
      return await databaseService.isUserExists(user);
    } catch (e) {
      error = e.toString();
      AppUtil.showToast(error!);
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }
}
