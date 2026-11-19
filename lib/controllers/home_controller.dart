class HomeController {
  final String nome;

  const HomeController(this.nome);

  String get titulo => 'Início';
  String get saudacao => 'Olá, $nome! :D';
}