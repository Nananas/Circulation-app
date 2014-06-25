package ;

import mini.*;

class Simulation extends Scene
{
	private var sim:SimulationContainer;

	private var diseasesBut:Button;
	private var medicationBut:Button;
	private var slidersBut:Button;

	private var diseaseCont:Container;
	private var medicationCont:Container;
	private var sliderCont:Container;

	private var HRText:Text;
	private var SVText:Text;
	private var COText:Text;

	private var MAPText:Text;
	private var CAPText:Text;
	private var AtriumText:Text;

	private var heart : Heart;

	override public function begin()
	{
		MN.backgroundColor = 0xf6f7f5;


		// actual simulation
		sim = new SimulationContainer();
		add(sim);

		///// HUD /////
		var hudBar:Image = Image.rectangle(MN.width, 20, 0xffd24726);
		addImage(hudBar);

		///// CONTAINERS /////
		diseaseCont = new Container(0,20,150,20,0xffd24726);
		add(diseaseCont);
		diseaseCont.addButton(" - ",true).link(function f(){resetSim(Disease.NONE);}).setActive();
		diseaseCont.addButton("Septic Shock",true).link(function f(){resetSim(Disease.SEPTIC);});
		diseaseCont.addButton("Hemorrhage",true).link(function h (){resetSim(Disease.HEMOR);});
		diseaseCont.addButton("Hypertension",true).link(function h (){resetSim(Disease.HYPER);});
		diseaseCont.addButton("Cardiogenic Shock",true).link(function h (){resetSim(Disease.CARDIO);});
		diseaseCont.addButton("SVT",true).link(function h (){resetSim(Disease.SVT);});
		diseaseCont.addButton("Sports",true).link(function h (){resetSim(Disease.SPORT);});
		diseaseCont.addButton("Cardiac arrest",true).link(function h (){resetSim(Disease.ARREST);});
		diseaseCont.addButton("Orthosasis",true).link(function h (){resetSim(Disease.ORTHO);});
		diseaseCont.active = true;

		medicationCont = new Container(0,20,150,20,0xffd24726);
		add(medicationCont);
		medicationCont.addButton("Acetylcholine").link(function f(){ sim.give(Medication.ACETYL);});
		medicationCont.addButton("Penylephrine").link(function f(){ sim.give(Medication.PHENYL);});
		medicationCont.addButton("Adrenaline").link(function f(){ sim.give(Medication.ADREN);});
		medicationCont.addButton("Noradrenaline").link(function f(){ sim.give(Medication.NORADREN);});
		medicationCont.addButton("Propanolol").link(function f(){ sim.give(Medication.PROP);});
		medicationCont.addButton("Nifedipine").link(function f(){ sim.give(Medication.NIFED);});
		medicationCont.addButton("Atropine").link(function f(){ sim.give(Medication.ATROP);});
		medicationCont.addButton("Cedocard").link(function f(){ sim.give(Medication.CEDOC);});
		medicationCont.addButton("Blood Transfusion").link(function f(){ sim.give(Medication.BLOOD);});
		medicationCont.active = false;

		sliderCont = new Container(0, 20, 150, 20, 0xffd24726);
		add(sliderCont);
		sliderCont.addSlider(new Slider("HEART RATE",20, 100, 0, 180, sim.setHeartRate, sim.getHeartRate));
		sliderCont.addSlider(new Slider("RESISTANCE",20, 150, 0.2, 13, sim.setResistance, sim.getResistance));
		sliderCont.addSlider(new Slider("CONTRACTILITY",20, 200, 1, 13, sim.setContractility, sim.getContractility));
		sliderCont.addSlider(new Slider("VENODILATATION",20, 250, 170, 760, sim.setVenodilatation, sim.getVenodilatation));
		sliderCont.addSlider(new Slider("BLOOD VOLUME",20, 300, -2500, 2000, sim.setTransfusion, sim.getTransfusion));
		sliderCont.active = false;

		///// BUTTONS /////
		diseasesBut = new Button("DISEASES", 20, 480, 253, 20, 0xffd24726,"center",true);
		var df = function()	{
			var b:Bool = diseasesBut.getActive();
			medicationCont.active = false;
			diseaseCont.active = b;
			medicationBut.setActive(false);
			slidersBut.setActive(false);
			sliderCont.active = false;
		}
		diseasesBut.setActive();
		diseasesBut.link(df);
		add(diseasesBut);
		medicationBut = new Button("MEDICATION", 273, 480, 253,20, 0xffd24726,"center",true);
		var mf = function() {
			var b:Bool = medicationBut.getActive();
			medicationCont.active = b;
			diseaseCont.active = false;

			diseasesBut.setActive(false);
			slidersBut.setActive(false);
			sliderCont.active = false;
		}
		medicationBut.link(mf);
		add(medicationBut);
		slidersBut = new Button("SLIDERS", 526, 480, 253,20, 0xffd24726,"center",true);
		var sf = function() {
			var b:Bool = slidersBut.getActive();
			medicationCont.active = false;
			diseaseCont.active = false;
			medicationBut.setActive(false);
			diseasesBut.setActive(false);
			sliderCont.active = b;
		}
		slidersBut.link(sf);
		add(slidersBut);

		///// TEXT /////
		HRText = new Text("HR: 60 /min");
		HRText.setColor(0xffffffff);
		addImage(HRText, 20, 1);

		SVText = new Text("SV: 84 ml");
		SVText.setColor(0xffffffff);
		addImage(SVText, 125, 1);

		COText = new Text("CO: 5.05 l/min");
		COText.setColor(0xffffffff);
		addImage(COText, 210, 1);

		MAPText = new Text("MAP: 95 mmHg");
		MAPText.setColor(0xffffffff);
		addImage(MAPText, 430, 1);

		CAPText = new Text("CAP: 15 mmHg");
		CAPText.setColor(0xffffffff);
		addImage(CAPText, 555, 1);

		AtriumText = new Text("Atrium: 55 mmHg ");
		AtriumText.setColor(0xffffffff);
		addImage(AtriumText, 666, 1);


		// blue to pink flow tube
		var bptube = new Image("assets/blue-pink.png");
		addImage(bptube,360,370);

		// pink to red flow tube
		var prtube = new Image("assets/pink-red.png");
		addImage(prtube, 226, 429);

		// heart on top of prtube
		heart = new Heart(255,410);
		add(heart);
	}

	override public function update(dt:Float)
	{
		// update heart spead
		heart.setSpeed(sim.getHeartRate());
		

		// update textfields
		HRText.setText("HR: " + Std.int(sim.frequency) + " /min");
		SVText.setText("SV: " + Std.int(sim.slagvolume*2.5) + " ml");
		COText.setText("CO: " + Std.int(sim.slagvolume*sim.frequency*2.5/10)/100 + " l/min");

		MAPText.setText("MAP: " + Std.int(sim.h1 / 3) + " mmHg");
		CAPText.setText("CAP: " + Std.int(sim.h2 / 3) + " mmHg");
		AtriumText.setText("Atrium: " + Std.int(sim.h3 / 3) + " mmHg");
		super.update(dt);
	}

	// resets variables for each disease
	public function resetSim(disease:Disease)
	{
		// reset simulationcontainer
		sim.reset();

		sim.set(disease);		
	}

}

enum Disease
{
	NONE;
	SEPTIC;
	HEMOR;
	HYPER;
	CARDIO;
	SVT;
	SPORT;
	ARREST;
	ORTHO;
}

enum Medication
{
	ACETYL;
	PHENYL;
	ADREN;
	NORADREN;
	PROP;
	NIFED;
	ATROP;
	CEDOC;
	BLOOD;
}
