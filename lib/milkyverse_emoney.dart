import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkyapp/base/base_colors.dart' as baseColors;
import 'package:milkyapp/milkyverse_home.dart';
import 'package:milkyapp/utlis/animation/fadeimage.dart';
import 'package:milkyapp/utlis/animation/slidetext.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';

class DetailCard extends StatefulWidget {
  final String data;
  const DetailCard({
    super.key,
    required this.data
    });

@override
State<DetailCard> createState() => _DetailCardState();
}
class _DetailCardState extends State<DetailCard> {
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
                color: baseColors.primaryColor,
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
                    margin: EdgeInsets.only(
                      top: screenHeight/25,
                      bottom: screenHeight/50
                    ),
                    child: FadeInImageWidget(
                    height: screenWidth/4.5,
                    width: screenWidth/4.5,
                    imageUrl: 'assets/logo.png',
                    ),
                    ),
                    Text('Detail e-money',
                    style: GoogleFonts.poppins(
                    fontSize: screenWidth/20,
                    color: baseColors.tertiaryColor,
                      ),
                    ),
                    Container(
                    margin: EdgeInsets.fromLTRB(
                    20,
                    screenHeight/20,
                    20, 
                    screenHeight/45
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
                      right: 30
                      ),
                      child: FadeInImageWidget(
                        imageUrl: 'assets/debitIcon.png', 
                        height: screenWidth/13, 
                        width: screenWidth/15),
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
                        Text('${widget.data}',
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
                      screenHeight/45
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
                          right: 30
                          ),
                          child: FadeInImageWidget(
                          imageUrl: 'assets/profilIcon.png', 
                          height: screenWidth/13, 
                          width: screenWidth/13),
                          ),
                          Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth/30,
                              color: Colors.grey,
                              ),
                            ),
                            Text('Adhelia Putri Wardhana',
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
                        right: 30
                        ),
                        child: FadeInImageWidget(
                          imageUrl: 'assets/saldoIcon.png', 
                          height: screenWidth/13, 
                          width: screenWidth/13),
                        ),
                        Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Saldo',
                           style: GoogleFonts.poppins(
                            fontSize: screenWidth/30,
                            color: Colors.grey,
                           ),
                                ),
                          Text('Rp. 20.000.000',
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