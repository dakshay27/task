import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

/// Controller for managing image display, including dynamic loading and fullscreen toggle.
class ImageController extends GetxController {
  // Controller for the text input field that holds the image URL.
  final TextEditingController imageUrlController = TextEditingController();

  // Reactive variable to hold the image URL.
  final RxString imageUrl = ''.obs;

  // HTML container element that holds the image.
  final html.DivElement container = html.DivElement();

  // Flag to track fullscreen mode status.
  bool isFullscreen = false;

  /// Initializes the HTML elements for image container and fullscreen toggle.
  ImageController() {
    _initializeHtmlElements();
  }

  /// Sets up the HTML container for the image and registers it as a platform view.
  void _initializeHtmlElements() {
    // Set container styles for centering the image and full width/height.
    container.style.width = '100%';
    container.style.height = '100%';
    container.style.display = 'flex';
    container.style.justifyContent = 'center';
    container.style.alignItems = 'center';

    // Create an HTML image element with specific styles.
    final html.ImageElement imgElement = html.ImageElement()
      ..id = 'dynamicImage'
      ..style.maxWidth = '100%'
      ..style.maxHeight = '100%'
      ..style.objectFit = 'contain';

    container.append(imgElement);

    // Register the container as a platform view with an ID.
    ui.platformViewRegistry.registerViewFactory('imageContainer', (int viewId) => container);

    // Set up a listener for double-click events to toggle fullscreen mode.
    container.onDoubleClick.listen((event) {
      toggleFullscreen();
    });
  }

  /// Loads an image from the given URL into the container.
  ///
  /// The image URL is also updated in the reactive variable [imageUrl].
  void loadImage(String url) {
    imageUrl.value = url;
    final imgElement = container.querySelector('#dynamicImage') as html.ImageElement?;

    if (imgElement != null) {
      imgElement.src = url;
    }
  }

  /// Toggles fullscreen mode for the image container.
  ///
  /// If the container is already in fullscreen, it exits fullscreen.
  /// If it is not, it requests fullscreen.
  void toggleFullscreen() {
    final element = container.querySelector('#dynamicImage') as html.ImageElement?;

    if (element != null) {
      if (isFullscreen) {
        html.document.exitFullscreen();
        isFullscreen = false;
      } else {
        container.requestFullscreen();
        isFullscreen = true;
      }
    }
  }
}
