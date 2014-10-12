// Buses and Receive Data Array

~mData = Array.newClear(4);
~bus = Bus.control(s, 4);
~quark = Bus.newFrom(~bus, 0, 1);
~matter = Bus.newFrom(~bus, 1, 1);
~phenomena = Bus.newFrom(~bus, 2, 1);
~expansion = Bus.newFrom(~bus, 3, 1);


~buffer = Buffer.allocConsecutive(6, s, 2.pow(13), 1, bufnum:0)
s.listSendBundle(0.5,
	(0..6).collect({|i| [\b_gen, i, \sine3, 1, 1, 1, {(10.0+i*2).rand}!2.pow(i), {1.0.rand}!2.pow(i), {1.0.rand}!2.pow(i)*2*pi].asOSCArgArray})
);

(
// OSC Responder
OSCFunc({|msg|
	4.do({|i| try{
		~mData.put(i, msg[i+1].asInt);
		~quark.set(ControlSpec(1500, 100000, 'exponential').unmap(~mData[0]));
		~matter.set(ControlSpec(1000, 100000, 'exponential').unmap(~mData[1]));
		~phenomena.set(ControlSpec(800, 60000).unmap(~mData[2]));
		~expansion.set(ControlSpec(800, 100000).unmap(~mData[3]));
		~bus.get;
		}
	});

}, "/jacket");


x = Array.newClear(4);
x[0] = Synth(\quark);
x[1] = Synth(\matter);
x[2] = Synth(\phenomena);
x[3] = Synth(\expansion);


x[0].map(\gate, ~quark);
x[0].map(\value, ~quark);
x[0].map(\buffer, ~buffer[5].bufnum);
x[1].map(\gate, ~matter);
x[1].map(\value, ~matter);
x[2].map(\gate, ~phenomena);
x[2].map(\value, ~phenomena);
x[3].map(\gate, ~expansion);
x[3].map(\value, ~expansion);
)

(
SynthDef(\quark, {|out=0, gate = 0, value = 0, buffer = 0|
	var env, sound;

	env = EnvGen.ar(Env([0,1,0], [0.2, 1.4], curve:8), Dust.ar(value.linlin(0, 1, 20, 60))*Lag.kr(gate), timeScale:1/value.linlin(0, 1, 100, 500));
	sound = RLPF.ar(COsc.ar(5, value.linlin(0, 1, 1, 10.0), 1), value.linlin(0, 1, 3000, 600), 0.1);
	Out.ar(out, sound*env);


}, [\kr, \tr, \kr]).add;

SynthDef(\matter, {|out=0, gate=0, value = 0|
	var env, sound;

	env = EnvGen.kr(Env([0,1,0], [2,1]), gate, timeScale: value.linlin(0, 1, 1, 2.0));
	sound = RLPF.ar(VOsc.ar(value.linlin(0,1, 0.0, 5.0), value.linexp(0,1,6.2,2.0)), value.linlin(0,1, 800, 4000), 0.2);
	Out.ar(out, sound*env);


}, [\kr, \tr, 1.0]).add;

SynthDef(\phenomena, {|out=0, gate=0, value = 0|
	var env, sound;

	env = EnvGen.kr(Env([0,1,0], [1,1], -6), gate, timeScale: value.linlin(0,1, 0.6, 0.03));
	sound = RLPF.ar(COsc.ar(3, value.linexp(0,1,30.0,10.0), value.linexp(0,1, 0.5, 5.0)), 2000, value.linlin(0,1, 0.5, 0.05), value.linlin(0, 1, 0.2, 0.6));
	Out.ar(out, sound*env);

}, [\kr, \tr, 0.2]).add;

SynthDef(\expansion, {|out=0, gate=0, value = 0|
	var env, sound;

	env = EnvGen.kr(Env([0,1,0], [1,1]), gate, timeScale: value.linlin(0,1, 0.6, 2.0));
	sound = Osc.ar(3, 1.0+Sweep.kr(gate, value.linlin(0, 1, 50, 500)),mul:value.linlin(0, 1, 0.2, 0.5));
	Out.ar(out, sound*env);


}, [\kr, \tr, 0.06]).add;
)



{RLPF.ar(COsc.ar(1, MouseX.kr(1, 500.0), mul:0.2)!2, MouseY.kr(50,2000) , 0.1)*EnvGen.ar(Env([0,1,0], curve:8), Dust.ar(20), timeScale:1/MouseX.kr(20, 200))}.play;


{VOsc.ar(SinOsc.ar(MouseY.kr(0.1, 1)).range(1.0,6.0), MouseX.kr(13, 60))}.play;


{OscN.ar(2, 200)}.play
