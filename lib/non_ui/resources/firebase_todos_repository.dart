import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/task.dart';

class FirebaseTodosRepository {
  final taskCollection = FirebaseFirestore.instance.collection('abd-todos');

  Future<void> addNewTask(Task task) {
    return taskCollection.add(task.toJson()).then((value) {
      String id = value.id;
      return value.update({'id': id});
    });
  }

  Future<void> deleteTask(Task task) async {
    print('delete called');
    return await taskCollection.doc(task.id).delete();
  }

  Stream<List<Task>> tasks() {
    return taskCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();
    });
  }

  Future<void> updateTask(Task update) {
    return taskCollection.doc(update.id).update(update.toJson());
  }
}
