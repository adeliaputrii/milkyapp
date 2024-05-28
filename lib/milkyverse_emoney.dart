import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:milkyapp/base/base_colors.dart' as baseColors;
import 'package:milkyapp/milkyverse_home.dart';
import 'package:milkyapp/utlis/animation/fadeimage.dart';
import 'package:milkyapp/utlis/animation/slidetext.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:native_id/native_id.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';

class DetailCard extends StatefulWidget {
  final String value;
  const DetailCard({
    super.key,
    required this.value
    });

@override
State<DetailCard> createState() => _DetailCardState();
}
class _DetailCardState extends State<DetailCard> {
  String formattedDate = DateFormat('d MMMM yyyy').format(DateTime.now());
  String _nativeId = 'Unknown';
  String _device = '';
  String _appVersion = '';
  final _nativeIdPlugin = NativeId();
  DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();

  Future<void> initPlatformState() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }
  
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
          child: 
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
                Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                    width: 10,
                    height: screenHeight/10,
                    ),
                    IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, 
                      MaterialPageRoute(builder: (context){
                      return Home();
                      })
                    );}, 
                    icon: Icon(
                    Icons.cancel_rounded,
                    color: Colors.white,
                    size: screenWidth/15,
                     )
                    )
                    ],
                    ),
                    Container(
                    margin: EdgeInsets.only(bottom: screenHeight/40),
                    child: FadeInImageWidget(
                    height: screenWidth/4.5,
                    width: screenWidth/4.5,
                    imageUrl: 'assets/logo.png',
                    ),
                    ),
                    Text('Welcome to Milkyverse',
                    style: GoogleFonts.poppins(
                    fontSize: screenWidth/20,
                    color: baseColors.tertiaryColor,
                      ),
                    ),
                    Container(
                    margin: EdgeInsets.fromLTRB(
                    20,
                    screenHeight/25,
                    20, 
                    screenHeight/70
                    ),
                    height: screenHeight/13,
                    decoration: BoxDecoration(
                    color: baseColors.tertiaryColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                    children: [
                      Padding(
                      padding: const EdgeInsets.only(
                      left: 20,
                      right: 20
                      ),
                      child: FadeInImageWidget(
                        imageUrl: 'assets/dateIcon.png', 
                        height: screenWidth/10, 
                        width: screenWidth/10),
                      ),
                      Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth/30,
                          color: Colors.grey,
                        ),
                        ),
                        Text('${formattedDate}',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth/30,
                          color: Colors.black,
                          ),
                        ),
                        ],
                        )
                       ],
                       ),
                      ),
                      Container(
                      margin: EdgeInsets.fromLTRB(
                      20,
                      0,
                      20, 
                      screenHeight/70
                      ),
                      height: screenHeight/13,
                      decoration: BoxDecoration(
                        color: baseColors.tertiaryColor,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        children: [
                          Padding(
                          padding: const EdgeInsets.only(
                          left: 20,
                          right: 20
                          ),
                          child: FadeInImageWidget(
                          imageUrl: 'assets/cardIcon.png', 
                          height: screenWidth/10, 
                          width: screenWidth/10),
                          ),
                          Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Device ID',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth/30,
                              color: Colors.grey,
                              ),
                            ),
                            Text('${_nativeId}${_device}',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth/30,
                              color: Colors.black,
                              ),
                            ),
                            ],
                          )
                          ],
                        ),
                      ),
                      Container(
                      margin: EdgeInsets.fromLTRB(
                      20,
                      0,
                      20, 
                      screenHeight/70
                      ),
                      height: screenHeight/13,
                      decoration: BoxDecoration(
                        color: baseColors.tertiaryColor,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                      children: [
                        Padding(
                        padding: const EdgeInsets.only(
                        left: 20,
                        right: 20
                        ),
                        child: FadeInImageWidget(
                          imageUrl: 'assets/deviceIcon.png', 
                          height: screenWidth/10, 
                          width: screenWidth/10),
                        ),
                        Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID Card',
                           style: GoogleFonts.poppins(
                            fontSize: screenWidth/30,
                            color: Colors.grey,
                           ),
                                ),
                          Text('${widget.value ?? 'Unknown'}',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth/30,
                            color: Colors.black,
                            ),
                          ),
                          ],
                          )
                        ],
                        ),
                      ),
                      Container(
                      margin: EdgeInsets.fromLTRB(
                      20,
                      0,
                      20, 
                      screenHeight/20
                      ),
                      height: screenHeight/13,
                      decoration: BoxDecoration(
                        color: baseColors.tertiaryColor,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                      children: [
                        Padding(
                        padding: const EdgeInsets.only(
                        left: 20,
                        right: 20
                        ),
                        child: FadeInImageWidget(
                          imageUrl: 'assets/versionIcon.png', 
                          height: screenWidth/10, 
                          width: screenWidth/10),
                        ),
                        Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Version',
                           style: GoogleFonts.poppins(
                            fontSize: screenWidth/30,
                            color: Colors.grey,
                           ),
                                ),
                          Text('${_appVersion}',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth/30,
                            color: Colors.black,
                            ),
                          ),
                          ],
                          )
                        ],
                        ),
                      ),
                    ]
                  ),
                Container(
                margin: const EdgeInsets.only(
                bottom: 50
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Copyright RALS',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth/30,
                      color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                      Navigator.pushAndRemoveUntil(context, 
                      MaterialPageRoute(builder: (context){
                      return Home();
                      }), (route) => false);
                      }, 
                      icon: Icon(Icons.copyright_outlined,
                      size: screenWidth/30,
                      color: Colors.white,
                      ),
                      ),
                    Text('2024',
                      style: GoogleFonts.poppins(
                      fontSize: screenWidth/30,
                      color: Colors.white,
                    ),
                    ),
                  ],
                  ),
                ),
              ],
              ),
            ),
          ),
          FadeInImageWidget(
            imageUrl: 'assets/background.png', 
            height: screenWidth / 2.1,
            width: screenWidth
          )
        ],
      ),
    );
  }
}