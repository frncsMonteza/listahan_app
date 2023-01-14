import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:listahan_app/user.dart';
import 'package:listahan_app/transaction.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:quickalert/quickalert.dart';

class UpdateDetails extends StatefulWidget {
  UpdateDetails({
    super.key,
    required this.transactions,
  });
  int totalMoneyInData = 0;
  int totalMoneyOutData = 0;
  int balance = 0;
  int oldtotalMoneyInData = 0;
  int oldtotalMoneyOutData = 0;
  int oldbalance = 0;
  final Transactions transactions;
  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
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
    dateController = TextEditingController(
      text: widget.transactions.date,
    );
    timeController = TextEditingController(
      text: widget.transactions.time,
    );
    addTypeController = TextEditingController(
      text: widget.transactions.addType,
    );
    amountController = TextEditingController(
      text: widget.transactions.amount.toString(),
    );
    noteController = TextEditingController(
      text: widget.transactions.note,
    );
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
                  width: 55,
                ),
                Column(
                  children: [
                    Text(
                      widget.transactions.addType == "Money In"
                          ? 'Money In'
                          : 'Money Out',
                      style: TextStyle(
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: widget.transactions.addType == "Money In"
                            ? Colors.green
                            : Colors.red,
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
                  color: widget.transactions.addType == "Money In"
                      ? Colors.green
                      : Colors.red,
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
                    const SizedBox(
                      height: 10,
                    ),
                    dateField(),
                    const SizedBox(
                      height: 10,
                    ),
                    timeField(),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: amountController,
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'League Spartan',
                          color: widget.transactions.addType == "Money In"
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 25),
                          prefixIcon: const ImageIcon(
                            AssetImage('assets/images/phpicon.png'),
                            size: 24.0,
                            color: Colors.black,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          floatingLabelStyle: const TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: 26,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: widget.transactions.addType == "Money In"
                                  ? Colors.green
                                  : Colors.red,
                              width: 3,
                            ),
                          ),
                          labelStyle: const TextStyle(
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
                      height: 30,
                    ),
                    editSaleBtn(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
    Navigator.pop(context);
    alert(Icons.warning_amber, "Warning", "Amount should not be '0'!",
        Colors.orange);
  }

  Widget dateField() => Container(
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
              String format = DateFormat('yyyy-MM-dd').format(pickedDate);
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
      );

  Widget timeField() => Container(
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
              DateTime parsedTime =
                  DateFormat.jm().parse(pickedTime.format(context).toString());
              String formattedTime = DateFormat('jm').format(parsedTime);

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
            labelStyle: TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 18,
            ),
            labelText: 'Time',
          ),
          cursorColor: Colors.black,
        ),
      );

  Widget editSaleBtn() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 230,
            decoration: BoxDecoration(
              color: widget.transactions.addType == "Money In"
                  ? Colors.green
                  : Colors.red,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),

            //   child: FloatingActionButton.extended(
            //     label: const Text(
            //       "Edit Sale",
            //       style: TextStyle(
            //         fontFamily: 'League Spartan',
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white,
            //       ),
            //     ),
            //     backgroundColor: widget.transactions.addType == "Money In"
            //         ? Colors.green
            //         : Colors.red,
            //     onPressed: () {
            //       actionsheetUpdate(context, widget.transactions.id);
            //       Navigator.pop(context);
            //     },
            //   ),
            // ),
            child: Center(
              child: TextButton(
                child: const Text(
                  'Edit Sale',
                  style: TextStyle(
                      fontFamily: 'League Spartan',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                onPressed: () {
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      text: 'You want to edit this transaction?',
                      showCancelBtn: true,
                      confirmBtnColor: Colors.green,
                      onCancelBtnTap: () => Navigator.pop(context),
                      onConfirmBtnTap: () {
                        if (amountController.text == "0") {
                          return buttonFunction();
                        } else if (amountController.text == "") {
                          Navigator.pop(context);
                          alert(Icons.error, "Failed",
                              "Transaction was not edited!", Colors.red);
                        } else {
                          editTransaction(user.uid);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TransactionHome(),
                            ),
                          );
                          alert(Icons.update, "Edited",
                              "You edited it succesfully", Colors.green);
                        }
                      });
                  // actionsheetUpdate(context, widget.transactions.id);
                },
              ),
            ),
          ),
        ],
      );

  void actionsheetUpdate(BuildContext context, String id) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Confirmation',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'League Spartan',
            color: Colors.black,
          ),
        ),
        message: const Text(
          'Are you sure you want to edit this transaction?',
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'League Spartan',
            color: Colors.black,
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              if (amountController.text == "0") {
                return buttonFunction();
              } else {
                // editTransaction(user.uid);
                // updateTransactions(widget.transactions.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionHome(),
                  ),
                );
                alert(Icons.update, "Success", "Edited Succesfully",
                    Colors.green);
              }
            },
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'League Spartan',
                color: Colors.red,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'League Spartan',
              color: Colors.black,
            ),
          ),
          onPressed: () => Navigator.pop(context),
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

  // updateTransactions(String id) {
  //   final docUser = FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(user.uid)
  //       .collection('Transactions')
  //       .doc(id);
  //   docUser.update({
  //     'date': dateController.text,
  //     'time': timeController.text,
  //     'addType': addTypeController.text,
  //     'amount': int.parse(
  //       amountController.text,
  //     ),
  //     'note': noteController.text,
  //   });
  //   Navigator.pop(context);
  // }

  editTransaction(String id) async {
    final docUser = FirebaseFirestore.instance.collection('Users').doc(id);
    final docUser1 = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Transactions')
        .doc(widget.transactions.id);
    var totalMoneyIn = await docUser.get().then((value) {
      return value.get('totalMoneyIn');
    });
    var totalMoneyOut = await docUser.get().then((value) {
      return value.get('totalMoneyOut');
    });
    var balance = await docUser.get().then((value) {
      return value.get('balance');
    });
    var oldamount = await docUser1.get().then((value) {
      return value.get('amount');
    });
    widget.oldtotalMoneyInData = widget.transactions.addType == 'Money In'
        ? totalMoneyIn - oldamount
        : totalMoneyIn;
    widget.oldtotalMoneyOutData = widget.transactions.addType == 'Money Out'
        ? totalMoneyOut - oldamount
        : totalMoneyOut;
    widget.oldbalance = balance;

    // ignore: unrelated_type_equality_checks
    widget.totalMoneyInData = widget.transactions.addType == 'Money In'
        ? int.parse(amountController.text) + widget.oldtotalMoneyInData
        : widget.oldtotalMoneyInData;
    // ignore: unrelated_type_equality_checks
    widget.totalMoneyOutData = widget.transactions.addType == 'Money Out'
        ? int.parse(amountController.text) + widget.oldtotalMoneyOutData
        : widget.oldtotalMoneyOutData;

    // ignore: unrelated_type_equality_checks
    // widget.balance = widget.transactions.addType == 'Money In'
    //     ? widget.oldbalance + int.parse(amountController.text)
    //     : widget.oldbalance - int.parse(amountController.text);
    widget.balance = widget.totalMoneyInData - widget.totalMoneyOutData;
    // print(totalMoneyOut);
    // print('-');
    // print(oldamount);
    // print('=');
    // print(widget.oldtotalMoneyOutData);
    // print(widget.oldtotalMoneyOutData);
    // print(widget.oldbalance);
    // print(widget.totalMoneyOutData);
    // print(widget.totalMoneyOutData);
    print(widget.oldbalance);
    docUser.update({
      'totalMoneyIn': widget.totalMoneyInData,
      'totalMoneyOut': widget.totalMoneyOutData,
      'balance': widget.balance,
    });
    docUser1.update({
      'date': dateController.text,
      'time': timeController.text,
      'addType': addTypeController.text,
      'amount': int.parse(
        amountController.text,
      ),
      'note': noteController.text,
    });
  }
}
