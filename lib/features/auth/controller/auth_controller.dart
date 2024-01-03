import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';

import '../../../core/utils.dart';
import '../../../models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final AuthControllerProvider = Provider(
    (ref) => AuthController(authRepository: ref.read(AuthRepositoryProvider), ref: ref));

class AuthController extends StateNotifier{
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository, _ref = ref, super(false);

  void signInWithGoogle(BuildContext context) async{
    final user = await _authRepository.signInWithGoogle();
    user.fold((l) => showSnackBar(context, l.message), (r) => _ref.read(userProvider.notifier).update((state) => r));
    //l means failure, r means success
  }
}
