
package ;

import mini.Entity;
import Simulation.Disease;
import Simulation.Medication;

class SimulationContainer extends Entity
{
	private var _list:Array<Entity>;
	private var _currentDisease:Disease;

	///////////// VARIABLES ////////////
	private var area1:Float;
	private var area2:Float;
	private var area3:Float;

	private var w1:Float;
	public var w2:Float;
	private var _w2:Float;
	private var w3:Float;

	public var h1:Float;
	public var h2:Float;
	public var h3:Float;

	private var dA1:Float;
	private var dA2:Float;
	private var dA3:Float;

	private var totalArea:Int;
	private var _totalArea:Int;
	private var newTotalArea:Float;
	private var oldTotalArea:Float;
	private var dAtot:Float;

	public var frequency:Float;
	private var _frequency:Int;
	public var slagvolume:Float;
	private var contractility:Float;
	private var _contractility:Float;
	public var cardiacOutput:Float;

	private var K:Float;	// box1 -> box2
	private var _K:Float;
	private var U:Float;	// box2 -> box3
	private var _U:Float;

	private var transfusion:Float;

	/////////////  OBJECTS  ////////////
	private var box1:Box;
	private var box2:Box;
	private var box3:Box;

	public function new ()
	{
		super(0,0,null);
		_list = new Array<Entity>();

		// variables
		totalArea = 5000;
		_totalArea = totalArea;

		h1 = 285;
		h2 = 45;
		h3 = 15;

		w1 = 10;
		w2 = 324;
		_w2 = w2;
		w3 = 36;

		area1 = h1*w1;
		area2 = h2*w2;
		area3 = h3*w3;

		dA1 = 0;
		dA2 = 0;
		dA3 = 0;

		newTotalArea = _totalArea;
		oldTotalArea = _totalArea;
		dAtot = 0;

		frequency = 60;
		_frequency = 60;
		K = 7.1;
		_K = K;
		U = 1.15;
		_U = U;
		contractility = 6.6;
		_contractility = contractility;

		transfusion = 0;

		// boxes
		box1 = new Box(226, 450, Std.int(w1), Std.int(h1), 0xffc37379);
		box2 = new Box(390, 450, Std.int(w2), Std.int(h2), 0xffc6d8f2);
		box3 = new Box(330, 450, Std.int(w3), Std.int(h3), 0xff76607c);
		add(box1);
		add(box2);
		add(box3);
	}

	override public function render()
	{
		for (e in _list)
		{
			e.render();
		}

		// no super call
	}

	override public function update(dt:Float)
	{
		// update variables
		oldTotalArea = newTotalArea;
		newTotalArea = _totalArea + transfusion;
		dAtot = newTotalArea - oldTotalArea;

		h1 = area1/w1;
		h2 = area2/w2;
		h3 = area3/w3;

		if (h3 < 0){
			h3 = 0;
			//frequency = 0;
		}
		
		slagvolume = contractility * 5 * Math.sqrt(h3/15) * Math.sqrt(285/h1);
		cardiacOutput = frequency / 60 * slagvolume;

		if (h3==0)
		{
			cardiacOutput = 0;
		}
		
		dA1 = cardiacOutput - 1/K*(h1-h2);
		dA2 = 1/K*(h1-h2) - U*(h2-h3);
		dA3 = U*(h2-h3) - cardiacOutput;

		area1 += dA1;
		area2 += dA2 + dAtot;
		area3 += dA3;

		// update boxes
		box1.height = Std.int(h1);
		box2.height = Std.int(h2*2);
		box2.width = Std.int(w2);
		box3.height = Std.int(h3*2);
		

		for (e in _list)
		{
			e.update(dt);
		}

		// no super call
	}

	public function reset()
	{
		// reset variables
		frequency = _frequency;
		K = _K;
		U = _U;
		contractility = _contractility;
		w2 = _w2;
		totalArea = _totalArea;
		transfusion = 0;
	}

	private function add(e:Entity):Int
	{
		return _list.push(e);
	}

		// changes variables for each disease
	public function set(disease:Disease)
	{
		if (_currentDisease == disease) return;
		switch (disease) {
			case SEPTIC:
				setResistance(K * 0.5);
				setContractility(contractility * 0.75);
				var current:Float = transfusion + _totalArea;
				setTransfusion(-current * 0.4);
			case HEMOR:
				var current:Float = transfusion + _totalArea;
				setTransfusion(-current * 0.65);
			case HYPER:
				setResistance(K * 1.5);
			case CARDIO:
				setContractility(1);
			case SVT:
				frequency = 180;
				U = 0.6;
			case SPORT:
				frequency = 140;
				setContractility(contractility * 2.5);
				setResistance(K * 0.33);
				U = 2.4;
				setVenodilatation(w2*0.75);
			case ARREST: 
				setHeartRate(0);
				//K = 2;
				setVenodilatation(760);
			case ORTHO:
				U = 0.5;
			default: 	//none
		}
	}

	public function give(med:Medication)
	{
		switch(med){
			case ACETYL:
				setHeartRate(frequency * 0.8);
				setContractility(contractility * 1.05);
			case PHENYL:
				setResistance(K * 1.2);
			case ADREN:
				setResistance(K * 0.95);
				setContractility(contractility * 1.1);
				setHeartRate(frequency * 1.4);
				setVenodilatation(w2 * 0.8);
			case NORADREN:
				setResistance(K * 1.1);
				setContractility(contractility * 1.1);
				setHeartRate(frequency * 1.25);
				setVenodilatation(w2 *0.8);
			case PROP:
				setHeartRate(frequency * 0.5);
				setResistance(K * 1.05);
				setContractility(contractility * 0.9);
			case NIFED:
				setResistance(K * 0.9);
			case ATROP:
				setHeartRate(frequency * 1.2);
				setContractility(contractility * 1.05);
			case CEDOC:
				setVenodilatation(w2 + 40);
			case BLOOD:
				setTransfusion(transfusion + 500);
		}
	}



	//// ACCESSORS
	
	public function getVenodilatation() { return w2; }
	public function setVenodilatation(value:Float) { w2 = value; if (w2 < 170) w2 = 170;}

	public function getHeartRate() { return frequency; }
	public function setHeartRate(value:Float) { 
		frequency = value; 
		if (frequency < 0) frequency = 0;
		if (frequency > 300) frequency = 300;
	}

	public function getResistance() {return K;}
	public function setResistance(value:Float){
		K = value; 
		if (K<0.2) K=0.2;
		if (K>13) K=13;
	}

	public function getContractility() { return contractility;}
	public function setContractility(value:Float) {
		contractility = value;
		if (contractility < 1) contractility = 1;
		if (contractility > 13) contractility = 13;
	}

	public function getTransfusion() { return transfusion;}
	public function setTransfusion(value:Float) {
		transfusion = value;
		if (transfusion < - 2500) transfusion = -2500;
		if (transfusion > 2000) transfusion = 2000;
	}

}