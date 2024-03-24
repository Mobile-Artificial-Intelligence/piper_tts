import 'dart:ffi';
import 'dart:io';

import 'bindings.dart';

import 'package:ffi/ffi.dart';

class Piper {
  static String modelPath = '';
  static piper_tts? _lib;

  static piper_tts get lib {
    if (_lib == null) {
      if (Platform.isWindows) {
        _lib = piper_tts(DynamicLibrary.open('piper.dll'));
      } else if (Platform.isLinux || Platform.isAndroid) {
        _lib = piper_tts(DynamicLibrary.open('libpiper.so'));
      } else if (Platform.isMacOS || Platform.isIOS) {
        throw Exception('Unsupported platform');
        //_lib = maid_llm(DynamicLibrary.open('bin/llama.dylib'));
      } else {
        throw Exception('Unsupported platform');
      }
    }
    return _lib!;
  }

  static Future<File> generateSpeech(String text) async {
    final prompt = text.toNativeUtf8().cast<Char>();

    Pointer<Char> wavFilePath;
    if (modelPath.isEmpty) {
      Pointer<Char> path = nullptr;
      wavFilePath = lib.piper_generate_speech(path, prompt);
    } else {
      Pointer<Char> path = modelPath.toNativeUtf8().cast<Char>();
      wavFilePath = lib.piper_generate_speech(path, prompt);
    }

    final filePath = wavFilePath.cast<Utf8>().toDartString();
    final file = File(filePath);

    // Create a 5 second timeout for the file to exist
    final timeout = DateTime.now().add(const Duration(seconds: 5));

    // wait for the file to exist
    while (!file.existsSync()) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (DateTime.now().isAfter(timeout)) {
        throw Exception('Failed to generate speech');
      }
    }

    return file;
  }
}
