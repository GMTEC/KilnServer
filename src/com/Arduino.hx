package com;

import hxSerial.Serial;
import haxe.io.BytesOutput;
import haxe.Timer;

/**
 * ...
 * @author GM
 */
class Arduino extends ArduinoBase
{
	var alarmActive:Bool;
	var timerTest:Timer;
	var timerHorn:Timer;
	var currentRedLampState:Bool;
	var currentSirenPlaying:Bool;
	var testToggle:Bool;
	//var timerPolling:nme.utils.Timer;

	/**
	 * 
	 */
	public function new(serialLine:Serial) 
	{
		super();

		this.serialLine = serialLine;
	}

	/**
	 * 
	 * @param	e
	 */
	private function onShortHornFinished(e:Dynamic):Void 
	{
		timerHorn.stop();
		outputSiren(false);
	}

	/**
	 * 
	 * @param	e
	 */
	private function onTestToggle(e:Dynamic):Void 
	{
		testToggle = ! testToggle;
		outputSiren(testToggle);
		outputRedLamp(testToggle);
	}

	/**
	 * 
	 * @param	e
	 */
	private function onShortSiren(e:Dynamic):Void 
	{
		//timerHorn.run = 
		//outputSiren();
	}

	/**
	 * 
	 * @param	e
	 */
	private function onTestOn(e:Dynamic):Void 
	{
		//trace("AAAAAA Arduino : onTestOn");

		//timerTest.start();
	}
	
	/**
	 * 
	 * @param	e
	 */
	private function startPWm(duty:Int, delay:Int):Void 
	{
		_sysExData.set(0, ArduinoBase.START_SYSEX);
		_sysExData.set(1, 7);
		_sysExData.set(2, 0);
		_sysExData.set(3, 0);
		_sysExData.set(4, 64);
		_sysExData.set(5, 0);
		_sysExData.set(6, 64);
		_sysExData.set(7, ArduinoBase.END_SYSEX);
	}

	/**
	 * 
	 * @param	e
	 */
	private function onTestOff(e:Dynamic):Void 
	{
		//trace("AAAAAA Arduino : onTestOff");
		timerTest.stop();
		outputSiren(currentSirenPlaying);
		outputRedLamp(currentRedLampState);
	}

	/**
	 * 
	 * @param	e
	 */
	private function OnExit(e:Dynamic):Void 
	{
		//trace("Arduino : OnExit");
		playSiren();
		setRedLamp();
		haxe.Timer.delay(onClose, 500); // iOS 6
	}

	/**
	 * 
	 */
	function onClose() 
	{
		serialLine.close();
	}

	/**
	 * 
	 * @param	e
	 */
	//private function OnState(e:StateMachineEvent):Void 
	//{
		//trace("AAAAAA Arduino : OnState");
//
		//if (alarmActive != Session.panelStateMachine.isAlarmManualAckEnabled())
			//alarmModified(alarmActive);
	//}

	function alarmModified(alarmActive:Bool) 
	{
		alarmActive = !alarmActive;

		playSiren(alarmActive);
		setRedLamp(alarmActive);
	}

	/**
	 * 
	 * @param	e
	 */
	private function OnAlarmAck(e:Dynamic):Void 
	{
		playSiren(false);
		setRedLamp(false);
	}

	/**
	 * 
	 * @param	play
	 */
	function playSiren(play:Bool = true) 
	{
		currentSirenPlaying = play;
		outputSiren(play);
	}

	private function OnRedLamp(e:Dynamic):Void 
	{
		setRedLamp();
	}
	
	private function OnGreenLamp(e:Dynamic):Void 
	{
		setRedLamp(false);
	}

	/**
	 * 
	 * @return
	 */
	function initCom():Bool
	{
		//serialLineOK =  serialLine.initCom(15, 57600);
		//trace("initCom Serial Arduino : " + serialLineOK);
//
		//if (serialLineOK)
		//{
			//setPinMode(4, PIN_MODE_OUTPUT);
			//setPinMode(5, PIN_MODE_OUTPUT);
			//setPinMode(6, PIN_MODE_OUTPUT);
			//setPinMode(7, PIN_MODE_OUTPUT);
//
			//playSiren(false); // Siren Off
			//setRedLamp();
			//setWatchDog();
		//}
//
		//return serialLineOK;
		return true;
	}

	/**
	 * 
	 * @param	redLamp
	 */
	function setRedLamp(redLamp:Bool = true) 
	{
		trace("Arduino: outputSiren: " + redLamp);
		currentRedLampState = redLamp;
		outputRedLamp(redLamp);
	}

	function outputRedLamp(redLamp:Bool) 
	{
		writeDigitalPin(6, redLamp ? 0 : 1);
	}

	function outputSiren(play:Bool = true) 
	{
		trace("Arduino: outputSiren: " + play);
		writeDigitalPin(5, play ? 0 : 1);
	}

	/**
	 * 
	 */
	function setWatchDog() 
	{
		writeDigitalPin(4, 1); // Watchdog
	}	
}