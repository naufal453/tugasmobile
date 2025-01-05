import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _videoController;
  File? _imageFile;

  Future<void> _openCameraForVideo(BuildContext context) async {
    // Mengambil video dari kamera
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      _playVideo(video.path);
    }
  }

  Future<void> _openGalleryForVideo(BuildContext context) async {
    // Mengambil video dari galeri
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      _playVideo(video.path);
    }
  }

  Future<void> _openCameraForImage(BuildContext context) async {
    // Mengambil gambar dari kamera
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _openGalleryForImage(BuildContext context) async {
    // Mengambil gambar dari galeri
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _playVideo(String path) {
    if (_videoController != null) {
      _videoController!.dispose();
    }
    _videoController = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        setState(() {});
        _videoController!.play();
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Media', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _openCameraForVideo(context),
              child: Text('Ambil Video dari Kamera'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _openGalleryForVideo(context),
              child: Text('Ambil Video dari Penyimpanan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _openCameraForImage(context),
              child: Text('Ambil Gambar dari Kamera'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _openGalleryForImage(context),
              child: Text('Ambil Gambar dari Penyimpanan'),
            ),
            SizedBox(height: 20),
            if (_imageFile != null) ...[
              Image.file(
                _imageFile!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
            ],
            if (_videoController != null &&
                _videoController!.value.isInitialized) ...[
              AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
