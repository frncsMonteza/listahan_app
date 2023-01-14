import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listahan_app/user.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: Colors.black45,
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Container(
                  height: 620,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(210, 60),
                      topRight: Radius.elliptical(210, 60),
                      bottomLeft: Radius.elliptical(210, 60),
                      bottomRight: Radius.elliptical(210, 60),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<List<Users>>(
                        stream: readUsers(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Something went wrong! ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            final user = snapshot.data!;

                            return ListView(
                              children: [
                                Center(
                                  child: Wrap(
                                    children: user.map(userInfo).toList(),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      // const Text(
                      //   'Signed in as',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 8,
                      // ),
                      // Text(
                      //   user.email!,
                      //   style: const TextStyle(
                      //     fontSize: 20,
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 40,
                      // ),
                      // read(user.uid),
                      // const SizedBox(
                      //   height: 40,
                      // ),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.logout,
                          size: 28,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                        },
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userInfo(Users user) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.black,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              leading: const Icon(
                Icons.access_alarm_outlined,
              ),
              title: Text(user.email),
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              leading: const Icon(
                Icons.access_alarm_outlined,
              ),
              title: Text(user.username),
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              leading: const Icon(
                Icons.access_alarm_outlined,
              ),
              title: Text('123'),
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              leading: const Icon(
                Icons.access_alarm_outlined,
              ),
              title: Text('123'),
            ),
          ],
        ),
      );

  Widget buildUser(Users user) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("User ID:"),
              Text(
                user.id,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Username:"),
              Text(
                user.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Email:"),
              Text(
                user.email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Password:"),
              Text(
                user.password,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      );

  Widget read(uid) {
    var collection = FirebaseFirestore.instance.collection('Users');
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: collection.doc(uid).snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasError) return Text('Error = ${snapshot.error}');

              if (snapshot.hasData) {
                final users = snapshot.data!.data();
                final newUser = Users(
                  id: users!['id'],
                  image: users['image'],
                  username: users['username'],
                  password: users['password'],
                  email: users['email'],
                  totalMoneyIn: users['totalMoneyIn'],
                  totalMoneyOut: users['totalMoneyOut'],
                  balance: users['balance'],
                );

                return buildUser(newUser);
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Stream<List<Users>> readUsers() =>
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
