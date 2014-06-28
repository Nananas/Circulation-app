package ;

import mini.*;
import flash.geom.Point;

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
	private var CVPText:Text;
	private var AtriumText:Text;

	private var heart : Heart;

	private var brtube : Image;
	private var brtubePosition : Point;

	private var resetButton:Button;
	private var reset:Image;
	private var fullscreenButton:Button;
	private var fullscreen:Image;

	private var bloodsplatter : Image;
	private var skull : Image;
	private var redWarning : Warning;
	private var pinkWarning: Warning;
	private var lowerredWarning : Warning;
	private var waterOverlay : Image;
	private var waterOverlayPosition : Point;
	private var waterText : Image;

	private var pause : Bool;

	override public function begin()
	{
		MN.backgroundColor = 0xf6f7f5;

		pause = false;

		// actual simulation
		sim = new SimulationContainer();
		add(sim);

		// blue to pink flow tube
		var bptube = new Image("assets/blue-pink.png");
		addImage(bptube,518,370);

		// pink to red flow tube (heart)
		var prtube = new Image("assets/pink-red.png");
		addImage(prtube, 540, 429);

		// blue to red flow tube (left side)
		brtube = new Image("assets/blue-red.png");
		brtubePosition = new Point(0, 340);
		//addImage(brtube,800-140,340);

		// extra blue tube
		var btube = Image.rectangle(300, 8, 0x64c6d8f2); // alpha = 0.5
		addImage(btube, 140, 422);

		// red to blue flow tube (right side)
		var rbtube = new Image("assets/red-blue.png");
		addImage(rbtube,680,340);

		// extra red tube
		//var rtube = Image.rectangle(90, 8, 0x64c37379); // alpha = 0.5
		//addImage(rtube, 140, 422);

		// heart on top of prtube
		heart = new Heart(600,410);
		add(heart);

		///// HUD /////
		var hudBar:Image = Image.rectangle(MN.width, 20, 0xffd24726);
		addImage(hudBar);

		///// CONTAINERS /////
		diseaseCont = new Container(0,20,150,20,0xffd24726);
		add(diseaseCont);
		var noDisease : Button = diseaseCont.addButton(" - ",true);
			noDisease.link(function f(){resetSim(Disease.NONE);}).setActive();
		diseaseCont.addButton("Septic Shock",true).link(function f(){resetSim(Disease.SEPTIC);});
		diseaseCont.addButton("Hemorrhage",true).link(function h (){resetSim(Disease.HEMOR);});
		diseaseCont.addButton("Hypertension",true).link(function h (){resetSim(Disease.HYPER);});
		diseaseCont.addButton("Cardiogenic Shock",true).link(function h (){resetSim(Disease.CARDIO);});
		diseaseCont.addButton("SVT",true).link(function h (){resetSim(Disease.SVT);});
		diseaseCont.addButton("Sports",true).link(function h (){resetSim(Disease.SPORT);});
		diseaseCont.addButton("Cardiac arrest",true).link(function h (){resetSim(Disease.ARREST);});
		diseaseCont.addButton("Orthostasis",true).link(function h (){resetSim(Disease.ORTHO);});
		diseaseCont.active = true;

		medicationCont = new Container(0,20,150,20,0xffd24726);
		add(medicationCont);
		medicationCont.addButton("Acetylcholine").link(function f(){ sim.give(Medication.ACETYL);});
		medicationCont.addButton("Phenylephrine").link(function f(){ sim.give(Medication.PHENYL);});
		medicationCont.addButton("Adrenaline").link(function f(){ sim.give(Medication.ADREN);});
		medicationCont.addButton("Noradrenaline").link(function f(){ sim.give(Medication.NORADREN);});
		medicationCont.addButton("Propanolol").link(function f(){ sim.give(Medication.PROP);});
		medicationCont.addButton("Nifedipine").link(function f(){ sim.give(Medication.NIFED);});
		medicationCont.addButton("Atropine").link(function f(){ sim.give(Medication.ATROP);});
		medicationCont.addButton("Nitrates").link(function f(){ sim.give(Medication.CEDOC);});
		medicationCont.addButton("Blood Transfusion").link(function f(){ sim.give(Medication.BLOOD);});
		medicationCont.active = false;

		sliderCont = new Container(0, 20, 150, 20, 0xffd24726);
		add(sliderCont);
		sliderCont.addSlider(new Slider("HEART RATE",20, 100, 0, 180, sim.setHeartRate, sim.getHeartRate));
		sliderCont.addSlider(new Slider("RESISTANCE (arteriolar)",20, 150, 0.2, 13, sim.setResistance, sim.getResistance));
		sliderCont.addSlider(new Slider("CONTRACTILITY",20, 200, 1, 13, sim.setContractility, sim.getContractility));
		sliderCont.addSlider(new Slider("CAPACITANCE (venous)",20, 250, 170, 760, sim.setVenodilatation, sim.getVenodilatation));
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

		CVPText = new Text("CVP: 15 mmHg");
		CVPText.setColor(0xffffffff);
		addImage(CVPText, 555, 1);

		AtriumText = new Text("Atrium: 55 mmHg ");
		AtriumText.setColor(0xffffffff);
		addImage(AtriumText, 666, 1);


		// reset button
		resetButton = new Button("R", 0, 500-20, 20,20, 0xffd24726, "center", false);
		resetButton.link(function f(){ waterOverlayPosition.y = 500; sim.hardReset(); diseaseCont.deactivateAll(); noDisease.setActive(true); pause = false;});
		add(resetButton);

		// fullscreen button
		fullscreenButton = new Button("F", 800-20,500-20, 20,20,0x00000000, "center", false);
		fullscreenButton.link(function f(){ 
			if (MN.stage.displayState == openfl.display.StageDisplayState.NORMAL)
			{
				MN.stage.displayState = openfl.display.StageDisplayState.FULL_SCREEN;

			}
			else
			{
				MN.stage.displayState = openfl.display.StageDisplayState.NORMAL;
			}
		});
		add(fullscreenButton);
		fullscreen = new Image("assets/fullscreen.png");

		// reset button image
		reset = new Image("assets/reset.png");
		

		bloodsplatter = new Image("assets/blood.png");
		skull = new Image("assets/skull.png");
		redWarning = new Warning(700,50, "assets/red-warning.png");
		pinkWarning= new Warning(600,300, "assets/pink-warning.png");
		lowerredWarning = new Warning(700, 300, "assets/red-warning.png");

		waterOverlay = new Image("assets/water.png");
		waterOverlayPosition = new Point(0,500);
		waterText = new Image("assets/waterText.png");
	}

	override public function update(dt:Float)
	{
		if (!pause)
		{
			// update heart spead
			heart.setSpeed(sim.getHeartRate());
			
			// update blue to red tube position
			brtubePosition.x = MN.clamp(sim._startBox2X - sim.w2 - brtube.width, -150, 0);

			// update textfields
			HRText.setText("HR: " + Std.int(sim.frequency) + " /min");
			SVText.setText("SV: " + Std.int(sim.slagvolume*2.5) + " ml");
			COText.setText("CO: " + Std.int(sim.slagvolume*sim.frequency*2.5/10)/100 + " l/min");

			MAPText.setText("MAP: " + Std.int(sim.h1 / 3) + " mmHg");
			CVPText.setText("CVP: " + Std.int(sim.h2 / 3) + " mmHg");
			AtriumText.setText("Atrium: " + Std.int(sim.h3 / 3) + " mmHg");
			super.update(dt);

			if (sim.h1 > 140*3)
			{
				redWarning.update(dt);
			}
			if (sim.h1 < 45*3)
			{
				lowerredWarning.update(dt);
			}

			if (sim.h3>18*3)
			{
				pinkWarning.update(dt);
			}

			if (waterOverlayPosition.y < 500 && sim.h3 < 18*3)
			{
				waterOverlayPosition.y += 1;
			}
		
		}
	}

	override public function render()
	{
		// blue to red tube, movable image
		brtube.render(brtubePosition);

		// all other
		super.render();

		// render warnings
		if (sim.h1 > 140 * 3)
		{
			redWarning.render();
		}

		// render death
		if (sim.h1 > 160 * 3)
		{
			bloodsplatter.render(new Point (0,0));
			pause = true;
		}

		if (sim.h1 < 35*3)
		{
			skull.render(new Point(0,0));
			pause = true;
		}

		if (sim.h1 < 45*3)
		{
			lowerredWarning.render();
		}

		if (sim.h3 > 18*3 && !pause)
		{
			pinkWarning.render();

			waterOverlayPosition.y -= sim.h3/(18*3)*2;

			if (waterOverlayPosition.y <= 0)
			{
				// death!
				pause = true;
			}
		}

		waterOverlay.render(waterOverlayPosition);

		if (sim.h3 > 18*3 && pause)
		{
			waterText.render(new Point(180, 150));
		}


		// top layer: reset button & fullscreen
		reset.render(new Point(0,500-20));
		fullscreen.render(new Point(800-20, 500-20));

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
