import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:listahan_app/editprofile.dart';
import 'package:listahan_app/login1.dart';
import 'package:listahan_app/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:quickalert/quickalert.dart';

class Account1 extends StatefulWidget {
  const Account1({super.key});

  @override
  State<Account1> createState() => _Account1State();
}

class _Account1State extends State<Account1> {
  final user = FirebaseAuth.instance.currentUser!;
  late bool isObscure;
  late String pass;
  @override
  void initState() {
    isObscure = true;
    pass = "*****";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: BackButton(
            color: Colors.white,
          ),
          centerTitle: true,
          title: const Text(
            'Profile Page',
            style: TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            readInfo(user.uid),
          ],
        ));
  }

  Widget readInfo(uid) {
    var collection = FirebaseFirestore.instance.collection('Users');
    return Column(
      children: [
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: collection.doc(uid).snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final users = snapshot.data!.data();
              final currentUser = Users(
                id: users!['id'],
                image: users['image'],
                username: users['username'],
                password: users['password'],
                email: users['email'],
                totalMoneyIn: users['totalMoneyIn'],
                totalMoneyOut: users['totalMoneyOut'],
                balance: users['balance'],
              );
              return SingleChildScrollView(
                child: profile(currentUser),
              );
            } else {
              return const Center(
                child: SpinKitFoldingCube(
                  color: Colors.white,
                  size: 50,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget profile(Users users) => Column(
        // shrinkWrap: true,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(88),
                    topRight: Radius.circular(88),
                    bottomLeft: Radius.circular(88),
                    bottomRight: Radius.circular(88),
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: (users.image != "-")
                      ? NetworkImage(users.image)
                      : const NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/flutterfirebasedb-3aedb.appspot.com/o/files%2FAccountPerson.png?alt=media&token=4331241a-3e5f-4372-aba2-24e282bd4f84'),
                  radius: 85,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton.small(
                          backgroundColor: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(
                                  users: users,
                                ),
                              ),
                            );
                            // showToast(
                            //     "Email and password configuration can be done outside the page.");
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     TextButton.icon(
              //       icon: const Icon(
              //         Icons.edit,
              //         size: 28,
              //         color: Colors.black,
              //       ),
              //       onPressed: () {},
              //       label: const Text(
              //         'Change Avatar',
              //         style: TextStyle(
              //             fontFamily: 'League Spartan',
              //             fontSize: 24,
              //             color: Colors.black),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                  ),
                  child: SizedBox(
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "PERSONAL INFO",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                            // IconButton(
                            //   onPressed: () {},
                            //   color: Colors.deepPurple.shade100,
                            //   icon: const Icon(
                            //     Icons.edit,
                            //     color: Colors.white,
                            //   ),
                            // ),
                          ],
                        ),
                        ListTile(
                          title: const Text(
                            "Username",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            users.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          leading: const Icon(
                            Icons.account_box,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            "Email",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            users.email,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          leading: const Icon(
                            Icons.email,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            "User ID",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            users.id,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          leading: const Icon(
                            Icons.contact_mail_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            "Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            isObscure == false
                                ? users.password
                                : users.password.replaceAll(RegExp(r"."), "*"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          leading: const Icon(
                            Icons.password,
                            color: Colors.white,
                            size: 32,
                          ),
                          trailing: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            icon: Icon(
                              (!isObscure)
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.confirm,
                                    text: 'You want to Sign out?',
                                    showCancelBtn: true,
                                    confirmBtnColor: Colors.green,
                                    onCancelBtnTap: () =>
                                        Navigator.pop(context),
                                    onConfirmBtnTap: () {
                                      FirebaseAuth.instance.signOut();
                                      // int count = 0;
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => const Login1(),
                                      //   ),
                                      // );
                                      Navigator.popUntil(context,
                                          ModalRoute.withName('/Login1'));
                                      // Navigator.of(context).pop();
                                      // Navigator.of(context).pop();
                                      // Navigator.of(context)
                                      //     .popUntil((_) => count++ >= 1);
                                      alert(
                                          Icons.check_circle_outline,
                                          "Signed Out",
                                          "You succesfully signed out",
                                          Colors.green);
                                    });

                                // // FirebaseAuth.instance.signOut();
                                // // Navigator.pop(context);
                                // showDialog(
                                //   context: context,
                                //   builder: (context) => AlertDialog(
                                //     content: Text(
                                //       "Are you sure you want to log out ${users.email}?",
                                //       style: TextStyle(
                                //           fontFamily: 'League Spartan',
                                //           fontSize: 22,
                                //           color: Colors.black),
                                //     ),
                                //     actions: [
                                //       FloatingActionButton.small(
                                //         onPressed: () {
                                //           logOut();
                                //         },
                                //         child: const Icon(
                                //           Icons.check,
                                //           size: 20,
                                //         ),
                                //       ),
                                //       FloatingActionButton.small(
                                //         onPressed: () {
                                //           Navigator.of(context).pop();
                                //         },
                                //         child: const Icon(
                                //           Icons.close,
                                //           size: 20,
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                  // minimumSize: const Size.fromHeight(50),
                                  ),
                              label: const Text(
                                'Sign Out',
                                style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 24,
                                    color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      );
  // logOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   Navigator.pop(context);
  //   // Navigator.of(context).pushAndRemoveUntil(
  //   //     MaterialPageRoute(builder: (BuildContext context) {
  //   //   return const Login1();
  //   // }), (route) => false);
  // }

  void alert(icon, title, description, color) => MotionToast(
        icon: icon,
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'League Spartan',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        description: Text(
          description,
          style: const TextStyle(
            fontFamily: 'League Spartan',
            fontSize: 18,
          ),
        ),
        position: MotionToastPosition.top,
        animationType: AnimationType.fromTop,
        primaryColor: color,
      ).show(context);

  void showToast(msg) => Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 22.0,
      );

  Widget txtfield(String label, icon, Color color, controller) => TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: color,
          ),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: false,
          fillColor: Colors.white70,
          iconColor: Colors.white70,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(
              color: Colors.white54,
              width: 2.5,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white70,
              width: 2.5,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      );

  Stream<List<Users>> readUser() =>
      FirebaseFirestore.instance.collection('Users').snapshots().map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) => Users.fromJson(
                    doc.data(),
                  ),
                )
                .toList(),
          );
}
