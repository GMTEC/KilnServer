package;

/**
 * ...
 * @author ^GM
 */
class Main
{
	public static var clients = new List<ClientData>();
	public static var server	:Server;
	public static var model		:Model;
	public static var controller:Controller;

	static function initClientApi( scnx : haxe.remoting.SocketConnection, context : haxe.remoting.Context ) {
		trace("Client connected");
		var c = new ClientData(scnx);
		context.addObject("api",c);
	}

	static function onClientDisconnected( scnx ) {
		trace("Client disconnected");
		ClientData.ofConnection(scnx).leave();
	}

	static function main() 
	{
		server 		= new Server();
		model 		= new Model();
		controller 	= new Controller(model);
		controller.startController();

		var host = "localhost";
		var domains = [host];
		var s = new neko.net.ThreadRemotingServer(domains);
		s.initClientApi = initClientApi;
		s.clientDisconnected = onClientDisconnected;
		trace("Starting server...");
		s.update = server.onServerUpdate;
		s.run(host, 1024); // loop?
		trace("Main Exit");
	}

}