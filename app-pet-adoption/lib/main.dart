import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Pet Adoption Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Client httpClient;
  Web3Client ethClient;

  String lastTransactionHash;

  @override
  void initState() {
    super.initState();
    httpClient = new Client();
    ethClient = new Web3Client("http://192.168.1.103:7545", httpClient);
  }

  Future<DeployedContract> loadContract() async {
    String abiCode = await rootBundle.loadString("assets/abi.json");
    String contractAddress =
        "0x48a56959C0BC8d185A17bdD64B7bC71b7697b55a"; // contract address PetAdoption

    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, "PetAdoption"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(
        "afdec86569b627e4cf4c7dea62eb41d864f01f06ad900d2e9636737cf6d36aa4");

    DeployedContract contract = await loadContract();

    final ethFunction = contract.function(functionName);

    try {
      var result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
        ),
      );

      return result;
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.message)));
      return null;
    }
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final data = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return data;
  }

  Future<String> adopt(int petId) async {
    // uint in smart contract means BigInt for us
    var bigPettId = BigInt.from(petId);
    // adopt transaction
    var response = await submit("adopt", [bigPettId]);
    // hash of the transaction
    return response;
  }

  Future<List<dynamic>> getAdopter(int petId) async {
    var bigPettId = BigInt.from(petId);
    List<dynamic> result = await query("adopters", [bigPettId]);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildshelters(),
    );
  }

  @override
  Widget buildshelters() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: 16,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            height: 90,
            child: Center(
                child: Row(children: [
              Icon(
                Icons.pets,
                size: 40,
                color: Colors.blueGrey,
              ),
              SizedBox(width: 10),
              Expanded(
                  child: FutureBuilder(
                future: getAdopter(index),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text('Adopter ${index}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                          Text('Owner: ${snapshot.data[0]}'),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Timestamp: ${snapshot.data[1]}'),
                        ]);
                  } else
                    return Text('Loading...');
                },
              )),
              SizedBox(width: 10),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blue),
                  child: Text('Adopt'),
                  onPressed: () async {
                    var result = await adopt(index);
                    setState(() {
                      lastTransactionHash = result;
                    });
                  })
            ])));
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
