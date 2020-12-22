import 'package:fluro/fluro.dart';

abstract class LunaModuleRouter {
    /// Given the [FluroRouter], define all routes and handlers required for the module.
    void defineAllRoutes(FluroRouter router);
}
