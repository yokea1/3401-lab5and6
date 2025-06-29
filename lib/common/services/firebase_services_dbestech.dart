import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/user.dart';

class FirebaseServicesDbestech{
  final db = FirebaseFirestore.instance;

  Future<void> handleFirestoreUser(String userId, String email) async {
    var userbase = await db.collection("users").withConverter(
      fromFirestore: UserData.fromFirestore,
      toFirestore: (UserData userdata, options) => userdata.toFirestore(),
    ).where("id", isEqualTo: userId).get();

    if (userbase.docs.isEmpty) {
      final data = UserData(
          id: userId,
          name: "",
          email: email,
          photourl: "",
          location: "",
          fcmtoken: "",
          addtime: Timestamp.now()
      );

      try {
        await db.collection("users").withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options) => userdata.toFirestore(),
        ).add(data);

        print("User data updated in Firestore");
      } catch (e) {
        print("Error adding document: $e");
      }
    } else {
      print("User already exists in Firestore");
    }
  }

}