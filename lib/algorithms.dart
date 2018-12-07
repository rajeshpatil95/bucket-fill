import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class BucketFill {
  List<Offset> _points = <Offset>[];
  Uint32List words;
  static int width;
  Color oldColor, pixel;
  int imageWidth;
  int imageHeight;

  Future<List> capturePng(GlobalKey key, Offset offset) async {
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    final rgbaImageData =
        await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    imageHeight = image.height;
    imageWidth = image.width;
    words = Uint32List.view(rgbaImageData.buffer, rgbaImageData.offsetInBytes,
        rgbaImageData.lengthInBytes ~/ Uint32List.bytesPerElement);
    oldColor = _getColor(words, offset.dx, offset.dy);
    return _floodfill(oldColor, offset.dx, offset.dy);
  }

  Color _getColor(Uint32List words, double x1, double y1) {
    int x = x1.toInt();
    int y = y1.toInt();
    var offset = x + y * imageWidth;
    return Color(words[offset]);
  }

  // flood fill 4 or 8 connected method uisng recursion
  List<Offset> _floodfill(Color oldColor, double x, double y) {
    if ((x >= 0 &&
            x < imageWidth &&
            y >= 0 &&
            y < imageHeight &&
            !_points.contains(Offset(x, y)))
        ? _getColor(words, x, y) == oldColor
        : false) {
      _points.add(Offset(x, y));
      _floodfill(oldColor, x + 4, y);
      _floodfill(oldColor, x - 4, y);
      _floodfill(oldColor, x, y + 4);
      _floodfill(oldColor, x, y - 4);
    }
    return _points;
  }

  //Boundary Fill algorithm
  // List<Offset> _floodfill(Color oldColor, double x, double y) {
  //   if ( _getColor(words, x, y) == oldColor && !_points.contains(Offset(x, y))) {
  //     _points.add(Offset(x, y));
  //     _floodfill(oldColor, x + 4, y);
  //     _floodfill(oldColor, x - 4, y);
  //     _floodfill(oldColor, x, y + 4);
  //     _floodfill(oldColor, x, y - 4);
  //   }
  //   return _points;
  // }

  // List<Offset> _floodfill(Color oldColor, double x, double y) {
  //   Queue<Offset> queue = new Queue();
  //   Offset temp;
  //   queue.add(Offset(x, y));
  //   _points = List.from(_points)..add(queue.first);
  //   while (queue.isNotEmpty) {
  //     temp = queue.first;
  //     queue.removeFirst();
  //     if (_shouldFillColor(temp.dx + 2, temp.dy)) {
  //       queue.add(Offset(temp.dx + 2, temp.dy));
  //       _points.add(Offset(temp.dx + 2, temp.dy));
  //     }
  //     if (_shouldFillColor(temp.dx - 2, temp.dy)) {
  //       queue.add(Offset(temp.dx - 2, temp.dy));
  //       _points.add(Offset(temp.dx - 2, temp.dy));
  //     }
  //     if (_shouldFillColor(temp.dx, temp.dy + 2)) {
  //       queue.add(Offset(temp.dx, temp.dy + 2));
  //       _points.add(Offset(temp.dx, temp.dy + 2));
  //     }
  //     if (_shouldFillColor(temp.dx, temp.dy - 2)) {
  //       queue.add(Offset(temp.dx, temp.dy - 2));
  //       _points.add(Offset(temp.dx, temp.dy - 2));
  //     }
  //   }
  //   _points.add(null);
  //   return _points;
  // }

  // bool _shouldFillColor(double x, double y) {
  //   return (x >= 0 &&
  //           x < imageWidth &&
  //           y >= 0 &&
  //           y < imageHeight &&
  //           !_points.contains(Offset(x, y)))
  //       ? _getColor(words, x, y) == oldColor
  //       : false;
  // }

//  List<Offset> _floodfill(Color oldColor, double x, double y) {
//     Queue<Offset> queue = new Queue();
//     Color targetColor = Colors.blue;
//      queue.add(Offset(x, y));

//     if (targetColor != _getColor(words, x, y)) {

//       while (queue.isNotEmpty) {

//         double x1 = x;
//         double y1 = y;

//         while (x1 > 0  && _getColor(words, x1 - 1, y1) == targetColor) {
//           x1--;
//         }

//         bool spanUp = false;
//         bool spanDown = false;
//         while (x1 < imageWidth && _getColor(words, x1, y1) == targetColor) {
//           _points = List.from(_points)..add(queue.first);
//           if (!spanUp && y1 > 0 && _getColor(words, x1, y1 - 1) != targetColor) {
//             queue.add(Offset(x1, y1 - 1));
//             spanUp = true;
//           } else if (spanUp && y1 > 0 && _getColor(words, x1, y1 - 1) != targetColor) {
//             spanUp = false;
//           }

//           if (!spanDown && y1 < imageHeight - 1 && _getColor(words, x1, y1 + 1) == targetColor) {
//             queue.add(Offset(x1, y1 + 1));
//             spanDown = true;
//           } else if (spanDown && y1 < imageHeight - 1 && _getColor(words, x1, y1 + 1) != targetColor) {
//             spanDown = false;
//           }
//           x1++;
//         }
//       }
//     }
//     _points.add(null);
//     return _points;
//   }

}

