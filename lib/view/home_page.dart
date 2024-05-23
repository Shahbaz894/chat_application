import 'package:chat_application/helper/helper_function.dart';
import 'package:chat_application/services/auth_services.dart';
import 'package:chat_application/services/database_services.dart';
import 'package:chat_application/view/auth_screen/login_page.dart';
import 'package:chat_application/view/profile_page.dart';
import 'package:chat_application/view/search_page.dart';
import 'package:chat_application/widgets/group_tile.dart';
import 'package:chat_application/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

String userName='';
String email='';
AuthService authService=AuthService();
Stream? groups;
bool _isLoading = false;
String groupName = "";
@override
void initState(){
  getUserData();
}
//string manipulation
  String getId(String res){
  return res.substring(0,res.indexOf("_"));
  }
  String getName(String res ){
  return res.substring(res.indexOf("_")+1);
  }
getUserData() async{
await HelperFunctions.getUserEmailFromSF().then((value){
  setState(() {
    email=value!;
  });

});
await HelperFunctions.getUserNameFromSF().then((value){
  setState(() {
    userName=value!;
  });

  });
await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot){
  setState(() {
    groups=snapshot;
  });
});
}

  @override
  Widget build(BuildContext context) {


    return  Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){
          nextScreen((context), SearchPage());
        }, icon: const Icon(Icons.search))],
        backgroundColor: Colors.purple.shade500,
        title: const Text("Group",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            const Icon(Icons.account_circle,size: 150,
            color: Colors.grey,),
            Text(userName,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 30,),
            Divider(height: 2,),
            ListTile(
              selectedColor: Colors.purple,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal:20,vertical: 5 ),
              leading: Icon(Icons.exit_to_app),
              title: const Text('Groups',style: TextStyle(color: Colors.black),),
              onTap: ()async{



            },),
            ListTile(
              selectedColor: Colors.purple,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal:20,vertical: 5 ),
              leading: Icon(Icons.group),
              title: Text('Profile',style: TextStyle(color: Colors.black),),
              onTap: (){
                authService.signOut().whenComplete(() {{
                  nextScreen(context, ProfilePage(
                    userName:userName,
                    email:email
                  ));
                }
                });


              },),
            ListTile(
              selectedColor: Colors.purple,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal:20,vertical: 5 ),
              leading: Icon(Icons.group),
              title: Text('LogOut',style: TextStyle(color: Colors.black),),
              onTap: (){
                showDialog(
                    barrierDismissible: false,
                    context: context, builder: (context){
                  return  AlertDialog(
                   content: Text('LogOut',style: TextStyle(color: Colors.black),),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await authService.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                                  (route) => false);
                        },
                        icon: const Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                });
                authService.signOut().whenComplete(() {{
                  nextScreen(context, const LoginPage());
                }
                });



              },),



          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Colors.purple,
        child: Icon(Icons.add,color: Colors.white,size: 30,),

      ),
    );
  }
popUpDialog(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: ((context, setState) {
          return AlertDialog(
            title: const Text(
              "Create a group",
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true
                    ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                )
                    : TextField(
                  onChanged: (val) {
                    setState(() {
                      groupName = val;
                    });
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(20)),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(20))),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
                child: const Text("CANCEL",style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (groupName != "") {
                    setState(() {
                      _isLoading = true;
                    });
                    DatabaseServices(
                        uid: FirebaseAuth.instance.currentUser!.uid)
                        .createGroup(userName,
                        FirebaseAuth.instance.currentUser!.uid, groupName)
                        .whenComplete(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                    showSnackbar(
                        context, Colors.green, "Group created successfully.");
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
                child: const Text("CREATE",style: TextStyle(color: Colors.white),),
              )
            ],
          );
        }));
      });

}
  groupList() {
  return StreamBuilder(stream: groups, builder: (context,AsyncSnapshot snapshot){
    if(snapshot.hasData){
      if(snapshot.data['groups']!=null){
        if(snapshot.data['groups'].length !=0){
          return ListView.builder(
              itemCount: snapshot.data["groups"].length,
              itemBuilder: (context,index){
                return GroupTile(userName: snapshot.data['fullName'],
                    groupId: getId(snapshot.data['groups'][index]),
                    groupNmae: getName(snapshot.data['groups'][index]));
              });

        }else{
          return noGroupWidget();
        }
        

      }else{
        return noGroupWidget();
      }


    }else{
      return Center(child: CircularProgressIndicator(color: Colors.red,),);
    }
  }
  );
  }

  noGroupWidget() {
  return Container(
    padding: EdgeInsets.all(5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            popUpDialog(context);
          },
          child: Icon(
            Icons.add_circle,
            color: Colors.grey[700],
            size: 75,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
          textAlign: TextAlign.center,
        )

    ],),
  );
  }


}
