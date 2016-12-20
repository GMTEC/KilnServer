package;
import com.Arduino;
import com.ArduinoBase.PinMode;
import haxe.Timer;
import hxSerial.Serial;

/**
 * ...
 * @author ^GM
 */
class Server 
{
	static var arduino: Arduino;
	 var timer:Timer=null;
	static var toggle:Int=0;
	static var count:Int = 0;
	static var serialLine: hxSerial.Serial;

	public function new() 
	{
		if (serialLine == null)
		{
			timer = new Timer(1000);
			serialLine = new hxSerial.Serial("COM5", 57600);
			serialLine.setup();
			trace(serialLine);
			arduino = new Arduino(serialLine);
			trace(hxSerial.Serial.getDeviceList());
			arduino.setPinMode(2, PinMode.PIN_MODE_OUTPUT);
		}

		test();
	}

	/**
	 * 
	 */
	public function writeDigitalPin(pin:Int, val:Int):Void
	{
		//test();
		trace(val);
		arduino.writeDigitalPin(pin, val);
		serialLine.flush(true, true);
		//return "Ok" + val;
	}

	/**
	 * 
	 */
	public function test() 
	{
		trace("test");
		timer.run = onTestTimer;
		onTestTimer();
	}
	
	public function onServerUpdate() 
	{
		//onTestTimer();
	}
	/**
	 * 
	 */
	private function onTestTimer() 
	{
		arduino.writeDigitalPin(2, toggle);
		toggle = toggle == 0 ? 1 : 0;
		serialLine.flush(true, true);
	}
}