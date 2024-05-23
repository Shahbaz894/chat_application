import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices{
  final String? uid;
  DatabaseServices({this.uid});
//   final refrence for collection
final CollectionReference userCollection=FirebaseFirestore.instance.collection("users");
final CollectionReference groupCollection=FirebaseFirestore.instance.collection('groups');
// saving user data
Future savingUserData(String email,String fullName) async{
  return await userCollection.doc(uid).set({
    "email":email,
    "groups":[],
    "profilePic":"",
    "uid":uid,

  });
}
Future getUserData(String email)async{
  QuerySnapshot snapshot=await userCollection.where("email",isEqualTo: email).get();

}
getUserGroup()async{
  return userCollection.doc(uid).snapshots();
}
// creating a group
Future createGroup(String userName,String id,String groupName)async{
  DocumentReference groupDocumentRefrence= await groupCollection.add({

    "groupName":groupName,
    "groupIcon":"",
    "admin":"${id}_$userName",
    'groupId':"",
    'recentMessage':'',
    'recentMessageSender':'',
  });
  // update the members
  await groupDocumentRefrence.update({
    "members": FieldValue.arrayUnion(["${uid}_$userName"]),
    "groupId": groupDocumentRefrence.id,
  });

  DocumentReference userDocumentReference = userCollection.doc(uid);
  return await userDocumentReference.update({
    "groups":
    FieldValue.arrayUnion(["${groupDocumentRefrence.id}_$groupName"])
  });
}
getGroupMember(String groupName){
  return groupCollection.where("groupName",isEqualTo:groupName ).get();
}
  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }
  //update members

}