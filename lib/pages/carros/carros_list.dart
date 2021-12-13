import 'package:locadora/imports.dart';

class CarrosListView extends StatefulWidget {
  @override
  _CarrosListViewState createState() => _CarrosListViewState();
}

class _CarrosListViewState extends State<CarrosListView> {
  final _bloc = CarrosBloc();

  List<Carro>? carros;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          push(context, CarroFormPage());
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Carros"),
        actions: [
          IconButton(
            onPressed: () {
              alert(context,
                  "Projeto locadora de veículos\nSistema desenvolvido em Flutter\n\nAlunos:\nAdriano Coutinho\nFabricio Godoy\n\nFATEC Taubaté");
            },
            icon: Icon(Icons.info),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: CarrosBloc().stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Não foi possível buscar os carros");
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final carros = snapshot.data;

          return _grid(carros);
        },
      ),
    );
  }

  int _columns(constraints) {
    int columns = constraints.maxWidth > 800 ? 3 : 2;
    if (constraints.maxWidth <= 500) {
      columns = 1;
    }
    return columns;
  }

  _grid(var carros) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = _columns(constraints);

        return Container(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              childAspectRatio: 1.8,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemCount: carros != null ? carros.size : 0,
            itemBuilder: (context, index) {
              Carro c = carros.docs[index].data();
              return StackMaterialContainer(
                child: _cardCarro(c),
                onTap: () => _onClickCarro(c),
              );
            },
          ),
        );
      },
    );
  }

  _cardCarro(Carro c) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double font = constraints.maxWidth * 0.04;

        return Card(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 240,
                      maxHeight: 120,
                    ),
                    child: Image.asset('assets/imgs/car_logo.png'),
                  ),
                ),
                Center(
                  child: text(
                    "${c.modelo}\n${c.placa}",
                    fontSize: fontSize(font),
                    maxLines: 2,
                    ellipsis: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _onClickCarro(Carro c) {
    push(context, CarroFormPage(carro: c));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
