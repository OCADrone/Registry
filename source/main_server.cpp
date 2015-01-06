#include <KNM/base.hh>
#include <KNM/parse/KConfig.hh>
#include <default.hh>
#include <server.hh>

using namespace std;
using namespace KNM;

void 		usage()
{
	cerr << "usage: regserver [-p|--port <port>] [-i|--interface <address>]" << endl;
	cerr << "default: localhost:5006" << endl;
	exit(1);

}

int 		main(int ac, char **av)
{
	server 		host;
	KConfig 	config;

	// Get optios and configure server
	if (config.is_flag(ac, av, 'h', "help")){usage();}
	host.set_address(*config.find_s(ac, av, 'i', "interface", "127.0.0.1"));
	host.set_port(KUtils::to_int(*config.find_s(ac, av, 'p', "port", "5006")));

	try
	{
		host.start();
	}
	catch(const KError &error)
	{
		error.dump();
		return 1;
	}

	return 0;
}
