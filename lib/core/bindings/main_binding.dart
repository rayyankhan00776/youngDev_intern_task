import 'package:get/get.dart';
import '../../features/login/services/auth_service.dart';
import '../../features/login/viewmodels/login_viewmodel.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Services - Permanent instances (fenix: true)
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);

    // ViewModels - Permanent instances (fenix: true)
    Get.lazyPut<LoginViewModel>(
      () => LoginViewModel(authService: Get.find<AuthService>()),
      fenix: true,
    );
  }
}
