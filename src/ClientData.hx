package;

import haxe.remoting.AsyncProxy;
import haxe.remoting.SocketConnection;
/**
 * ...
 * @author ^GM
 */
// define a typed remoting API
class ClientApiImpl extends haxe.remoting.AsyncProxy<ClientApi> {
}

// our client class
class ClientData implements ServerApi {

	var api : ClientApiImpl;
	var name : String;

	public function new( scnx : haxe.remoting.SocketConnection ) {
		api = new ClientApiImpl(scnx.client);
		(cast scnx).__private = this;
	}

	public function identify( name : String ) {
		if( this.name != null )
			throw "You are already identified";
		this.name = name;
		Main.clients.add(this);
		for( c in Main.clients ) {
			if( c != this )
				c.api.userJoin(name);
			api.userJoin(c.name);
		}
	}

	public function say( text : String ) {
		for( c in Main.clients )
			c.api.userSay(name,text);
	}

	/**
	 * 
	 * @param	pin
	 * @param	value
	 */
	public function refreshDigitalPin(pin:Int, value:Int) {
		for( c in Main.clients )
			c.api.refreshDigitalPin(pin,value);
	}

	public function writeDigitalPin( pin:Int, value:Int ) : Void {
		Main.server.writeDigitalPin(pin, value);

		for( c in Main.clients )
			c.api.refreshDigitalPin(pin, value);
			trace("-------writeDigitalPin -----");
	}

	public function leave() {
		if( Main.clients.remove(this) )
			for( c in Main.clients )
				c.api.userLeave(name);
	}

	public static function ofConnection( scnx : haxe.remoting.SocketConnection ) : ClientData {
		return (cast scnx).__private;
	}

}
