// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:quiz_app/models/question_model.dart';

// class DataRepository {
//   // 1
//   final CollectionReference collection =
//       FirebaseFirestore.instance.collection('quiz-questions');
//   // 2
//   Stream<QuerySnapshot> getStream() {
//     return collection.snapshots();
//   }

//   // 3
//   Future<DocumentReference> addPet(QuizModel pet) {
//     return collection.add(pet.toJson());
//   }

//   // 4
//   void updatePet(Pet pet) async {
//     await collection.doc(pet.referenceId).update(pet.toJson());
//   }

//   // 5
//   void deletePet(Pet pet) async {
//     await collection.doc(pet.referenceId).delete();
//   }
// }
