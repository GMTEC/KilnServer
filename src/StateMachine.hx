package;

import haxe.Timer;
import hxfsm.FSM;
import hxfsm.FSMController;
import hxfsm.StateClass;
import hxfsm.integrations.callback.CallbackIntegration;
import hxfsm.integrations.callback.ICallbackState;
//import kiln.state.State;
//import kiln.tools.TTS;
//import jsoni18n.I18n;
//import kiln.state.Commands.StateColor;

/**
 * ...
 * @author GM
 */
class StateMachine
{
	var fsmController:FSMController;

	/**
	 * 
	 */
    public function new()
    {
        // Setup FSM using CallbackIntegration
		var fsm:FSM 	= new FSM(new CallbackIntegration());
		fsmController 	= new FSMController(fsm);
		
        // Add states and transitions
        fsm.add(IdleState,			[IdleState, InitialisingState, StartingState, InErrorState]);
        fsm.add(InitialisingState,	[StoppedState, StartingState, InErrorState]);
        fsm.add(StartingState, 		[RunningState, InErrorState]);
        fsm.add(RunningState, 		[StartingState, StoppingState, InErrorState]);
        fsm.add(StoppingState, 		[StoppedState, InErrorState]);
        fsm.add(StoppedState, 		[StartingState, IdleState, InErrorState]);
        fsm.add(InErrorState, 		[]);

		/////////////Test
		//#if test Main.runner.addCase(this); #end
	}

	/**
	 * 
	 */
	public function startFSM() 
	{
        goto(IdleState);
	}

	/**
	 * 
	 * @param	state
	 */
	public function goto(state:StateClass) 
	{
        fsmController.goto(state);
	}

	function onInitialisingState() 
	{
        goto(InitialisingState);
		Timer.delay(onRunningState, 1000);
	}

	function onRunningState() 
	{
        goto(RunningState);
	}

	/**
	 * 
	 */
	public function testStartTemp()
	{
		Main.model.measuredTemp = 38;
	}

}

/**
 * 
 */	
class IdleState extends State  
{
	public override function enter()
	{
		super.enter();
		Main.model.selectionEnabled = true;
		trace("Enter Idle State");
		//Main.model.setStateTextAndColors(I18n.tr("Status/Inactive"), StateColor.IdleStateText, StateColor.IdleStateBack);
		//TTS.setText("Inactive");
		//Main.model.modelStartButton.label = "StartButton/Start";
	}

	/**
	 * 
	 * @param	variable
	 */
	override function startButtonWatcher(variable:Int) 
	{
		super.startButtonWatcher(variable);
		Main.controller.stateMachine.goto(StartingState);
	}
}

/**
 * 
 */
class RunningState extends State implements ICallbackState
{
	var runningTimer:Timer;

	/**
	 * 
	 * @param	target
	 */
	public function new() 
	{
		super();
	}

	public override function enter()
	{
		super.enter();
		Main.model.selectionEnabled = false;
		trace("Enter Running State");
		//Main.model.setStateTextAndColors(I18n.tr("Status/Running"), StateColor.RunningTextCol, StateColor.RunningBackCol);
		//Main.model.modelStartButton.label = "StartButton/Stop";
		//TTS.setText("Running");
		runningTimer		= new Timer(Main.model.fusingCurveModel.runningDelay);
		runningTimer.run 	= onRunningDelay;
	}
	
	override function startButtonWatcher(variable:Int) 
	{
		super.startButtonWatcher(variable);
		Main.controller.stateMachine.goto(StoppingState);
	}

	/**
	 * 
	 */
	function onRunningDelay() 
	{
		if (cast(Main.model.timeElapsed, Int) >= cast(Main.model.fusingCurveModel.setPointDuration, Int)) // End of Fusing Curve?
		{
			Main.controller.stateMachine.goto(StoppingState);
		}
		else
		{
			Main.controller.run();
		}
	}

	public override function exit()
	{
		runningTimer.stop();
	}
}

/**
 * 
 */
class StoppingState extends State implements ICallbackState
{
	public override function enter()
	{
		//Main.model.setStateTextAndColors(I18n.tr("Status/Stopping"), StateColor.StoppingTextCol, StateColor.StoppingBackCol);
		//TTS.setText("Stopping");
		Main.model.timeElapsed = 0;
		Timer.delay(stopped, 1000);
	}
	
	function stopped() 
	{
		Main.controller.stateMachine.goto(StoppedState);
	}
}

/**
 * 
 */	
class InitialisingState extends State implements ICallbackState
{
	public override function enter()
	{
		//Main.model.setStateTextAndColors(I18n.tr("Status/Initialisation"), StateColor.InitialisingStateText, StateColor.InitialisingStateBack);
		//TTS.setText("Initialisation");
	}
}

/**
 * 
 */
class StartingState extends State implements ICallbackState
{
	public override function enter()
	{
		trace("Starting State");
		super.enter();
		//Main.model.setStateTextAndColors(I18n.tr("Status/Starting"), StateColor.StartingTextCol, StateColor.StartingBackCol);
		//TTS.setText("Starting");
		Timer.delay(running, 2000);
	}

	function running() 
	{
		Main.controller.stateMachine.goto(RunningState);
	}
}

/**
 * 
 */
class StoppedState extends State implements ICallbackState
{
	public override function enter()
	{
		Main.model.selectionEnabled = true;
		//Main.model.setStateTextAndColors(I18n.tr("Status/Stopped"), StateColor.StoppedTextCol, StateColor.StoppedBackCol);
		//TTS.setText("Stopped");
		Timer.delay(idle, 2000);
	}

	function idle() 
	{
		Main.controller.stateMachine.goto(IdleState);
	}
}

/**
 * Z
 */
class InErrorState extends State implements ICallbackState
{
 	public override function enter()
	{
		//Main.model.setStateTextAndColors(I18n.tr("Status/InError"), StateColor.InErrorTextCol, StateColor.InErrorBackCol);
	}
}