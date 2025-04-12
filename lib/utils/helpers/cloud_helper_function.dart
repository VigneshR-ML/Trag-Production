import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TCloudHelperFunction {
  static Widget? checkSingleRecordState<T>(AsyncSnapshot<T> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!snapshot.hasData || snapshot.data == null) {
      return const Center(child: Text('No data Found'));
    }
    if (snapshot.hasError) {
      return const Center(child: Text('Something went Wrong'));
    }
    return null;
  }

  static Widget? checkMultiRecordState<T>({
    required AsyncSnapshot<List<T>> snapshot,
    Widget? loader,
    Widget? error,
    Widget? nothingFound,
  }) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return loader ?? const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return error ?? const Center(child: Text('Something went wrong.'));
    }

    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
      return nothingFound ?? const Center(child: Text('No Data Found!'));
    }

    return null;
  }

  static Future<String> getURLFromFilePathAndName(String path) async {

  try {
    if (path.isEmpty) return '';
    final ref = FirebaseStorage.instance.ref().child(path);
    final url = await ref.getDownloadURL();
    return url;
  } on FirebaseException catch (e) {
    throw e.message ?? 'An unknown Firebase error occurred.';
  } on PlatformException catch (e) {
    throw e.message ?? 'An unknown platform error occurred.';
  } catch (e) {
    throw 'Something went wrong. Please try again.';
  }
}
}
