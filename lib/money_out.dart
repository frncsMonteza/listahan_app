import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listahan_app/register.dart';
import 'package:listahan_app/transaction.dart';
import 'package:intl/intl.dart';
import 'package:listahan_app/user.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class MoneyOut extends StatefulWidget {
  MoneyOut({super.key});
  int totalMoneyInData = 0;
  int totalMoneyOutData = 0;
  int balance = 0;
  @override
  State<MoneyOut> createState() => _MoneyOutState();
}

class _MoneyOutState extends State<MoneyOut> {
  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final format = DateFormat('yyyy-MM-dd');
  final formatTime = DateFormat('jm');
  DateTime datetime = DateTime.now();
  bool isButtonClickable = true;

  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController addTypeController;
  late TextEditingController amountController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    addTypeController = TextEditingController();
    addTypeController.text = "Money Out";

    dateController = TextEditingController();
    dateController.text = format.format(DateTime.now());

    timeController = TextEditingController();
    timeController.text = formatTime.format(DateTime.now());

    amountController = TextEditingController();
    amountController.text = "0";

    noteController = TextEditingController();
  }

  @override
  void dispose() {
    addTypeController.dispose();
    dateController.dispose();
    timeController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Column(
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      tooltip: 'Go back to Transaction',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 80,
                  width: 40,
                ),
                Column(
                  children: const [
                    Text(
                      'Money Out',
                      style: TextStyle(
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 685,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 4,
                ),
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        readOnly: true,
                        controller: addTypeController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.category,
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
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.black,
                          //   ),
                          // ),
                          labelStyle: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: 18,
                          ),
                          labelText: 'Type',
                        ),
                        cursorColor: Colors.black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        readOnly: true,
                        controller: dateController,
                        onTap: (() async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null) {
                            String format =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              dateController.text = format.toString();
                            });
                          } else {
                            print("Not Selected");
                          }
                        }),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.calendar_month,
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
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.black,
                          //   ),
                          // ),
                          labelStyle: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: 18,
                          ),

                          labelText: 'Date',
                        ),
                        cursorColor: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        readOnly: true,
                        controller: timeController,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if (pickedTime != null) {
                            DateTime parsedTime = DateFormat.jm()
                                .parse(pickedTime.format(context).toString());
                            String formattedTime =
                                DateFormat('jm').format(parsedTime);

                            setState(() {
                              timeController.text = formattedTime;
                            });
                          } else {
                            print("Time is not selected");
                          }
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            CupertinoIcons.clock_fill,
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
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.black,
                          //   ),
                          // ),
                          labelStyle: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: 18,
                          ),
                          labelText: 'Time',
                        ),
                        cursorColor: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: amountController,
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'League Spartan',
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 25),
                          prefixIcon: ImageIcon(
                            AssetImage('assets/images/phpicon.png'),
                            size: 24.0,
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
                            fontSize: 26,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 3,
                            ),
                          ),
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.black,
                          //   ),
                          // ),
                          labelStyle: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                          ),

                          labelText: 'Amount',
                        ),
                        cursorColor: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: noteController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.event_note,
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
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.black,
                          //   ),
                          // ),
                          labelStyle: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: 18,
                          ),
                          labelText: 'Note',
                        ),
                        cursorColor: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 250,
                          child: FloatingActionButton.extended(
                            label: const Text(
                              'Add Expense',
                              style: TextStyle(
                                fontFamily: 'League Spartan',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.red,
                            onPressed: () {
                              if (amountController.text == "0") {
                                return buttonFunction();
                              } else if (amountController.text == "") {
                                alert(Icons.error, "Failed",
                                    "Transaction was not added!", Colors.red);
                              } else {
                                editTransaction(user.uid);
                                addMoneyOut();

                                Navigator.pop(context);
                                alert(
                                    Icons.add_task,
                                    "Success",
                                    "Transaction Added Succesfully",
                                    Colors.green);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  void showToast(msg) => Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 22.0,
      );

  void buttonFunction() async {
    Duration seconds = const Duration(seconds: 2);
    setState(() {
      isButtonClickable = false;
    });
    Future.delayed(seconds, () {
      setState(() {
        isButtonClickable = true;
      });
    });
    alert(Icons.warning_amber, "Warning", "Please input amount greater than 0!",
        Colors.orange);
    // showToast("Amount should not be '0'! ");
  }

  Future addMoneyOut() async {
    final docUser = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Transactions')
        .doc();

    final newTransaction = Transactions(
      id: docUser.id,
      addType: addTypeController.text,
      date: dateController.text,
      time: timeController.text,
      amount: int.parse(amountController.text),
      note: noteController.text,
    );

    final json = newTransaction.toJson();
    await docUser.set(json);

    setState(() {
      addTypeController.text = "";
      dateController.text = "";
      timeController.text = "";
      amountController.text = "";
      noteController.text = "";
    });
  }

  editTransaction(String id) async {
    final docUser = FirebaseFirestore.instance.collection('Users').doc(id);

    var totalMoneyIn = await docUser.get().then((value) {
      return value.get('totalMoneyIn');
    });
    var totalMoneyOut = await docUser.get().then((value) {
      return value.get('totalMoneyOut');
    });
    var balance = await docUser.get().then((value) {
      return value.get('balance');
    });

    // ignore: unrelated_type_equality_checks
    widget.totalMoneyInData = addTypeController.text == 'Money In'
        ? int.parse(amountController.text) + totalMoneyIn
        : totalMoneyIn;
    // ignore: unrelated_type_equality_checks
    widget.totalMoneyOutData = addTypeController.text == 'Money Out'
        ? int.parse(amountController.text) + totalMoneyOut
        : totalMoneyOut;

    // ignore: unrelated_type_equality_checks
    widget.balance = addTypeController.text == 'Money In'
        ? balance + int.parse(amountController.text)
        : balance - int.parse(amountController.text);

    docUser.update({
      'totalMoneyIn': widget.totalMoneyInData,
      'totalMoneyOut': widget.totalMoneyOutData,
      'balance': widget.balance,
    });
  }
}
