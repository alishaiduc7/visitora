import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:visitora/colors/app_colors.dart';
import 'package:visitora/screens/detail_screen.dart';

class QRScannerScreen extends StatefulWidget {
  QRScannerScreen({this.listOfSights, Key? key}) : super(key: key);
  List<QueryDocumentSnapshot?>? listOfSights;
  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey _globalKey = GlobalKey();
  QRViewController? qrController;
  Barcode? result;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrController!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        if (result!.code != null) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  backgroundColor: AppColors.background,
                  title: Text(
                    result!.code.toString(),
                    style: const TextStyle(color: AppColors.mainDarker),
                  ),
                  content: const Text('Click OK to see details!'),
                  actions: [
                    TextButton(
                        style: TextButton.styleFrom(
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          primary: AppColors.black,
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QRScannerScreen()));
                        },
                        child: const Text('Cancel')),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        primary: AppColors.black,
                        shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();

                        widget.listOfSights!.forEach((sight) {
                          if (sight!['title'].contains(result!.code)) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => SightDetailScreen(
                                    detailedSight: sight,
                                    previousScreen: 2,
                                  ),
                                ),
                                (Route<dynamic> route) => false);
                          }
                        });
                      },
                      child: const Text('OK!'),
                    )
                  ],
                );
              });
        }
      });
    });
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 84, 80),
      body: Column(children: [
        Container(
            color: AppColors.background,
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            child: QRView(
              key: _globalKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                  borderColor: AppColors.main,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: (MediaQuery.of(context).size.width < 400 ||
                          MediaQuery.of(context).size.height < 400)
                      ? 150.0
                      : 300.0),
            )),
        Center(
          child: result != null
              ? Text('${result!.code}')
              : const Text(
                  'Scan a code',
                  style: TextStyle(color: AppColors.black, fontSize: 18),
                ),
        ),
        TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              primary: AppColors.black,
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            onPressed: () async {
              await qrController?.toggleFlash();
            },
            child: const Text('FLASH ON'))
      ]),
    );
  }
}
