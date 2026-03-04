# package_a

Paquete Flutter local que demuestra cómo **encapsular rutas de navegación** dentro de un paquete independiente usando `auto_route`. Este paquete es consumido por [test_routing](https://github.com/BusterAlan/test_routing/tree/auto_route_navigation) como dependencia de ruta local.

---

## 📋 Objetivo

Mostrar que `auto_route` permite definir y exportar rutas desde paquetes locales o publicados, manteniendo cada módulo autónomo y desacoplado del router principal de la aplicación. Esto es especialmente útil en arquitecturas de **monorepo** o **feature-first**.

---

## 📦 Dependencias

| Paquete | Versión | Propósito |
|---|---|---|
| `auto_route` | ^11.1.0 | Gestión declarativa de rutas |

**Dev dependencies:**
- `auto_route_generator` — Generador de código para las rutas
- `build_runner` — Ejecuta la generación de código

---

## 🗂️ Estructura del paquete

```
lib/
├── package_a.dart              # Punto de entrada público del paquete
├── pages/
│   ├── home_page.dart          # Primera pantalla del paquete
│   └── detail_page.dart        # Segunda pantalla del paquete
└── routes/
    ├── package_a_router.dart   # Definición de rutas (@AutoRouterConfig)
    └── package_a_router.gr.dart # GENERADO — no editar manualmente
```

---

## 🧭 Rutas definidas

```dart
@AutoRouterConfig()
class PackageARouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, path: "/home"),
    AutoRoute(page: DetailRoute.page, path: "/detail"),
  ];
}
```

### Páginas

**HomePage** (`/home`)  
Pantalla principal del paquete. Contiene un `FloatingActionButton` que navega hacia `DetailPage`.

```dart
@RoutePage()
class HomePage extends StatelessWidget {
  void _onPressed(BuildContext context) =>
    context.router.push(const DetailRoute());
}
```

**DetailPage** (`/detail`)  
Pantalla de detalle, destino final del flujo interno del paquete.

```dart
@RoutePage()
class DetailPage extends StatelessWidget {
  // Pantalla final del flujo de package_a
}
```

---

## ⭐ Ventaja clave: rutas encapsuladas y exportables

### El problema sin encapsulación

En una app grande sin modularización, el router principal acaba conociendo todas las páginas de todos los módulos:

```dart
// ❌ Sin encapsulación: el router principal depende de TODOS los módulos
AutoRoute(page: FeatureAHomePage.page, path: "/feature-a"),
AutoRoute(page: FeatureADetailPage.page, path: "/feature-a/detail"),
AutoRoute(page: FeatureBHomePage.page, path: "/feature-b"),
// ... decenas de rutas acopladas
```

### La solución con package_a

`package_a` define y exporta su propio `PackageARouter`. El router principal solo importa ese objeto y usa spread para integrar las rutas:

```dart
// ✅ Con encapsulación: el router principal solo conoce PackageARouter
import 'package:package_a/routes/package_a_router.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // ... rutas propias de la app
    ...PackageARouter().routes,  // ← Una sola línea integra todo package_a
  ];
}
```

### Navegación desde la app hacia el paquete

La app importa las rutas generadas del paquete y navega hacia ellas con type-safety:

```dart
// En umbrella_page.dart (dentro de test_routing)
import 'package:package_a/routes/package_a_router.gr.dart';

void _onPressed(BuildContext context) =>
  context.router.push(const HomeRoute());
```

---

## 🔄 Flujo de navegación interno

```
HomePage (/home)
    │
    └─► DetailPage (/detail)
```

---

## 🚀 Generación de código

Cada vez que se modifiquen las páginas anotadas con `@RoutePage()` o el archivo `package_a_router.dart`, regenerar:

```bash
# Desde la raíz de package_a
flutter pub run build_runner build --delete-conflicting-outputs
```

> **Nota:** El archivo `package_a_router.gr.dart` es generado automáticamente. No debe editarse a mano.

---

## 🔗 Cómo usar este paquete en otra app

### 1. Agregar la dependencia en `pubspec.yaml`

```yaml
dependencies:
  package_a:
    path: ../package_a   # Ruta relativa al paquete local
```

### 2. Integrar las rutas en el router principal

```dart
import 'package:package_a/routes/package_a_router.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Rutas propias...
    ...PackageARouter().routes,
  ];
}
```

### 3. Navegar hacia las pantallas del paquete

```dart
import 'package:package_a/routes/package_a_router.gr.dart';

context.router.push(const HomeRoute());
```

---

## 📐 Beneficios de esta arquitectura

| Beneficio | Descripción |
|---|---|
| **Desacoplamiento** | El router principal no importa páginas individuales del paquete |
| **Escalabilidad** | Agregar nuevas páginas en `package_a` no requiere tocar `AppRouter` |
| **Reutilización** | El mismo paquete puede integrarse en múltiples apps |
| **Mantenibilidad** | Cada equipo puede trabajar su módulo de forma independiente |
| **Type-safety** | Las rutas generadas mantienen la verificación de tipos en toda la app |