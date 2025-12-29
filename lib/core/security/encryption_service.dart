import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  final _secureStorage = const FlutterSecureStorage();
  static const String _keyStorageKey = 'encryption_master_key';

  encrypt.Key? _masterKey;
  encrypt.IV? _iv;

  /// Initialize encryption service with master key
  Future<void> initialize() async {
    await _loadOrCreateMasterKey();
    _iv = encrypt.IV.fromLength(16);
  }

  /// Load existing key or create new one
  Future<void> _loadOrCreateMasterKey() async {
    try {
      String? storedKey = await _secureStorage.read(key: _keyStorageKey);

      if (storedKey != null) {
        _masterKey = encrypt.Key.fromBase64(storedKey);
      } else {
        // Generate new key
        _masterKey = encrypt.Key.fromSecureRandom(32);
        await _secureStorage.write(
          key: _keyStorageKey,
          value: _masterKey!.base64,
        );
      }
    } catch (e) {
      throw Exception('Failed to initialize encryption: $e');
    }
  }

  /// Encrypt text data
  Future<String> encryptText(String plainText) async {
    try {
      if (_masterKey == null) await initialize();

      final encrypter = encrypt.Encrypter(
        encrypt.AES(_masterKey!, mode: encrypt.AESMode.cbc),
      );

      final encrypted = encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  /// Decrypt text data
  Future<String> decryptText(String encryptedText) async {
    try {
      if (_masterKey == null) await initialize();

      final encrypter = encrypt.Encrypter(
        encrypt.AES(_masterKey!, mode: encrypt.AESMode.cbc),
      );

      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      return encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  /// Encrypt file bytes
  Future<Uint8List> encryptFile(Uint8List fileBytes) async {
    try {
      if (_masterKey == null) await initialize();

      final encrypter = encrypt.Encrypter(
        encrypt.AES(_masterKey!, mode: encrypt.AESMode.cbc),
      );

      final encrypted = encrypter.encryptBytes(fileBytes, iv: _iv);
      return encrypted.bytes;
    } catch (e) {
      throw Exception('File encryption failed: $e');
    }
  }

  /// Decrypt file bytes
  Future<Uint8List> decryptFile(Uint8List encryptedBytes) async {
    try {
      if (_masterKey == null) await initialize();

      final encrypter = encrypt.Encrypter(
        encrypt.AES(_masterKey!, mode: encrypt.AESMode.cbc),
      );

      final encrypted = encrypt.Encrypted(encryptedBytes);
      return Uint8List.fromList(encrypter.decryptBytes(encrypted, iv: _iv));
    } catch (e) {
      throw Exception('File decryption failed: $e');
    }
  }

  /// Hash password with SHA-256
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate random encryption key
  String generateRandomKey({int length = 32}) {
    final key = encrypt.Key.fromSecureRandom(length);
    return key.base64;
  }

  /// Encrypt JSON data
  Future<String> encryptJson(Map<String, dynamic> jsonData) async {
    final jsonString = json.encode(jsonData);
    return await encryptText(jsonString);
  }

  /// Decrypt JSON data
  Future<Map<String, dynamic>> decryptJson(String encryptedJson) async {
    final decryptedString = await decryptText(encryptedJson);
    return json.decode(decryptedString);
  }

  /// Clear all encryption keys (use with caution!)
  Future<void> clearKeys() async {
    await _secureStorage.delete(key: _keyStorageKey);
    _masterKey = null;
    _iv = null;
  }

  /// Check if encryption is initialized
  bool get isInitialized => _masterKey != null;
}
