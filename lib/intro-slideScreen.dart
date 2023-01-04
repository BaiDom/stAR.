import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'main.dart';

class IntroSliderPage extends StatefulWidget {
  const IntroSliderPage({super.key});

  @override
  IntroSliderPageState createState() => IntroSliderPageState();
}

class IntroSliderPageState extends State<IntroSliderPage> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();
    slides.add(
      Slide(
        title: "Welcome!",
        description: "Hey there Space Cadet! Ready to explore the Cosmos?",
        pathImage: "assets/images/space.png",
      ),
    );
    slides.add(
      Slide(
        title: "AR",
        description: "Experience the Universe at your fingertips!",
        pathImage: "assets/images/virtualreality.png",
      ),
    );
    slides.add(
      Slide(
        title: "Star Maps",
        description: "Gaze at the stars above you!",
        pathImage: "assets/images/universe.png",
      ),
    );
    slides.add(
      Slide(
        title: "Moon Phases",
        description: "View up to the minute moon phases!",
        pathImage: "assets/images/solarsystem.png",
      ),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            margin: const EdgeInsets.only(bottom: 160, top: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Image.asset(
                    currentSlide.pathImage.toString(),
                    matchTextDirection: true,
                    height: 250,
                    width: 250,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(
                    currentSlide.title.toString(),
                    style: const TextStyle(color: Colors.amber, fontSize: 32),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  margin: const EdgeInsets.only(
                    top: 15,
                    left: 20,
                    right: 20,
                  ),
                  child: Text(
                    currentSlide.description.toString(),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 28,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      backgroundColorAllSlides: Color.fromARGB(0, 0, 0, 0),
      renderSkipBtn: const Text(
        "Skip",
        style: TextStyle(color: Colors.amber),
      ),
      renderNextBtn: const Text(
        "Next",
        style: TextStyle(color: Colors.white),
      ),
      renderDoneBtn: const Text(
        "Done",
        style: TextStyle(color: Colors.white),
      ),
      colorDoneBtn: Colors.amber,
      colorActiveDot: Color.fromARGB(255, 240, 237, 237),
      colorPrevBtn: Color.fromARGB(255, 240, 237, 237),
      colorDot: Color.fromARGB(255, 240, 237, 237),
      sizeDot: 8.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
      listCustomTabs: renderListCustomTabs(),
      scrollPhysics: const BouncingScrollPhysics(),
      hideStatusBar: false,
      onDonePress: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const RootPage(),
        ),
      ),
    );
  }
}
