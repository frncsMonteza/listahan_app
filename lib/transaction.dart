import 'dart:io';
import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import 'package:listahan_app/account1.dart';
import 'package:listahan_app/main.dart';

import 'package:listahan_app/money_in.dart';
import 'package:listahan_app/money_out.dart';
import 'package:listahan_app/pdfViewer.dart';

import 'package:listahan_app/update_details.dart';
import 'package:listahan_app/user.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:quickalert/quickalert.dart';

import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class TransactionHome extends StatefulWidget {
  const TransactionHome({
    super.key,
    // required this.transactions,
    // required this.users,
  });
  // final Users users;
  // final Transactions transactions;
  @override
  State<TransactionHome> createState() => _TransactionHomeState();
}

class _TransactionHomeState extends State<TransactionHome> {
  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final value = NumberFormat("#,##0.00", "en_US");
  // final value1 = DateFormat.Hm("h:mm a");
  late TextEditingController searchController;
  bool changed = false;
  int number = 0;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (_) => const PDFView(),
        //       ),
        //     );

        //     // final data = await PDF.generateTable();
        //     // PDF.openFile(data);
        //   },
        //   icon: const Icon(
        //     Icons.file_download_outlined,
        //     color: Colors.white,
        //   ),
        // ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Transactions',
          style: TextStyle(
            fontFamily: 'League Spartan',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Account1(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Container(
          //   color: Colors.black87,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       IconButton(
          //         onPressed: () {},
          //         icon: const Icon(
          //           Icons.calendar_month_outlined,
          //           color: Colors.white,
          //         ),
          //       ),
          //       TextButton(
          //         onPressed: () {},
          //         child: const Text(
          //           'Daily',
          //           style: TextStyle(
          //             fontFamily: 'League Spartan',
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //       TextButton(
          //         onPressed: () {},
          //         child: const Text(
          //           'Weekly',
          //           style: TextStyle(
          //             fontFamily: 'League Spartan',
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //       TextButton(
          //         onPressed: () {},
          //         child: const Text(
          //           'Monthly',
          //           style: TextStyle(
          //             fontFamily: 'League Spartan',
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //       TextButton(
          //         onPressed: () {},
          //         child: const Text(
          //           'Yearly',
          //           style: TextStyle(
          //             fontFamily: 'League Spartan',
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   color: Colors.black87,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       IconButton(
          //         onPressed: () {},
          //         icon: const Icon(
          //           Icons.arrow_back_ios,
          //           color: Colors.white,
          //         ),
          //       ),
          //       const Text(
          //         '2022',
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontFamily: 'League Spartan',
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white,
          //         ),
          //       ),
          //       IconButton(
          //         onPressed: () {},
          //         icon: const Icon(
          //           Icons.arrow_forward_ios,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            color: Colors.black87,
            child: Column(
              children: [
                const SizedBox(height: 20),
                read(user.uid),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      child: Container(
                        width: 300,
                        height: 120,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          '₱ ',
                                          style: TextStyle(
                                            fontFamily: 'League Spartan',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                        realtimeData(
                                          user.uid,
                                          'totalMoneyIn',
                                          const TextStyle(
                                            fontFamily: 'League Spartan',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Total Sales',
                                      style: TextStyle(
                                        fontFamily: 'League Spartan',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.black26,
                                  height: 80,
                                  width: 2,
                                ),
                                // const VerticalDivider(
                                //   color: Colors.red,
                                // ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          '₱ ',
                                          style: TextStyle(
                                            fontFamily: 'League Spartan',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        realtimeData(
                                          user.uid,
                                          'totalMoneyOut',
                                          const TextStyle(
                                            fontFamily: 'League Spartan',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Total Expense',
                                      style: TextStyle(
                                        fontFamily: 'League Spartan',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.black26,
                              height: 2,
                              width: 300,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'Profit',
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      '₱ ',
                                      style: TextStyle(
                                        fontFamily: 'League Spartan',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    realtimeData(
                                      user.uid,
                                      'balance',
                                      const TextStyle(
                                        fontFamily: 'League Spartan',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 320,
                      height: 40,
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            if (searchController.text == "") {
                              changed = false;
                            } else {
                              changed = true;
                            }
                          });
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.fromLTRB(100, 0, 40, 20),
                            hintText: 'Search from note',
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 30,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Transactions>>(
              stream: readTransaction(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong! ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final transactions = snapshot.data!;

                  return changed == false
                      ? GroupedListView(
                          padding: const EdgeInsets.only(top: 20, bottom: 45),
                          elements: transactions,
                          groupBy: (element) => element.date,
                          groupSeparatorBuilder: (String groupByValue) =>
                              Padding(
                            padding:
                                const EdgeInsets.only(left: 20, bottom: 15),
                            child: Text(
                              groupByValue ==
                                      DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now())
                                  ? 'Today'
                                  : groupByValue,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'League Spartan',
                                  color: Colors.black,
                                  fontSize: 22),
                            ),
                          ),
                          itemBuilder: ((context, value) {
                            return transactionTile(value);
                          }),
                          order: GroupedListOrder.DESC,
                        )
                      : ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: ((context, index) {
                            var searchData = transactions[index];
                            return searchData.note
                                    .toString()
                                    .toLowerCase()
                                    .contains(
                                        searchController.text.toLowerCase())
                                ? transactionTile(searchData)
                                : Container();
                          }),
                        );
                  // return Column(
                  //   children: transactions.map(transactionTile).toList(),
                  // );
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
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
            width: 150,
            child: FloatingActionButton.extended(
              heroTag: 'Money In',
              label: const Text(
                'Money In',
                style: TextStyle(
                  fontFamily: 'League Spartan',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoneyIn(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            height: 60,
            width: 150,
            child: FloatingActionButton.extended(
              heroTag: 'Money Out',
              label: const Text(
                'Money Out',
                style: TextStyle(
                  fontFamily: 'League Spartan',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.red,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoneyOut(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionTile(Transactions transactions) => ListTile(
        leading: transactions.addType == "Money In"
            ? const Icon(
                Icons.arrow_circle_up,
                size: 40,
                color: Colors.green,
              )
            : const Icon(
                Icons.arrow_circle_down,
                size: 40,
                color: Colors.red,
              ),
        title: Text(
          transactions.note,
          style: const TextStyle(
            fontFamily: 'League Spartan',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          transactions.time,
          style: const TextStyle(
            fontFamily: 'League Spartan',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        trailing: Text(
          transactions.addType == "Money In"
              ? '+ ₱ ${value.format(transactions.amount)}'
              : '- ₱ ${value.format(transactions.amount)}',
          style: TextStyle(
            fontFamily: 'League Spartan',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color:
                transactions.addType == "Money In" ? Colors.green : Colors.red,
          ),
        ),
        onTap: () {
          moneyInDetails(transactions);
        },
      );

  Stream<List<Transactions>> readTransaction() => _firestore
      .collection('Users')
      .doc(user.uid)
      .collection('Transactions')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Transactions.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );

  Widget realtimeData(id, info, style) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('Users').doc(id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var userDocument = snapshot.data;
          return Text(value.format(int.parse(userDocument![info].toString())),
              style: style);
        });
  }

  void moneyInDetails(Transactions newTransactions) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          newTransactions: newTransactions,
        ),
      ),
    );
  }

  Widget read(uid) {
    var collection = FirebaseFirestore.instance.collection('Users');
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: collection.doc(user.uid).snapshots(),
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

          return userHi(newUser);
        }

        return const Center(
          child: SpinKitFoldingCube(
            color: Colors.white,
            size: 50,
          ),
        );
      },
    );
  }

  Widget userHi(Users users) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome back, ',
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontFamily: 'League Spartan',
            ),
          ),
          const SizedBox(width: 5),
          Text(
            users.username,
            style: const TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontFamily: 'League Spartan',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}

// ignore: must_be_immutable
class DetailsScreen extends StatefulWidget {
  DetailsScreen({
    super.key,
    required this.newTransactions,
  });
  int totalMoneyInData = 0;
  int totalMoneyOutData = 0;
  int balance = 0;
  final Transactions newTransactions;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final value = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (widget.newTransactions.addType == "Money In")
          ? Colors.green
          : Colors.red,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.newTransactions.addType == "Money In"
              ? 'Money In'
              : 'Money Out',
          style: const TextStyle(
            letterSpacing: 3,
            fontSize: 35,
            fontFamily: 'League Spartan',
            color: Colors.greenAccent,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Text(
                  widget.newTransactions.addType == "Money In"
                      ? '₱ ${value.format(widget.newTransactions.amount)}'
                      : '₱ ${value.format(widget.newTransactions.amount)}',
                  style: const TextStyle(
                    fontSize: 30,
                    letterSpacing: 1,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                  width: 200,
                ),
              ],
            ),
            detailsContainer(),
          ],
        ),
      ),
    );
  }

  Widget buildDetailsScreen() => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Text(
                  widget.newTransactions.addType == "Money In"
                      ? '₱ ${value.format(widget.newTransactions.amount)}'
                      : '₱ ${value.format(widget.newTransactions.amount)}',
                  style: const TextStyle(
                    fontSize: 30,
                    letterSpacing: 1,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                  width: 200,
                ),
              ],
            ),
            detailsContainer(),
          ],
        ),
      );

  Widget detailsContainer() => Expanded(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 685,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.create),
                        label: const Text(
                          'Edit',
                          style: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: 22,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateDetails(
                                  transactions: widget.newTransactions),
                            ),
                          );
                        },
                      ),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Delete',
                          style: TextStyle(
                              fontFamily: 'League Spartan',
                              fontSize: 22,
                              color: Colors.red),
                        ),
                        onPressed: () {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              text:
                                  'You want to delete this transaction? Doing this will not undo any changes.',
                              showCancelBtn: true,
                              confirmBtnColor: Colors.green,
                              onCancelBtnTap: () => Navigator.pop(context),
                              onConfirmBtnTap: () {
                                // deleteTransaction(widget.newTransactions.id);
                                deleteTransaction(widget.newTransactions.id);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TransactionHome(),
                                  ),
                                );
                                alert(
                                    Icons.update,
                                    "Deleted",
                                    "You deleted it successfully",
                                    Colors.green);
                              });
                          // actionsheetDelete(context, widget.newTransactions.id);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Transaction Id",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'League Spartan',
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.newTransactions.id,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'League Spartan',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Transaction Date",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'League Spartan',
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.newTransactions.date,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'League Spartan',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Transaction Time",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'League Spartan',
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.newTransactions.time,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'League Spartan',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Transaction Note",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'League Spartan',
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.newTransactions.note,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'League Spartan',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          generatePdf();
                        },
                        icon: Icon(
                          Icons.picture_as_pdf,
                          size: 24,
                        ),
                        label: Text(
                          'Transaction Invoice',
                          style: TextStyle(
                            fontFamily: 'League Spartan',
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void generatePdf() async {
    // final Transactions transactions;
    int num = 0;
    num++;
    final doc = pw.Document();
    const title = 'Transaction Invoice';
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, title));

    alert(Icons.update, "Uploaded", "PDF has been uploaded!", Colors.green);
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
    await file.writeAsBytes(await doc.save());
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    bool changed = false;
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(children: [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.SizedBox(height: 2 * PdfPageFormat.cm),
                  pw.Text(title,
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                      )),
                  pw.SizedBox(height: 1 * PdfPageFormat.cm),
                  pw.Text(user.email.toString(),
                      style: pw.TextStyle(fontSize: 20, letterSpacing: 6)),
                  // pw.Row(
                  //     mainAxisAlignment: pw.MainAxisAlignment.center,
                  //     children: [
                  //       pw.Text('User: ',
                  //           style:
                  //               pw.TextStyle(fontSize: 20, letterSpacing: 6)),
                  //     ]),
                  pw.SizedBox(height: 25),
                  pw.Text('RECEIPT',
                      style: pw.TextStyle(fontSize: 28, letterSpacing: 16)),
                  pw.SizedBox(height: 20),
                  pw.Divider(indent: 80, endIndent: 80, thickness: 4),
                  pw.SizedBox(height: 20),
                ],
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.only(left: 70),
              child: pw.Column(
                children: [
                  pw.Row(
                    children: [
                      pw.SizedBox(width: 20),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Transaction ID:",
                            style: pw.TextStyle(fontSize: 20),
                          ),
                          pw.SizedBox(height: 15),
                          pw.Text(
                            widget.newTransactions.id,
                            style: pw.TextStyle(
                                fontSize: 24, fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    children: [
                      pw.SizedBox(width: 20),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Transaction Date:",
                            style: pw.TextStyle(fontSize: 20),
                          ),
                          pw.SizedBox(height: 15),
                          pw.Text(
                            widget.newTransactions.date,
                            style: pw.TextStyle(
                                fontSize: 24, fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    children: [
                      pw.SizedBox(width: 20),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Transaction Time",
                            style: pw.TextStyle(fontSize: 20),
                          ),
                          pw.SizedBox(height: 15),
                          pw.Text(
                            widget.newTransactions.time,
                            style: pw.TextStyle(
                                fontSize: 24, fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    children: [
                      pw.SizedBox(width: 20),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Transaction Note",
                            style: pw.TextStyle(fontSize: 20),
                          ),
                          pw.SizedBox(height: 15),
                          pw.Text(
                            widget.newTransactions.note,
                            style: pw.TextStyle(
                                fontSize: 24, fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Divider(indent: 80, endIndent: 80, thickness: 4),
            pw.SizedBox(height: 20),
            pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      widget.newTransactions.addType == 'Money In'
                          ? 'Transaction Sale: '
                          : 'Transaction Expense: ',
                      style: pw.TextStyle(
                          fontSize: 26, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Text(
                      widget.newTransactions.addType == "Money In"
                          ? 'Php ${value.format(widget.newTransactions.amount)}'
                          : 'Php ${value.format(widget.newTransactions.amount)}',
                      style: pw.TextStyle(
                          fontSize: 26, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Divider(indent: 80, endIndent: 80, thickness: 4),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Thank You!',
                  style: pw.TextStyle(
                      fontSize: 36, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Made with ',
                  style: pw.TextStyle(
                    fontSize: 24,
                    letterSpacing: 6,
                  ),
                ),
                pw.Text(
                  'Listahan',
                  style: pw.TextStyle(
                      fontSize: 26,
                      letterSpacing: 6,
                      fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ]);

          // pw.Row(children: [
          //   pw.Text('Receipt #:', style: pw.TextStyle(fontSize: 20)),
          //   pw.Text(num.toString(), style: pw.TextStyle(fontSize: 20)),
          // ]),
        },
      ),
    );
    return pdf.save();
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

  void actionsheetDelete(BuildContext context, String id) {
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
          'Are you sure you want to delete this transaction? Doing this will not undo any changes.',
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'League Spartan',
            color: Colors.black,
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              // deleteTransaction(widget.newTransactions.id);
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

  // deleteTransaction(String id) {
  //   final docUser = FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(user.uid)
  //       .collection('Transactions')
  //       .doc(id);
  //   docUser.delete();

  //   Navigator.pop(context);
  // }

  deleteTransaction(String id) async {
    final docUser =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);
    final docUser1 = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Transactions')
        .doc(widget.newTransactions.id);

    var totalMoneyIn = await docUser.get().then((value) {
      return value.get('totalMoneyIn');
    });
    var totalMoneyOut = await docUser.get().then((value) {
      return value.get('totalMoneyOut');
    });
    var balance = await docUser.get().then((value) {
      return value.get('balance');
    });
    var amount = await docUser1.get().then((value) {
      return value.get('amount');
    });
    var addType = await docUser1.get().then((value) {
      return value.get('addType');
    });

    widget.totalMoneyInData =
        addType == 'Money In' ? totalMoneyIn - amount : totalMoneyIn;
    widget.totalMoneyOutData =
        addType == 'Money Out' ? totalMoneyOut - amount : totalMoneyOut;
    widget.balance =
        addType == 'Money In' ? balance - amount : balance + amount;
    // ignore: unrelated_type_equality_checks
    // widget.totalMoneyInData = addTypeController.text == 'Money In'
    //     ? int.parse(amountController.text) + totalMoneyIn
    //     : totalMoneyIn;
    // // ignore: unrelated_type_equality_checks
    // widget.totalMoneyOutData = addTypeController.text == 'Money Out'
    //     ? int.parse(amountController.text) + totalMoneyOut
    //     : totalMoneyOut;

    // // ignore: unrelated_type_equality_checks
    // widget.balance = addTypeController.text == 'Money In'
    //     ? balance + int.parse(amountController.text)
    //     : balance - int.parse(amountController.text);

    docUser.update({
      'totalMoneyIn': widget.totalMoneyInData,
      'totalMoneyOut': widget.totalMoneyOutData,
      'balance': widget.balance,
    });
    docUser1.delete();
  }
}
