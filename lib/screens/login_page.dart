import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 
import '../controllers/login_controller.dart';
import 'home_page.dart';
 
/// Apenas DESIGN: validações, banco e estado ficam no LoginController.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
 
  @override
  State<LoginPage> createState() => _LoginPageState();
}
 
class _LoginPageState extends State<LoginPage> {
  final _controller = LoginController();
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  Future<void> _alerta(String titulo, String mensagem) {
    return showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
 
  /// Chama a lógica e decide o que MOSTRAR com o resultado.
  Future<void> _enviar() async {
    final resultado = await _controller.enviar();
    if (!mounted) return;
 
    switch (resultado.status) {
      case LoginStatus.loginOk:
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (_) => HomePage(nome: resultado.nomeUsuario!),
          ),
        );
      case LoginStatus.cadastroOk:
        await _alerta('Sucesso', resultado.mensagem);
      case LoginStatus.dadosInvalidos:
        await _alerta('Atenção', resultado.mensagem);
      case LoginStatus.emailJaCadastrado:
      case LoginStatus.loginIncorreto:
        await _alerta('Erro', resultado.mensagem);
    }
  }
 
  Widget _campo({
    required TextEditingController controller,
    required IconData icone,
    required String placeholder,
    bool senha = false,
    TextInputType? teclado,
    TextInputAction acao = TextInputAction.next,
    VoidCallback? aoEnviar,
  }) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      obscureText: senha,
      keyboardType: teclado,
      autocorrect: false,
      textInputAction: acao,
      onSubmitted: (_) => aoEnviar?.call(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      prefix: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: Icon(icone, color: CupertinoColors.systemGrey, size: 20),
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            // Reconstrói a tela quando o controller chama notifyListeners()
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CupertinoIcons.person_crop_circle_fill,
                    size: 90,
                    color: CupertinoColors.activeBlue,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _controller.titulo,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_controller.modoCadastro) ...[
                    _campo(
                      controller: _controller.nomeCtrl,
                      icone: CupertinoIcons.person,
                      placeholder: 'Nome',
                    ),
                    const SizedBox(height: 12),
                  ],
                  _campo(
                    controller: _controller.emailCtrl,
                    icone: CupertinoIcons.mail,
                    placeholder: 'E-mail',
                    teclado: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _campo(
                    controller: _controller.senhaCtrl,
                    icone: CupertinoIcons.lock,
                    placeholder: 'Senha',
                    senha: true,
                    acao: TextInputAction.done,
                    aoEnviar: _enviar,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      borderRadius: BorderRadius.circular(12),
                      onPressed: _controller.carregando ? null : _enviar,
                      child: _controller.carregando
                          ? const CupertinoActivityIndicator(
                              color: CupertinoColors.white)
                          : Text(_controller.textoBotao),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoButton(
                    onPressed: _controller.alternarModo,
                    child: Text(_controller.textoTroca),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
 