import 'package:auto_route/auto_route.dart';
import 'package:package_a/routes/package_a_router.gr.dart';

@AutoRouterConfig()
class PackageARouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, path: "/home"),
    AutoRoute(page: DetailRoute.page, path: "/detail"),
  ];
}
