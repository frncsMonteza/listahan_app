import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:listahan_app/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:quickalert/quickalert.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.users});

  final Users users;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final user = FirebaseAuth.instance.currentUser!;
  late TextEditingController usernameController;

  late TextEditingController passwordController;
  late TextEditingController emailController;
  DateTime selectedDate = DateTime.now();
  late String imgUrl;
  late bool _visibility;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future uploadFile() async {
    final path = 'files/${generateRandomString(5)}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {
      Navigator.pop(context);
      alert(
          Icons.update, "Success", "Profile Changed Succesfully", Colors.green);
    });
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');

    updateUser(widget.users.id, urlDownload);

    setState(() {
      uploadTask = null;
    });
  }

  @override
  void initState() {
    usernameController = TextEditingController(text: widget.users.username);

    passwordController = TextEditingController(text: widget.users.password);
    emailController = TextEditingController(text: widget.users.email);
    imgUrl = widget.users.image;
    _visibility = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Change Avatar',
          style: TextStyle(
            fontFamily: 'League Spartan',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: const Icon(Icons.keyboard_backspace),
          color: Colors.white,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 60,
          ),
          readInfo(user.uid),
        ],
      ),
    );
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
                child: editP(currentUser),
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

  Widget editP(Users users) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(19.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Choose Image',
                style: TextStyle(
                  fontFamily: 'League Spartan',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                child: Center(
                  child: (pickedFile == null) ? checkImgVal() : imgExist(),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  selectFile();
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Add Photo'),
              ),

              // const SizedBox(
              //   height: 25,
              // ),
              // TextField(
              //   onTap: () async {
              //     final date = await pickDate();
              //     if (date == null) return;
              //     setState((() => birthdatecontroller.text =
              //         DateFormat('MM/dd/yyyy').format(date)));
              //     final int age = DateTime.now().year - date.year;
              //     agecontroller.text = age.toString();
              //   },
              //   controller: birthdatecontroller,
              //   readOnly: true,
              //   style: const TextStyle(color: Colors.white),
              //   decoration: const InputDecoration(
              //     prefixIcon: Icon(
              //       Icons.calendar_month,
              //       color: Colors.white,
              //     ),
              //     labelText: "Birthdate",
              //     labelStyle: TextStyle(color: Colors.white),
              //     filled: false,
              //     fillColor: Colors.white70,
              //     iconColor: Colors.white70,
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(20)),
              //       borderSide: BorderSide(
              //         color: Colors.white54,
              //         width: 2.5,
              //       ),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Colors.white70,
              //         width: 2.5,
              //       ),
              //       borderRadius: BorderRadius.all(Radius.circular(20)),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 25,
              // ),
              // TextField(
              //   readOnly: true,
              //   controller: agecontroller,
              //   style: const TextStyle(color: Colors.white),
              //   decoration: const InputDecoration(
              //     prefixIcon: Icon(
              //       Icons.people,
              //       color: Colors.white,
              //     ),
              //     labelText: "Age",
              //     labelStyle: TextStyle(color: Colors.white),
              //     filled: false,
              //     fillColor: Colors.white70,
              //     iconColor: Colors.white70,
              //     enabledBorder: OutlineInputBorder(
              //       //Outline border type for TextFeild
              //       borderRadius: BorderRadius.all(Radius.circular(20)),
              //       borderSide: BorderSide(
              //         color: Colors.white54,
              //         width: 2.5,
              //       ),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Colors.white70,
              //         width: 3,
              //       ),
              //       borderRadius: BorderRadius.all(Radius.circular(20)),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              Container(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (pickedFile == null) {
                      alert(Icons.warning_amber, "Warning",
                          "You did not select image!", Colors.orange);
                    } else {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: 'You want to change your avatar?',
                          showCancelBtn: true,
                          confirmBtnColor: Colors.green,
                          onCancelBtnTap: () => Navigator.pop(context),
                          onConfirmBtnTap: () {
                            uploadFile();
                            Navigator.pop(context);
                          });

                      // changeAuthPassword(passwordcontroller.text);
                    }
                  },
                  icon: const Icon(Icons.edit),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  label: const Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              buildProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 50,
          );
        }
      });

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

  Widget imgExist() => Image.file(
        File(pickedFile!.path!),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget imgNotExist() => Image.network(
        widget.users.image,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget imgNotExistBlank() => Image.asset(
        'assets/images/No-photo.png',
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget checkImgVal() {
    return (widget.users.image == '-') ? imgNotExistBlank() : imgNotExist();
  }

  // changeAuthPassword(password) {
  //   try {
  //     FirebaseAuth.instance.signOut();
  //     user.updatePassword(password);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future updateUser(String id, String image) async {
    final docUser = FirebaseFirestore.instance.collection('Users').doc(id);
    await docUser.update({
      'password': passwordController.text,
      'email': emailController.text,
      'username': usernameController.text,
      'image': image,
    });

    Navigator.pop(context);
  }

  // Future updateNoFile(String id) async {
  //   final docUser = FirebaseFirestore.instance.collection('Users').doc(id);
  //   await docUser.update({
  //     'password': passwordController.text,
  //     'email': emailController.text,
  //     'username': usernameController.text,
  //   });

  //   Navigator.pop(context);
  // }

  // Future<DateTime?> pickDate() => showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(1960),
  //       lastDate: DateTime(2023),
  //       helpText: 'Select Birthdate',
  //     );

  Stream<List<Users>> readUser() =>
      FirebaseFirestore.instance.collection('User').snapshots().map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) => Users.fromJson(
                    doc.data(),
                  ),
                )
                .toList(),
          );
}
