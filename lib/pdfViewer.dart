import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listahan_app/main.dart';
import 'package:listahan_app/transaction.dart';
import 'package:listahan_app/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFView extends StatefulWidget {
  const PDFView({Key? key}) : super(key: key);

  @override
  State<PDFView> createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Printing"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: generatePdf,
              child: Text(
                'Generate Advanced PDF',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void generatePdf() async {
    final doc = pw.Document();
    const title = 'Listahan Income Statement';
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, title));

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
    await file.writeAsBytes(await doc.save());
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Center(
              child: pw.Column(
            children: [
              pw.SizedBox(height: 2 * PdfPageFormat.cm),
              pw.Text(title, style: pw.TextStyle(fontSize: 20)),
              pw.SizedBox(height: 20),
            ],
          ));
        },
      ),
    );
    return pdf.save();
  }
}
