package;

import hxfsm.integrations.callback.ICallbackState;

/**
 * ...
 * @author GM
 */
class State implements ICallbackState
{
	public function new() 
	{
	}

	public function enter()
	{
		Main.model.startButtonActions !.add(startButtonWatcher);

	}
		
	public function exit()
	{
		
	}

	/**
	 * 
	 * @param	variable
	 */
	function startButtonWatcher(variable:Int) 
	{
		Main.model.startButtonActions !.remove(startButtonWatcher);
	}
	
}