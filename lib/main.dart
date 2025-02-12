import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/image_controller.dart';
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Returns the root app widget with the GetMaterialApp and HomePage as the home screen.
    return GetMaterialApp(
      title: 'Flutter Web Fullscreen',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Instantiate the ImageController for managing image loading and fullscreen actions.
  final ImageController controller = Get.put(ImageController());

  /// Requests fullscreen for the entire document.
  void enterFullscreen() {
    final html.Element? element = html.document.documentElement;
    if (element != null) {
      element.requestFullscreen();
    }
  }

  /// Exits fullscreen if the document is in fullscreen mode.
  void exitFullscreen() {
    if (html.document.fullscreenElement != null) {
      html.document.exitFullscreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Obx(() {
                      // If the image URL is provided, display the image in a platform view; otherwise, show a placeholder.
                      return controller.imageUrl.value.isNotEmpty
                          ? SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child:
                          HtmlElementView(viewType: 'imageContainer'))
                          : const Center(child: Text("No image URL provided"));
                    }),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Input field for entering the image URL.
                    Expanded(
                      child: TextField(
                        controller: controller.imageUrlController,
                        decoration:
                        const InputDecoration(hintText: 'Enter Image URL'),
                      ),
                    ),
                    // Button to load the image from the URL.
                    ElevatedButton(
                      onPressed: () {
                        controller
                            .loadImage(controller.imageUrlController.text);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ],
      ),
      // Floating action button to trigger the context menu.
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showContextMenu(context), // Show context menu on button press
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Displays a context menu with options to enter or exit fullscreen.
  void _showContextMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero);
    final double buttonHeight = button.size.height;

    // Show a dialog with the context menu options.
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context); // Close the menu when tapping outside
          },
          child: Stack(
            children: [
              // Background with blur effect.
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(color: Colors.black.withOpacity(0.1)),
                ),
              ),
              // Menu positioned above the blurred background.
              Positioned(
                left: buttonPosition.dx + button.size.width - 230,
                top: buttonPosition.dy + buttonHeight - 120,
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  color: Colors.transparent,
                  child: Container(
                    height: 120,
                    width: 230,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10)
                      ],
                    ),
                    child: Column(
                      children: [
                        // Option to enter fullscreen.
                        ListTile(
                          leading: Icon(Icons.fullscreen),
                          title: Text('Enter Fullscreen'),
                          onTap: () {
                            Navigator.pop(context);
                            enterFullscreen();
                          },
                        ),
                        // Option to exit fullscreen.
                        ListTile(
                          leading: Icon(Icons.fullscreen_exit),
                          title: Text('Exit Fullscreen'),
                          onTap: () {
                            Navigator.pop(context);
                            exitFullscreen();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
