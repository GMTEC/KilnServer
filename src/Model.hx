package;
import persistent.Users.User;
import sys.db.Manager;
import sys.db.Sqlite;

/**
 * ...
 * @author ^GM
 */
class Model extends ModelBase
{
	public function new() 
	{
		super();

		trace("Starting Model ...");
		
		init();
	}

	function init()
	{
		var cnx = Sqlite.open('kiln.sqlite');
		// Initialize the sys.db.Manager that handles the SPOD stuff behind the scenes
		Manager.cnx = cnx;
		// Create the User table in my-database.sqlite if it doesn't exist
		if ( !sys.db.TableCreate.exists(User.manager) ) sys.db.TableCreate.create(User.manager); 		

		//usersModel.users = User.manager.all();
	}
}