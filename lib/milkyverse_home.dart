import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkyapp/base/base_colors.dart' as baseColors;
import 'package:milkyapp/milkyverse_emoney.dart';
import 'package:milkyapp/utlis/animation/fadeimage.dart';
import 'package:milkyapp/utlis/animation/slidetext.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:native_id/native_id.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MobileScannerController _controller = MobileScannerController();
  String data = 'TESTER';
  Barcode? _barcode;
  String? _readNfcTagString;
  String? value;
  String _nativeId = 'Unknown';
  String _device = '';
  final _nativeIdPlugin = NativeId();
  DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();

  void _readNfcTag() {
  NfcManager.instance.startSession(onDiscovered: (NfcTag badge) async {
    print("nfc : ${badge.data}");
    var mifareclassic = MifareClassic.from(badge);
    if(mifareclassic != null && mifareclassic.identifier != null){
      setState(() {
        _readNfcTagString = mifareclassic.identifier.toString();
        value = _cleanArray(_readNfcTagString!);
      });
    }else{
      print("Card is not define");
    }
    NfcManager.instance.stopSession();
    });
  }

   _buildBarcode(String? value) {
    if (value == null) {
      return 'Scan Here';
    } else {
      return 'Welcome to Milkyverse';
    }
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
        value = _barcode!.rawValue;
      });
    }
  }

  String _cleanArray(String readTag) {
    String cleanedString = readTag.replaceAll('[', '').replaceAll(']', '');
    // Split the string by commas
    List<String> stringList = cleanedString.split(',');
    // Join the list into a single string
    String result = stringList.join();
    print(result); 
    return result;
  }

  Future<void> initPlatformState() async {
    String nativeId;
    AndroidDeviceInfo info = await devicePlugin.androidInfo;
    try {
      nativeId = await _nativeIdPlugin.getId() ?? 'Unknown NATIVE_ID';
    } on PlatformException {
      nativeId = 'Failed to get native id.';
    }
    if (!mounted) return;
    setState(() {
      _nativeId = nativeId;
      _device = '${info.device}';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    print(_cleanArray('[22,33,44,55,66]'));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: NfcManager.instance.isAvailable(),
      builder: (context, snapshot) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
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
                        FlickerAnimatedText('${_buildBarcode(value)}',
                          speed: Duration(seconds: 1), 
                          textStyle: GoogleFonts.orbitron(
                            fontSize: screenWidth/17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            ),
                          ),
                          FlickerAnimatedText(
                          value == null ? '' : '${value}',
                          speed: Duration(seconds: 1), 
                          textStyle: GoogleFonts.orbitron(
                            fontSize: screenWidth/17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(),
                    Container(
                      margin: EdgeInsets.only(bottom: 50),
                      child: Text('${_nativeId}${_device}',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth/30,
                        color: Colors.white,
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            FadeInImageWidget(
            imageUrl: 'assets/background.png', 
            height: screenWidth / 2.1,
            width: screenWidth)
            ],
          ),
        );
      }
    );
  }
}