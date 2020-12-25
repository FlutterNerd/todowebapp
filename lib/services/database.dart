import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todowebapp/helper_functions/shared_preferences.dart';

class DatabaseMethods {
  uploadUserInfo(String uid, Map userInfo) async {
    print('${uid} ');
    await FirebaseFirestore.instance.collection("users").doc(uid).set(userInfo);
  }

  Future uploadTodoInfo(
    String todo,
  ) async {
    String uid = await SharedPreferencesHelper().getUserId();

    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("todos")
        .add({
      "isCompleted": false,
      "time": DateTime.now().millisecondsSinceEpoch,
      "todo": todo
    }).catchError((error) {
      print(error);
    });
  }

  toggleIsCompleted(bool isCompleted, String todoId) async {
    String uid = await SharedPreferencesHelper().getUserId();
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("todos")
        .doc(todoId)
        .update({"isCompleted": !isCompleted}).catchError((error) {
      print(error);
    });
    ;
  }

  deleteTodo(String todoId) async {
    String uid = await SharedPreferencesHelper().getUserId();
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("todos")
        .doc(todoId)
        .delete()
        .catchError((error) {
      print(error);
    });
    ;
  }
}
