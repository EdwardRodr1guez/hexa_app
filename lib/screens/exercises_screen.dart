import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class Exercises extends StatefulWidget {
  const Exercises({
    super.key,
  });

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  String? numberTextfield;
  bool esPar(int numero) {
    return numero % 2 == 0;
  }

  String? anagrama1;
  String? anagrama2;
  bool esAnagrama(String palabra1, String palabra2) {
    // Remover espacios en blanco y convertir a minúsculas
    palabra1 = palabra1.replaceAll(' ', '').toLowerCase();
    palabra2 = palabra2.replaceAll(' ', '').toLowerCase();

    // Verificar si tienen la misma longitud
    if (palabra1.length != palabra2.length) {
      return false;
    }

    // Convertir las palabras en listas de caracteres y ordenarlas
    List caracteres1 = palabra1.characters.toList()..sort();
    List caracteres2 = palabra2.characters.toList()..sort();

    // Verificar si las listas ordenadas son iguales
    return const ListEquality().equals(caracteres1, caracteres2);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExpansionTile(
            childrenPadding: const EdgeInsets.symmetric(horizontal: 30),
            tilePadding: const EdgeInsets.symmetric(horizontal: 35),
            title: const Text("Número par o impar?"),
            children: [
              TextField(
                onChanged: (value) => setState(() {
                  numberTextfield = value;
                }),
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    hintText: "Ingresa un número max. 4 cifras"),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Resultado:"),
              if ((numberTextfield != "") & (numberTextfield != null))
                Text(esPar(int.parse(numberTextfield.toString()))
                    ? "Par"
                    : "Impar"),
              const SizedBox(
                height: 20,
              ),
            ],
          ),

          //////////////////////////////////////////////////////////////////////////////
          ExpansionTile(
            childrenPadding: const EdgeInsets.symmetric(horizontal: 30),
            tilePadding: const EdgeInsets.symmetric(horizontal: 35),
            title: const Text("Anagramas"),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      onChanged: (value) => setState(() {
                        anagrama1 = value;
                      }),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: "palabra #1"),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      onChanged: (value) => setState(() {
                        anagrama2 = value;
                      }),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: "palabra #2"),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Resultado:"),
              if (((anagrama1 != "") & (anagrama1 != null)) &
                  ((anagrama2 != "") & (anagrama2 != null)))
                Text(esAnagrama(anagrama1!, anagrama2!)
                    ? "son anagramas"
                    : "no son anagramas"),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          //////////////////////////////////////////////////////////////////////
          const ExpansionTile(
            childrenPadding: EdgeInsets.symmetric(horizontal: 30),
            tilePadding: EdgeInsets.symmetric(horizontal: 35),
            title: Text("Array de pesos"),
            children: [
              Text(
                  """Los siguientes son los pasos propuestos para resolver el problema de los pesos:\n
1)Dividir el conjunto de monedas en tres grupos aproximadamente iguales. Por ejemplo, si tenemos 9 monedas, podemos dividirlas en grupos de 3.\n

2)Tomar dos de los grupos y colocarlos en la balanza. Si la balanza se inclina hacia un lado, eso significa que el grupo más pesado contiene la moneda más pesada. Si la balanza se equilibra, eso significa que la moneda más pesada está en el tercer grupo que no se ha utilizado todavía.\n

3)Tomar el grupo más pesado de la primera pesada y seleccionar dos monedas de ese grupo. Colocar una moneda en cada plato de la balanza.\n

4)Si la balanza se inclina hacia un lado, eso significa que la moneda en el plato más pesado es la más pesada. Si la balanza se equilibra, eso significa que la moneda no utilizada en el segundo grupo (el grupo que no se ha utilizado en ninguna pesada) es la más pesada.
                   """)
            ],
          )
        ],
      ),
    );
  }
}
