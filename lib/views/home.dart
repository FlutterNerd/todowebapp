import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todowebapp/helper_functions/shared_preferences.dart';
import 'package:todowebapp/services/auth.dart';
import 'package:todowebapp/services/database.dart';
import 'package:todowebapp/views/signin.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textEditingController = TextEditingController();

  String uid;

  @override
  void initState() {
    getUserIndo();
    super.initState();
  }

  getUserIndo() async {
    uid = await SharedPreferencesHelper().getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TodoWebApp",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),
        elevation: 0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              AuthService().signOut().then((value) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Container(
          margin: EdgeInsets.symmetric(vertical: 24),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 400,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      onSubmitted: (value) {
                        DatabaseMethods()
                            .uploadTodoInfo(textEditingController.text);

                        textEditingController.text = "";
                      },
                      controller: textEditingController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(hintText: "enter a todo"),
                    )),
                    textEditingController.text != ""
                        ? GestureDetector(
                            onTap: () {
                              DatabaseMethods()
                                  .uploadTodoInfo(textEditingController.text);

                              textEditingController.text = "";
                            },
                            child: Text("Add"))
                        : Container()
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .collection("todos")
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Container(
                          width: 400,
                          child: ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds =
                                  snapshot.data.documents[index];

                              return TodoTile(
                                  todo: ds["todo"],
                                  documentId: ds.id,
                                  isCompleted: ds["isCompleted"]);
                            },
                          ),
                        )
                      : Container(
                          child: Center(child: CircularProgressIndicator()),
                        );
                },
              )
            ],
          )),
    );
  }
}

class TodoTile extends StatelessWidget {
  final String todo, documentId;
  final bool isCompleted;
  TodoTile({this.todo, this.documentId, this.isCompleted});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // call the update is completed function
              DatabaseMethods().toggleIsCompleted(isCompleted, documentId);
            },
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black87,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(16)),
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 16,
                    )
                  : Container(),
            ),
          ),
          SizedBox(width: 8),
          Text(
            todo,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                decoration: isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              DatabaseMethods().deleteTodo(documentId);
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                size: 18,
              ),
            ),
          )
        ],
      ),
    );
  }
}
