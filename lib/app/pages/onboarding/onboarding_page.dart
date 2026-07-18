// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class OnboardingPage extends StatefulWidget {
//   const OnboardingPage({Key? key}) : super(key: key);

//   @override
//   State<OnboardingPage> createState() => _OnboardingPageState();
// }

// class _OnboardingPageState extends State<OnboardingPage> {
//   final PageController _controller = PageController();
//   int _currentIndex = 0;

//   final storage = GetStorage();

//  final List<Map<String, String>> onboardingData = [
//   {
//     "image": "assets/images/car1.jpg",
//     "title": "Welcome to Fraction Car",
//     "desc": "Buy, sell, and own luxury cars in fractions. Experience a smarter way to invest in cars with trusted ownership options."
//   },
//   {
//     "image": "assets/images/car2.jpg",
//     "title": "Easy Investment & Trading",
//     "desc": "Invest in high-value cars with flexible fractional ownership. Buy and sell your shares easily anytime in the marketplace."
//   },
//   {
//     "image": "assets/images/car3.jpg",
//     "title": "Track & Manage Your Cars",
//     "desc": "Monitor your car investments and trading activity anytime. Stay updated on ownership, value, and market trends all in one app."
//   },
// ];

//   void finishOnboarding() {
//     storage.write('onboarding_done', true);
//     Get.offAllNamed(Routes.HOME);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           PageView.builder(
//             controller: _controller,
//             onPageChanged: (index) => setState(() => _currentIndex = index),
//             itemCount: onboardingData.length,
//             itemBuilder: (context, index) {
//               final item = onboardingData[index];
//               return SizedBox(
//                 width: double.infinity,
//                 height: double.infinity,
//                 child: Image.asset(
//                   item["image"]!,
//                   fit: BoxFit.cover,
//                 ),
//               );
//             },
//           ),

//           // Overlay content on image
//           Positioned.fill(
//             child: Container(
//               alignment: Alignment.bottomCenter,
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     onboardingData[_currentIndex]["title"]!,
//                     style: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
                  
//                   const SizedBox(height: 16),
//                   Text(
//                     onboardingData[_currentIndex]["desc"]!,
//                     style: const TextStyle(fontSize: 16, color: Colors.white70),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 40),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(
//                       onboardingData.length,
//                       (index) => AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         margin: const EdgeInsets.symmetric(horizontal: 4),
//                         width: _currentIndex == index ? 20 : 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           color: _currentIndex == index
//                               ? Colors.blue
//                               : Colors.grey,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_currentIndex == onboardingData.length - 1) {
//                         finishOnboarding();
//                       } else {
//                         _controller.nextPage(
//                           duration: const Duration(milliseconds: 300),
//                           curve: Curves.easeInOut,
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     child: Text(
//                       _currentIndex == onboardingData.length - 1
//                           ? "Get Started"
//                           : "Next",
//                       style: const TextStyle(
//                           fontSize: 18, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
