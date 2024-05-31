import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:milkyapp/base/base_colors.dart' as baseColors;
import 'package:milkyapp/milkyverse_emoney.dart';
import 'package:milkyapp/utlis/animation/fadeimage.dart';
import 'package:milkyapp/utlis/animation/slidetext.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:native_id/native_id.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  String _appVersion = '';
  bool _dialogShown = false;
  late ConnectivityResult _connectivityResult;
  late StreamSubscription<ConnectivityResult> _subscription;
  final _nativeIdPlugin = NativeId();
  DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
  String formattedDate = DateFormat('d MMMM yyyy HH:mm:ss').format(DateTime.now());

  void _readNfcTag() {
  NfcManager.instance.startSession(onDiscovered: (NfcTag badge) async {
    print("nfc : ${badge.data}");
    var mifareclassic = MifareClassic.from(badge);
    if(mifareclassic != null && mifareclassic.identifier != null){
      setState(() {
        _readNfcTagString = mifareclassic.identifier.toString();
        value = _cleanArray(_readNfcTagString!);
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return DetailCard(value: '${value}',);
        // }
        // ));
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
        if(_barcode != null) {
        value = _barcode!.rawValue;
        _controller.stop();
        }
      //   Navigator.push(context, MaterialPageRoute(builder: (context) {
      //     return DetailCard(value: '${value}');
      // }));
      });
      _controller.stop();
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
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _checkConnectivity();
    _appVersion = packageInfo.version;
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

  Future<void> _checkConnectivity() async {
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {

    if (result == ConnectivityResult.none || !hasInternet) {
      _showNoConnectionDialog();
    } else {
      _hideNoConnectionDialog();
    }
  });
  }

    void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection and try again.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _hideNoConnectionDialog() {
    if (_dialogShown) {
      Navigator.of(context).pop();
      _dialogShown = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
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
        } else if(snapshot.hasError) {
          debugPrint('${snapshot.error}');
        } else {
          if(snapshot.data == false) {
            debugPrint('NFC Not Available');
          } else {
            debugPrint('NFC Available');
            WidgetsBinding.instance.addPostFrameCallback((_){
              _readNfcTag();
            });
          }
        }
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
                      ),
                      width: screenWidth,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            color: baseColors.secondaryColor,
                            width: screenWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${_nativeId}${_device}',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth/27,
                                  color: baseColors.primaryColor,
                                ),
                                ),
                                Text('${formattedDate}',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth/27,
                                  color: baseColors.primaryColor,
                                ),
                                ),
                              ],
                            )),
                          Container(
                            margin: EdgeInsets.only(
                              left: screenWidth/20
                            ),
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
                        ],
                      ),
                    ),
                    AnimatedTextKit( 
                      repeatForever: true, 
                      animatedTexts: [ 
                        FlickerAnimatedText('${_buildBarcode(value)}',
                          speed: Duration(seconds: 2), 
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
                      child: Text('Version ${_appVersion}',
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