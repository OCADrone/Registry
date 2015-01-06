#ifndef SERVER_HH
#define SERVER_HH

#include <string>
#include <KNM/net.hh>
#include <KNM/data.hh>
#include <KNM/sync.hh>
#include <AIRegistry/server.hh>
#include "default.hh"

using namespace std;
using namespace KNM;

/**
 * A registry server.
 * Act as a wrapper for the libAIRegistry server, which already
 * include all necessary ressource.
 */
class 	server
{
public:
	server();										/**< Default constructor. */
	server(const string &, int);					/**< Construct with address and port. */
	void reset();									/**< Reset intial state. */
	~server();										/**< Destructor. */

	void 			set_address(const string &);	/**< Set network address. */
	void 			set_port(int);					/**< Set network port. */	
	void 			start();						/**< Start server process. */
	
private:
	void 			init();							/**< Initialize object. */

	KSocket 		link;							/**< Network link. */
	KLog 			log;							/**< Log manager. */
	KTree<string>	regdb;							/**< Tree DB. */
	KMutex 			reglock; 						/**< DB lock. */
};

#endif