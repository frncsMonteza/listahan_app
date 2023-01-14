import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listahan_app/register.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:quickalert/quickalert.dart';

class Login1 extends StatefulWidget {
  const Login1({super.key});

  @override
  State<Login1> createState() => _Login1State();
}

class _Login1State extends State<Login1> {
  final logInKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late String error;
  bool isPasswordVisible = true;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    error = "";
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: logInKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo1.png',
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                        ),
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
                          // topRight: Radius.circular(60),
                          // bottomLeft: Radius.circular(50),
                          // bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              'Welcome',
                              style: TextStyle(
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Sign in to your account',
                              style: TextStyle(
                                fontFamily: 'League Spartan',
                                fontSize: 22,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 30),
                            emailTextField(),
                            const SizedBox(height: 10),
                            passwordTextField(),
                            const SizedBox(height: 10),
                            signInButton(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have any account?",
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  child: const Text(
                                    'Sign Up',
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
                                        builder: (context) => const Register(),
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

  Widget emailTextField() => Container(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (email) {
            if (email != null && !EmailValidator.validate(email)) {
              return 'Enter a valid email';
            } else {
              return null;
            }
          },
          cursorColor: Colors.black,
        ),
      );

  Widget passwordTextField() => Container(
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
            suffixIcon: IconButton(
              icon: isPasswordVisible
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
              onPressed: () =>
                  setState(() => isPasswordVisible = !isPasswordVisible),
            ),
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
            labelText: 'Password',
          ),
          cursorColor: Colors.black,
        ),
      );

  Widget signInButton() => Form(
        autovalidateMode: AutovalidateMode.always,
        child: Container(
          height: 55,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ElevatedButton(
            onPressed: () {
              signIn();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 10,
              ),
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(
                fontFamily: 'League Spartan',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  void showToast(msg, color) => Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 22.0,
      );
  Future signIn() async {
    final isValid = logInKey.currentState!.validate();
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
    // QuickAlert.show(
    //   context: context,
    //   type: QuickAlertType.loading,
    //   title: 'Loading',
    //   text: 'Fetching your data',
    // );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      setState(() {
        error = "";
        alert(Icons.check_circle_outline, "Signed In",
            "You succesfully signed in", Colors.green);
        // showToast("Gappppdasdasd", Colors.greenAccent);
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        error = e.message.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            textAlign: TextAlign.center,
            error,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    Navigator.pop(context);
    // alert(Icons.check_circle_outline, "Signed In", "You succesfully signed in",
    //     Colors.green);
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
}
