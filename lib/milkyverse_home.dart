import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkyapp/base/base_colors.dart' as baseColors;
import 'package:milkyapp/milkyverse_emoney.dart';
import 'package:milkyapp/utlis/animation/fadeimage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MobileScannerController _controller = MobileScannerController();
  String data = 'TESTER';
  String _readFromNfcTag = "";
  Barcode? _barcode;
  String? _barcodeString;

  void _readNfcTag() {
  NfcManager.instance.startSession(onDiscovered: (NfcTag badge) async {
    var ndef = Ndef.from(badge);
    if (ndef != null && ndef.cachedMessage != null) {
      String tempRecord = "";
      for (var record in ndef.cachedMessage!.records) {
        tempRecord ="$tempRecord ${String.fromCharCodes(record.payload.sublist(record.payload[0] + 1))}";
      }
      setState(() {
        _readFromNfcTag = tempRecord;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailCard(data:_readFromNfcTag);
        }));
      });
    } else {
    }
    NfcManager.instance.stopSession();
  });
  }

   _buildBarcode(Barcode? value) {
    if (value == null) {
      return 'Scan here';
    } else {
      if (_barcodeString == '4983164889086') {
        return 'Welcome to Milkyverse';
      } else {
        return 'Kartu belum diintegrasi';
      }
    }
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
        _barcodeString = _barcode!.rawValue;
        // if (_barcode != null) {
        //   _controller.stop();  // Stop the scanner after detecting a barcode
        // }
      // _buildBarcode(_barcode);
      });
      _buildBarcode(_barcode);
      // Navigator.push(context, MaterialPageRoute(builder: (context){
      //   return DetailCard(data:_barcodeString!);
      // }));
      print('widget data${_barcodeString}');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: NfcManager.instance.isAvailable(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          debugPrint('NFC Waiting');
        } else if (snapshot.hasError) {
          debugPrint('${snapshot.error}');
        }
        else {
        if (snapshot.data == false) {
          debugPrint('NFC Not Available');
        } else {
          debugPrint('NFCAvailable');
          WidgetsBinding.instance.addPostFrameCallback((_) {
          _readNfcTag();
        });
        }
        }
        return Scaffold(
          body: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  baseColors.primaryColor, 
                  Colors.black
                  ],
                ),
              ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: screenHeight / 30,
                    left: screenWidth / 30
                  ),
                  width: screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FadeInImageWidget(
                        imageUrl: 'assets/logo.png', 
                        height: screenHeight / 8.5, 
                        width: screenWidth / 4
                        ),
                      Container(
                        height: 1,
                        child: MobileScanner(
                        controller: _controller,
                        overlayBuilder: (context, constraints) {
                        // Mengembalikan widget kosong sebagai overlay
                        return SizedBox.expand();
                      },
                        onDetect: _handleBarcode,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedTextKit( 
                  repeatForever: true, 
                  animatedTexts: [ 
                    FlickerAnimatedText('${_buildBarcode(_barcode)}',
                      speed: Duration(seconds: 1), 
                      textStyle: GoogleFonts.orbitron(
                        fontSize: screenWidth/17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        ),
                      ),
                      ],
                    ),
                FadeInImageWidget(
                  imageUrl: 'assets/background.png', 
                  height: screenWidth / 2.1,
                  width: screenWidth)
              ],
            ),
          ),
        );
      }
    );
  }
}
