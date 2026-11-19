import 'package:flutter/widgets.dart';

import '../database/database_helper.dart';

enum LoginStatus {
  dadosInvalidos,
  cadastroOk,
  emailJaCadastrado,
  loginOk,
  loginIncorreto,
}

/// Resultado de uma tentativa de login/cadastro.
/// A tela só decide COMO mostrar (alerta, navegação); a regra fica aqui.
class ResultadoLogin {
  final LoginStatus status;
  final String mensagem;
  final String? nomeUsuario;

  const ResultadoLogin(this.status, this.mensagem, {this.nomeUsuario});
}

class LoginController extends ChangeNotifier {
  final nomeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();

  final _db = DatabaseHelper.instance;

  bool _modoCadastro = false;
  bool _carregando = false;

  bool get modoCadastro => _modoCadastro;
  bool get carregando => _carregando;

  String get titulo => _modoCadastro ? 'Criar conta' : 'Entrar';
  String get textoBotao => _modoCadastro ? 'Cadastrar' : 'Entrar';
  String get textoTroca =>
      _modoCadastro ? 'Já tem conta? Entrar' : 'Não tem conta? Cadastre-se';

  void alternarModo() {
    _modoCadastro = !_modoCadastro;
    notifyListeners();
  }

  /// Valida os campos. Retorna a mensagem de erro ou null se estiver tudo ok.
  String? _validar() {
    final nome = nomeCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final senha = senhaCtrl.text;

    if (email.isEmpty || senha.isEmpty || (_modoCadastro && nome.isEmpty)) {
      return 'Preencha todos os campos.';
    }
    if (!email.contains('@')) return 'Digite um e-mail válido.';
    if (_modoCadastro && senha.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }
    return null;
  }

  Future<ResultadoLogin> enviar() async {
    final erro = _validar();
    if (erro != null) {
      return ResultadoLogin(LoginStatus.dadosInvalidos, erro);
    }

    _carregando = true;
    notifyListeners();

    try {
      if (_modoCadastro) {
        final ok = await _db.registrar(
          nomeCtrl.text,
          emailCtrl.text,
          senhaCtrl.text,
        );
        if (!ok) {
          return const ResultadoLogin(
            LoginStatus.emailJaCadastrado,
            'Este e-mail já está cadastrado.',
          );
        }
        _modoCadastro = false;
        senhaCtrl.clear();
        return const ResultadoLogin(
          LoginStatus.cadastroOk,
          'Conta criada! Faça login para continuar.',
        );
      }

      final usuario = await _db.login(emailCtrl.text, senhaCtrl.text);
      if (usuario == null) {
        return const ResultadoLogin(
          LoginStatus.loginIncorreto,
          'E-mail ou senha incorretos.',
        );
      }
      return ResultadoLogin(
        LoginStatus.loginOk,
        'Login realizado.',
        nomeUsuario: usuario['name'] as String,
      );
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    emailCtrl.dispose();
    senhaCtrl.dispose();
    super.dispose();
  }
}
