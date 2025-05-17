import 'package:flutter/material.dart';
import '/pag/menu.dart';
import '/pag/item.dart';
import '/pag/evento.dart';
import '/pag/items_evento.dart'; 

final Map<String, WidgetBuilder> appRoutes = {
  '/menu': (context) => Menu(),
  '/items': (context) => ItemPage(),
  '/eventos': (context) => EventoPage(),
};

// Rotas com argumentos
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  if (settings.name == '/items_evento') {
    final args = settings.arguments;
    if (args is int) {
      return MaterialPageRoute(
        builder: (context) => ItemsEventoPage(eventoId: args),
      );
    }
    return _errorRoute();
  }

  // Caso a rota não seja encontrada no mapa nem aqui
  if (appRoutes.containsKey(settings.name)) {
    return MaterialPageRoute(builder: appRoutes[settings.name]!);
  }

  return _errorRoute();
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text('Erro')),
      body: const Center(child: Text('Rota não encontrada!')),
    ),
  );
}