import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listahan_app/login1.dart';
import 'package:listahan_app/register.dart';
import 'package:listahan_app/transaction.dart';
import 'package:listahan_app/user.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final regKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPassController;
  late TextEditingController emailController;
  late String error;
  bool isPasswordVisible = true;
  bool isPasswordVisible1 = true;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();
    confirmPassController = TextEditingController();
    error = "";
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: regKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 150),
                        Column(
                          children: const [
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                fontFamily: 'League Spartan',
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Create an account. It's free!",
                              style: TextStyle(
                                fontFamily: 'League Spartan',
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 150),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              'Come and join us!',
                              style: TextStyle(
                                fontFamily: 'League Spartan',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            userField(),
                            const SizedBox(height: 10),
                            emailField(),
                            const SizedBox(height: 10),
                            passField(),
                            const SizedBox(height: 10),
                            confirmPassField(),
                            const SizedBox(height: 10),
                            Form(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Container(
                                height: 55,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    registerUser();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 100,
                                      vertical: 10,
                                    ),
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontFamily: 'League Spartan',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  child: const Text(
                                    'Sign in',
                                    style: TextStyle(
                                      fontFamily: 'League Spartan',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Login1(),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userField() => Container(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (username) {
            if (username!.isEmpty) {
              return "Please enter username";
            }
          },
          controller: usernameController,
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
            floatingLabelStyle: TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 22,
              color: Colors.black,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
            errorStyle: TextStyle(
              fontFamily: 'League Spartan',
              height: 0,
              fontStyle: FontStyle.italic,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            labelStyle: TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 18,
            ),
            labelText: 'Username',
          ),
          cursorColor: Colors.black,
        ),
      );

  Widget emailField() => Container(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (email) {
            if (email != null && !EmailValidator.validate(email)) {
              return 'Enter a valid email';
            } else {
              return null;
            }
          },
          controller: emailController,
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
            floatingLabelStyle: TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 22,
              color: Colors.black,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
            errorStyle: TextStyle(
              fontFamily: 'League Spartan',
              height: 0,
              fontStyle: FontStyle.italic,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            labelStyle: TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 18,
            ),
            labelText: 'Email',
          ),
          cursorColor: Colors.black,
        ),
      );

  Widget passField() => Container(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (password) {
            if (password!.isEmpty) {
              return "Please enter password";
            }
            if (password.length < 6) {
              return "Please enter 6 digits password";
            }
          },
          obscureText: isPasswordVisible,
          controller: passwordController,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock,
              color: Colors.black,
            ),
            suffixIcon: passwordVisibility(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
            floatingLabelStyle: const TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 22,
              color: Colors.black,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
            errorStyle: const TextStyle(
              fontFamily: 'League Spartan',
              height: 0,
              fontStyle: FontStyle.italic,
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            // border: const OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Colors.black,
            //   ),
            // ),
            labelStyle: const TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 18,
            ),
            labelText: 'Password',
          ),
          cursorColor: Colors.black,
        ),
      );
  Widget confirmPassField() => Container(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (password) {
            if (password!.isEmpty) {
              return "Please enter password";
            }
            if (password.length < 6) {
              return "Please enter 6 digits password";
            }
            if (passwordController.text != confirmPassController.text) {
              return "Password dont match";
            }
          },
          obscureText: isPasswordVisible1,
          controller: confirmPassController,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock,
              color: Colors.black,
            ),
            suffixIcon: passwordVisibility1(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
            floatingLabelStyle: const TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 22,
              color: Colors.black,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
            errorStyle: const TextStyle(
              fontFamily: 'League Spartan',
              height: 0,
              fontStyle: FontStyle.italic,
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            labelStyle: const TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 18,
            ),
            labelText: 'Confirm Password',
          ),
          cursorColor: Colors.black,
        ),
      );

  Widget passwordVisibility() => IconButton(
        icon: isPasswordVisible
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility),
        onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
      );
  Widget passwordVisibility1() => IconButton(
        icon: isPasswordVisible1
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility),
        onPressed: () =>
            setState(() => isPasswordVisible1 = !isPasswordVisible1),
      );

  void showToast(msg) => Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 22.0,
      );
  Future registerUser() async {
    final isValid = regKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitFoldingCube(
          color: Colors.white,
          size: 50,
        ),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      createUser();

      setState(() {
        error = "";
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        error = e.message.toString();
      });
      // if (error != "") {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            textAlign: TextAlign.center,
            error,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
      // } else {
      //   return showToast("Register succesfully!");
      // }
    }
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    alert(Icons.update, "Signed Up", "You succesfully signed up", Colors.green);
  }

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

  Future createUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;

    final docUser = FirebaseFirestore.instance.collection('Users').doc(userid);

    final newUser = Users(
      id: userid,
      image: "-",
      username: usernameController.text,
      password: passwordController.text,
      email: emailController.text,
      totalMoneyIn: 0,
      totalMoneyOut: 0,
      balance: 0,
    );

    final json = newUser.toJson();
    await docUser.set(json);

    Navigator.pop(context);
  }
}
