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

  static File generateSpeech(String text) {
    if (modelPath.isEmpty) {
      throw Exception('Model path not set');
          }

    final path = modelPath.toNativeUtf8().cast<Char>();
    final prompt = text.toNativeUtf8().cast<Char>();

    final wavFilePath = lib.piper_generate_speech(path, prompt);

    return File.fromUri(Uri.parse(wavFilePath.cast<Utf8>().toDartString()));
  }
}
