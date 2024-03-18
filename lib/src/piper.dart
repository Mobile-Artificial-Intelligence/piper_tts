import 'dart:ffi';
import 'dart:io';

import 'bindings.dart';

class Piper {
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
}
