package;

import hx.binding.IBindable;
import Model;
import ModelBase;
import StateMachine;
//import Client;


/**
 * 
 */
class Controller implements IBindable
{
	var model:Model;
 	@:bindable public var stateMachine		:StateMachine;
 	//public var client		:Client;

	public function new(model:Model) 
	{
		//super();
			
		this.model = model;
	
		//client = new Client(model.clientModel);

		//model.loadCurrentLanguage();
		stateMachine = new StateMachine();
		
		// Add Watchers here:
		model.currentSelectedTemperature 				!.add(currentSelectedSetTempWatcher);
		model.fusingCurveModel.currentSelectedSetPoint 	!.add(currentSelectedSetPointWatcher);
		//
	}

	function currentSelectedSetPointWatcher(variable:SetPoint) 
	{
		trace(variable.Y);
		Main.model.currentSelectedTemperature = variable.Y;
	}

	/**
	 * 
	 * @param	temp
	 */
	function currentSelectedSetTempWatcher(temp:Int) 
	{
		trace(temp);
		Main.model.fusingCurveModel.currentSelectedSetPoint.Y = temp;
		Main.model.fusingCurveModel.setPointTemps.updateSetPointsTemperatures(Main.model.fusingCurveModel.currentSelectedSetPoint.index);
	}

	/**
	 * 
	 */
	public function startController() 
	{
		stateMachine.startFSM();
		//Main.model.startModel();
	}

	/**
	 * 
	 */
	public function run() 
	{
		//Main.model.setNextMeasuredTemperature();
		//Main.simulator.run();
	}

	public function resetToFactorySettings() 
	{
		//Main.model.resetToFactorySettings();
	}

	public function onTempAdjusted(val:Dynamic) 
	{
		trace("onTempAdjusted");
		Main.model.fusingCurveModel.currentSelectedSetPoint.Y = val;
	}

}
