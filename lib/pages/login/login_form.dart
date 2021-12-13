

import 'package:firebase_auth/firebase_auth.dart';
import 'package:locadora/imports.dart';
import 'package:locadora/pages/carros/carros_list.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _formKey = GlobalKey<FormState>();

  final _loginBloc = LoginBloc();

  final _loginInput = LoginInput();

  final _tLogin = TextEditingController();
  final _tSenha = TextEditingController();

  final _focusSenha = FocusNode();

  bool checkManterLogado = false;

  String? _validateLogin(String? text) {
    if (text == null) {
      return "Digite o login";
    }
    return null;
  }

  String? _validateSenha(String? text) {
    if (text == null) {
      return "Digite a senha";
    }
    if (text.length < 6) {
      return "A senha precisa ter pelo menos 6 caracteres";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          AppTextField(
            label: "Login",
            hint: "Digite o login",
            controller: _tLogin,
            validator: (s) => _validateLogin(s),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            nextFocus: _focusSenha,
            onChanged: (s) => _loginInput.login = s,
          ),
          const SizedBox(height: 10),
          AppTextField(
            label: "Senha",
            hint: "Digite a senha",
            controller: _tSenha,
            password: true,
            validator: (s) => _validateSenha(s),
            keyboardType: TextInputType.number,
            focusNode: _focusSenha,
            onChanged: (s) => _loginInput.senha = s,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: StreamBuilder<bool>(
              stream: _loginBloc.progress.stream,
              initialData: false,
              builder: (context, snapshot) {
                return AppButton(
                  "Login",
                  onPressed: _onClickLogin,
                  showProgress: snapshot.data!,
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: _onClickCadastrar,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  "Ainda não é cadastrado?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Center(
                  child: Text(
                    "Crie uma conta",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: _onClickHelp,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  "Ajuda",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Center(
                  child: Icon(
                    Icons.help,
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onClickLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    print("Login: ${_loginInput.login}, Senha: ${_loginInput.senha}");

    ApiResponse<User> response =
        await _loginBloc.login(_loginInput);

    if (response.ok!) {
      User user = response.result!;

      if (user != null) {
        push(context, CarrosListView(), replace: true);
      }
    } else {
      alert(context, response.msg!);
    }
  }


  void _onClickCadastrar() {
    alert(context, "Não implementado :-)");
  }

  void _onClickHelp() {
    alert(context, "Você pode se logar com os seguintes usuários:\n\n * admin@locadora.com.br/admin_pass");
  }

  @override
  void dispose() {
    super.dispose();

    _loginBloc.dispose();
  }
}
