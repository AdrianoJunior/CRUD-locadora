import 'package:locadora/firebase/firebase_service.dart';
import 'package:locadora/imports.dart';

class CarroFormPage extends StatefulWidget {
  final Carro? carro;

  CarroFormPage({this.carro}) : super();

  @override
  _CarroFormPageState createState() => _CarroFormPageState();
}

class _CarroFormPageState extends State<CarroFormPage> {
  // Url do upload
  String? urlFoto;

  late ApiResponse response;

  Carro? get carro => widget.carro;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "carro_form");

  var _showProgress = false;
  final tNome = TextEditingController();
  final tPlaca = TextEditingController();
  final tAno = TextEditingController();
  final tFabricante = TextEditingController();
  final tTipo = TextEditingController();
  int? _radioIndex = 0;
  bool reservado = false;

  bool uploading = false;

  @override
  void initState() {
    super.initState();

    // Copia os dados do carro para o form
    if (carro != null) {
      tNome.text = carro!.modelo!;
      tPlaca.text = carro!.placa!;
      tAno.text = carro!.ano!;
      tFabricante.text = carro!.fabricante!;
      reservado = carro!.reservado!;
      _radioIndex = getTipoInt(carro!);
    }
  }

  String? _validateNome(String? value) {
    if (value == null) {
      return 'Informe o nome do carro.';
    }

    return null;
  }

  String? _validatePlaca(String? value) {
    if (value == null) {
      return 'Informe a placa do carro.';
    }
    return null;
  }

  String? _validateAno(String? value) {
    if (value == null) {
      return 'Informe o ano do carro.';
    }
    return null;
  }

  String? _validateFabricante(String? value) {
    if (value == null) {
      return 'Informe o fabricante do carro.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: carro != null
            ? Text("${carro!.modelo} - ${carro!.placa}")
            : const Text("Novo Carro"),
        actions: carro != null
            ? [
                DeleteButton(
                  onPressed: _onClickDelete,
                )
              ]
            : null,
      ),
      body: body(),
    );
  }

  body() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _cardFoto(),
        ),
        const SizedBox(
          width: 28,
        ),
        Expanded(
          flex: 2,
          child: _cardForm(),
        )
      ],
    );
  }

  void _onClickTipo(int? value) {
    setState(() {
      _radioIndex = value;
    });
  }

  getTipoInt(Carro carro) {
    switch (carro.tipo) {
      case "classicos":
        return 0;
      case "esportivos":
        return 1;
      default:
        return 2;
    }
  }

  String _getTipo() {
    switch (_radioIndex) {
      case 0:
        return "classicos";
      case 1:
        return "esportivos";
      default:
        return "luxo";
    }
  }

  _cardFoto() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
//        width: 350,
        height: 320,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  uploading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : _foto(),
                  const SizedBox(
                    height: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _foto() {
    /*String url = carro != null ? carro!.urlFoto : null;
    if (urlFoto != null) {
      // Se tirou foto, fica com a foto nova
      url = urlFoto!;
    }*/

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 250,
        maxHeight: 250,
      ),
      child: Image.asset("assets/imgs/car_logo.png", fit: BoxFit.cover),
    );
  }

  _cardForm() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Tipo",
//              textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 18,
                ),
              ),
              _radioTipo(),
              const SizedBox(
                height: 10,
              ),
              AppTextField(
                label: "Nome",
                controller: tNome,
                required: true,
                validator: (s) => _validateNome(s),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              AppTextField(
                label: "Placa",
                controller: tPlaca,
                required: true,
                validator: (s) => _validatePlaca(s),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              AppTextField(
                label: "Ano",
                controller: tAno,
                required: true,
                keyboardType: TextInputType.text,
                validator: (s) => _validateAno(s),
              ),
              const SizedBox(
                height: 10,
              ),
              AppTextField(
                label: "Fabricante",
                controller: tFabricante,
                required: true,
                keyboardType: TextInputType.text,
                validator: (s) => _validateFabricante(s),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text("Reservado"),
                  Checkbox(
                    value: reservado,
                    onChanged: (value) {
                      setState(() {
                        reservado = value!;
                        if (carro != null) {
                          carro!.reservado = value;
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  AppButton(
                    "Cancelar",
                    onPressed: _onClickCancelar,
                    whiteMode: true,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  AppButton(
                    "Salvar",
                    onPressed: _onClickSalvar,
                    showProgress: _showProgress,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _radioTipo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 0,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        const Text(
          "Clássicos",
          style: TextStyle(color: AppColors.blue, fontSize: 14),
        ),
        Radio(
          value: 1,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        const Text(
          "Esportivos",
          style: TextStyle(color: AppColors.blue, fontSize: 14),
        ),
        Radio(
          value: 2,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        const Text(
          "Luxo",
          style: TextStyle(color: AppColors.blue, fontSize: 14),
        ),
      ],
    );
  }

  _onClickSalvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Cria o carro
    var c = carro ?? Carro();
    c.modelo = tNome.text;
    c.placa = tPlaca.text;
    c.reservado = reservado;
    c.ano = tAno.text;
    c.fabricante = tFabricante.text;
    c.tipo = _getTipo();
    c.urlFoto =
        'https://firebasestorage.googleapis.com/v0/b/locadora-veiculos-404ca.appspot.com/o/car_logo.png?alt=media&token=89d3b417-9630-4ac7-881a-7f34ca683701';

    if (urlFoto != null) {
      // Atualiza a URL de upload no carro
      c.urlFoto = urlFoto;
    }

    print("Carro: $c");

    setState(() {
      _showProgress = true;
    });

    print("Salvar o carro $c");

    if (carro == null) {
      response = await FirebaseService.saveCarro(c.toMap());
    } else {
      response = await FirebaseService.updateCarro(c);
    }

    if (response.ok!) {
      alert(context, "Carro salvo com sucesso", callback: () {
        pop(context);
      });
    } else {
      alert(context, response.msg!);
    }

    setState(() {
      _showProgress = false;
    });

    print("Fim.");
  }

  _onClickCancelar() {
    pop(context);
  }

  void _onClickDelete() {
    // Alerta para confirmar
    alertConfirm(context, "Deseja mesmo excluir?", confirmCallback: delete);
  }

  delete() async {
    ApiResponse response = await FirebaseService.delete(carro);
    if (response.ok!) {
      alert(context, "Carro excluido com sucesso!", callback: () {
        pop(context);
      });
    } else {
      alert(context, response.msg!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
