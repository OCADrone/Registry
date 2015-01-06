#include <iostream>
#include <KNM/base.hh>
#include <KNM/net.hh>
#include <AIRegistry/client.hh>

using namespace std;
using namespace KNM;
using namespace AIRegistry;

void 			usage()
{
	cerr << "usage: regclient <address> <port> <command> <path> [value]" << endl;
	cerr << "--- commands ---"                   << endl;
	cerr << "read  | get : access key value"     << endl;
	cerr << "write | set : set key value"        << endl;
	cerr << "mknode      : create new node"      << endl;
	cerr << "mkleaf      : create new leaf"      << endl;
	cerr << "isnode      : check if node exists" << endl;
	cerr << "isleaf      : check if leaf exists" << endl;

	exit(1);
}

int 					main(int ac, char **av)
{
	string 				resp;
	AIRegistry::client 	regclient;

	if (ac < 4)
		usage();

	regclient.set_address(av[1]);
	regclient.set_port(KUtils::to_int(av[2]));

	try
	{
		regclient.connect();
		resp = av[3];

		if (resp == "write" || resp == "set")
		{
			if (ac < 6){usage();}
			regclient.query(AIRegistry::WRITE, av[4], av[5]);
		}

		else if (resp == "read" || resp == "get")
		{
			regclient.query(AIRegistry::READ, av[4]);
			if (!regclient.get_state())
				cerr << "server error: " << "key doesn't exists" << endl;
			else
				cout << regclient.get_data() << endl;
		}

		else if (resp == "mknode")
		{
			regclient.query(AIRegistry::MKNODE, av[4]);
			if (!regclient.get_state())
				cerr << "server error: " << regclient.get_data() << endl;
		}

		else if (resp == "mkleaf")
		{
			regclient.query(AIRegistry::MKLEAF, av[4]);
			if (!regclient.get_state())
				cerr << "server error: " << regclient.get_data() << endl;
		}

		else if (resp == "isnode")
		{
			regclient.query(AIRegistry::ISNODE, av[4]);
			if (!regclient.get_state())
				cerr << "false" << endl;
			else
				cout << "true" << endl;
		}

		else if (resp == "isleaf")
		{
			regclient.query(AIRegistry::ISLEAF, av[4]);
			if (!regclient.get_state())
				cerr << "false" << endl;
			else
				cout << "true" << endl;
		}

		regclient.disconnect();
	}
	catch(const KError &error)
	{
		cerr << "local error: ";
		error.dump();
	}

	if (regclient.get_state())
		return true;
	return false;
}
