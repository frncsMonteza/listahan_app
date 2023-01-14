import 'dart:io';

import 'package:flutter/services.dart';
import 'package:listahan_app/user.dart';
import 'package:open_document/open_document.dart';

import 'package:open_file_plus/open_file_plus.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

// class User {
//   final String name;
//   final int age;

//   const User({required this.name, required this.age});
// }
class User {
  final String name;
  final int age;

  const User({required this.name, required this.age});
}

class PDF {
  static Future<File> generateTable() async {
    final pdf = Document();

    final headers = ['Name', 'Age'];

    final users = [
      User(name: 'James', age: 19),
      User(name: 'Sarah', age: 21),
      User(name: 'Emma', age: 28),
    ];
    final data = users.map((user) => [user.name, user.age]).toList();

    pdf.addPage(Page(
      build: (context) => Table.fromTextArray(
        headers: headers,
        data: data,
      ),
    ));

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  // static Future<void> savePdfFile(String fileName, Uint8List byteList) async {
  //   final output = await getTemporaryDirectory();
  //   var filePath = "${output.path}/$fileName.pdf";
  //   final file = File(filePath);
  //   await file.writeAsBytes(byteList);
  //   await OpenDocument.openDocument(filePath: filePath);
  // }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
  // String getSubTotal(List<Product> products) {
  //   return products
  //       .fold(0.0,
  //           (double prev, element) => prev + (element.amount * element.price))
  //       .toStringAsFixed(2);
  // }

  // String getVatTotal(List<Product> products) {
  //   return products
  //       .fold(
  //         0.0,
  //         (double prev, next) =>
  //             prev + ((next.price / 100 * next.vatInPercent) * next.amount),
  //       )
  //       .toStringAsFixed(2);
  // }
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }
}



//  class PdfApi {
  
    
//     Future<File> generateInvoice(Transactions transactions) async {
//     final pdf = Document();

//     final headers = ['Name', 'Age'];

//     final users = [
//       User(name: 'James', age: 19),
//       User(name: 'Sarah', age: 21),
//       User(name: 'Emma', age: 28),
//     ];
//     final data = users.map((user) => [user.name, user.age]).toList();

//     pdf.addPage(MultiPage(
//         build: (context) => [
//               buildTitle(transactions),
//               // Table.fromTextArray(
//               //   headers: headers,
//               //   data: data,
//               // ),
//             ]));

//     return saveDocument(name: 'my_example.pdf', pdf: pdf);
//   })
   

//   static Widget buildTitle(Transactions transactions) =>
//       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text('Invoice'),
//         SizedBox(height: 0.8 * PdfPageFormat.cm),
//         Text(transactions.addType),
//       ]);

//   static Future<File> generateTable() async {
//     final pdf = Document();

//     final headers = ['Name', 'Age'];

//     final users = [
//       User(name: 'James', age: 19),
//       User(name: 'Sarah', age: 21),
//       User(name: 'Emma', age: 28),
//     ];
//     final data = users.map((user) => [user.name, user.age]).toList();

//     pdf.addPage(Page(
//       build: (context) => Table.fromTextArray(
//         headers: headers,
//         data: data,
//       ),
//     ));

//     return saveDocument(name: 'my_example.pdf', pdf: pdf);
//   }

//   static Future<File> generateImage() async {
//     final pdf = Document();

//     final imageSvg = await rootBundle.loadString('assets/fruit.svg');
//     final imageJpg =
//         (await rootBundle.load('assets/person.jpg')).buffer.asUint8List();

//     final pageTheme = PageTheme(
//       pageFormat: PdfPageFormat.a4,
//       buildBackground: (context) {
//         if (context.pageNumber == 1) {
//           return FullPage(
//             ignoreMargins: true,
//             child: Image(MemoryImage(imageJpg), fit: BoxFit.cover),
//           );
//         } else {
//           return Container();
//         }
//       },
//     );

//     pdf.addPage(
//       MultiPage(
//         pageTheme: pageTheme,
//         build: (context) => [
//           Container(
//             height: pageTheme.pageFormat.availableHeight - 1,
//             child: Center(
//               child: Text(
//                 'Foreground Text',
//                 style: TextStyle(color: PdfColors.white, fontSize: 48),
//               ),
//             ),
//           ),
//           SvgImage(svg: imageSvg),
//           Image(MemoryImage(imageJpg)),
//           Center(
//             child: ClipRRect(
//               horizontalRadius: 32,
//               verticalRadius: 32,
//               child: Image(
//                 MemoryImage(imageJpg),
//                 width: pageTheme.pageFormat.availableWidth / 2,
//               ),
//             ),
//           ),
//           GridView(
//             crossAxisCount: 3,
//             childAspectRatio: 1,
//             children: [
//               SvgImage(svg: imageSvg),
//               SvgImage(svg: imageSvg),
//               SvgImage(svg: imageSvg),
//               SvgImage(svg: imageSvg),
//               SvgImage(svg: imageSvg),
//               SvgImage(svg: imageSvg),
//             ],
//           )
//         ],
//       ),
//     );

//     return saveDocument(name: 'my_example.pdf', pdf: pdf);
//   }

  

//   // static Future openFile(File file) async {
//   //   final url = file.path;

//   //   await OpenFile.open(url);
//   // }
// }
