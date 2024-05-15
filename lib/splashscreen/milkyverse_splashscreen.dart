part of 'import.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: Home(),
      linearGradient: const LinearGradient(
        colors: [
        Colors.white,
        Colors.white,
        ],
        begin: FractionalOffset(0.0, 0.0),
        end: FractionalOffset(0.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
        logoSize: 300,
      imageSrc: "assets/logo.png",
      
    );
  }
}