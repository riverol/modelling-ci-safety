/*
 * HalfBandRecess.java
 */

import com.comsol.model.*;
import com.comsol.model.util.*;

public class HalfBandRecessSymmetric {

  public static Model run() {
    Model model = ModelUtil.create("Model");

    model.modelPath("/Users/Andrian/Desktop/PhD/Model Data/HalfBandRecess");

    model.label("HalfBandRecessSymmetric.mph");

    model.comments("HalfBandRecessSymmetric\n\n");

    model.param().set("LENG", "0.85[mm]", "length of the domain, based on 0.55mm electrode pitch");
    model.param().set("DARR", "0.5[mm]", "diameter of the array at level E6");
    model.param().set("DCYL", "2[mm]", "diameter of the scala tympani, approximate");
    model.param().set("ETH", "0.1[mm]", "electrode pad thickness, arbitrary");
    model.param()
         .set("recess", "0.06[mm]", "the normal distance between the surface of the electrode and the outer surface of the silicone carrier.");
    model.param().set("area", "0.0785[mm^2]", "Geometric area of the electrode");
    model.param().set("ChargeDensity", "8[uC/cm^2]", "length of the electrode along array dimension, E1-E18.");
    model.param().set("i0_l", "9.14e-3[A/m^2]", "exchange current density, determined by potential sweep McAdams");
    model.param().set("a_a", "0.099", "anodic transfer coeff.,  determined by potential sweep McAdams");
    model.param().set("a_c", "0.378", "cathodic transfer coeff.,  determined by potential sweep McAdams");
    model.param().set("ne", "2", "no. of electrons,  determined by potential sweep McAdams");
    model.param().set("temp", "298[K]", "temperature, approximate lab conditions");
    model.param().set("i0_f", "1e-6[A/m^2]", "exchange current density, fitted to voltammetry by Hudak");
    model.param().set("a_af", "0.29", "anodic transfer coeff, fitted to voltammetry by Hudak");
    model.param().set("a_cf", "0.23", "cathodic transfer coeff, fitted to voltammetry by Hudak");
    model.param().set("pw", "75e-6[s]", "pulse width, s");
    model.param()
         .set("polarity", "1", "determines the direction of the current pulse, either positive or negative 1, depends on the direction surface normal vectors.");
    model.param().set("ELENG", "(2*area)/(pi*DARR)", "Width of electrode pads along the array dimension");
    model.param().set("ERAD", "sqrt(area/pi)", "Radius of the disc electrode");
    model.param().set("amps", "area*ChargeDensity/pw", "Amplitude of the current pulse with pulse width, pw");

    model.modelNode().create("mod1");
    model.modelNode("mod1").label("Model 1");
    model.modelNode("mod1").defineLocalCoord(false);

    model.file().clear();

    model.func().create("an6", "Analytic");
    model.func().create("an5", "Analytic");
    model.func().create("an3", "Analytic");
    model.func("an6").model("mod1");
    model.func("an6").set("args", new String[]{"t"});
    model.func("an6").set("argunit", "s");
    model.func("an6").set("expr", "(1.57)*t^(0.91)/(gamma(1.91))");
    model.func("an6").set("plotargs", new String[][]{{"t", "0", "25e-6"}});
    model.func("an6").set("funcname", "cpe");
    model.func("an6").set("fununit", "ohm*m^2");
    model.func("an5").model("mod1");
    model.func("an5").active(false);
    model.func("an5").set("args", new String[]{"overpot"});
    model.func("an5").set("argunit", "V");
    model.func("an5")
         .set("expr", "(i0_l*(exp((a_a*ne*F_const*overpot)/(R_const*temp))-exp((-a_c*ne*F_const*overpot)/(R_const*temp))))");
    model.func("an5").set("plotargs", new String[][]{{"overpot", "0", "1"}});
    model.func("an5").set("funcname", "bv1");
    model.func("an5").set("fununit", "A/m^2");
    model.func("an3").model("mod1");
    model.func("an3").set("args", new String[]{"overpot"});
    model.func("an3").set("argunit", "V");
    model.func("an3")
         .set("expr", "(i0_f*(exp((a_af*ne*F_const*overpot)/(R_const*temp))-exp((-a_cf*ne*F_const*overpot)/(R_const*temp))))");
    model.func("an3").set("plotargs", new String[][]{{"overpot", "0", "1"}});
    model.func("an3").set("funcname", "bv2");
    model.func("an3").set("fununit", "A/m^2");

    model.geom().create("geom1", 3);

    model.mesh().create("mesh1", "geom1");

    model.geom("geom1").create("cyl3", "Cylinder");
    model.geom("geom1").feature("cyl3").label("CarrierL");
    model.geom("geom1").feature("cyl3").set("r", "DARR/2 + recess");
    model.geom("geom1").feature("cyl3").set("axis", new String[]{"1", "0", "0"});
    model.geom("geom1").feature("cyl3").set("pos", new String[]{"-LENG/2", "0", "0"});
    model.geom("geom1").feature("cyl3").set("layerside", false);
    model.geom("geom1").feature("cyl3").set("h", "LENG/2-ELENG/2");
    model.geom("geom1").create("cyl4", "Cylinder");
    model.geom("geom1").feature("cyl4").label("Electrode");
    model.geom("geom1").feature("cyl4").set("r", "DARR/2 + recess");
    model.geom("geom1").feature("cyl4").setIndex("layer", "recess", 0);
    model.geom("geom1").feature("cyl4").set("axis", new String[]{"1", "0", "0"});
    model.geom("geom1").feature("cyl4").set("pos", new String[]{"-ELENG/2", "0", "0"});
    model.geom("geom1").feature("cyl4").set("layername", new String[]{"Layer 1"});
    model.geom("geom1").feature("cyl4").set("h", "ELENG");
    model.geom("geom1").create("cyl7", "Cylinder");
    model.geom("geom1").feature("cyl7").label("CarrierR");
    model.geom("geom1").feature("cyl7").set("r", "DARR/2 + recess");
    model.geom("geom1").feature("cyl7").set("axis", new String[]{"1", "0", "0"});
    model.geom("geom1").feature("cyl7").set("pos", new String[]{"ELENG/2", "0", "0"});
    model.geom("geom1").feature("cyl7").set("layerside", false);
    model.geom("geom1").feature("cyl7").set("h", "LENG/2-ELENG/2");
    model.geom("geom1").create("cyl6", "Cylinder");
    model.geom("geom1").feature("cyl6").label("Electrode 1");
    model.geom("geom1").feature("cyl6").set("r", "DARR/2 - ETH");
    model.geom("geom1").feature("cyl6").set("axis", new String[]{"1", "0", "0"});
    model.geom("geom1").feature("cyl6").set("pos", new String[]{"-ELENG/2", "0", "0"});
    model.geom("geom1").feature("cyl6").set("layerside", false);
    model.geom("geom1").feature("cyl6").set("h", "ELENG");
    model.geom("geom1").create("wp1", "WorkPlane");
    model.geom("geom1").feature("wp1").label("Electrode Splitter");
    model.geom("geom1").feature("wp1").set("unite", "on");
    model.geom("geom1").feature("wp1").set("quickplane", "xz");
    model.geom("geom1").create("par1", "Partition");
    model.geom("geom1").feature("par1").label("Half-Band");
    model.geom("geom1").feature("par1").set("partitionwith", "workplane");
    model.geom("geom1").feature("par1").selection("input").set(new String[]{"cyl4"});
    model.geom("geom1").create("del1", "Delete");
    model.geom("geom1").feature("del1").selection("input").init(3);
    model.geom("geom1").feature("del1").selection("input").set("par1(1)", new int[]{1, 2});
    model.geom("geom1").create("cyl1", "Cylinder");
    model.geom("geom1").feature("cyl1").label("Scala");
    model.geom("geom1").feature("cyl1").set("r", "DCYL/2");
    model.geom("geom1").feature("cyl1").set("axis", new String[]{"1", "0", "0"});
    model.geom("geom1").feature("cyl1").set("pos", new String[]{"-LENG/2", "0", "0"});
    model.geom("geom1").feature("cyl1").set("h", "LENG");
    model.geom("geom1").create("blk2", "Block");
    model.geom("geom1").feature("blk2").label("Symmetry Block1");
    model.geom("geom1").feature("blk2").set("size", new String[]{"0.01", "0.01", "0.01"});
    model.geom("geom1").feature("blk2").set("pos", new String[]{"-0.005", "0", "0"});
    model.geom("geom1").feature("blk2").set("base", "center");
    model.geom("geom1").create("blk3", "Block");
    model.geom("geom1").feature("blk3").label("Symmetry Block 2");
    model.geom("geom1").feature("blk3").set("size", new String[]{"0.01", "0.01", "0.01"});
    model.geom("geom1").feature("blk3").set("pos", new String[]{"0", "0", "-0.005"});
    model.geom("geom1").feature("blk3").set("base", "center");
    model.geom("geom1").create("dif1", "Difference");
    model.geom("geom1").feature("dif1").label("Symmetry");
    model.geom("geom1").feature("dif1").set("repairtol", "1.0E-9");
    model.geom("geom1").feature("dif1").selection("input").set(new String[]{"cyl1", "cyl3", "cyl6", "cyl7", "del1"});
    model.geom("geom1").feature("dif1").selection("input2").set(new String[]{"blk2", "blk3"});
    model.geom("geom1").feature("fin").set("repairtol", "1.0E-9");
    model.geom("geom1").run();
    model.geom("geom1").run("del1");

    model.variable().create("var1");
    model.variable("var1").model("mod1");
    model.variable("var1").set("overpot", "ec.dV");
    model.variable("var1").selection().geom("geom1", 2);
    model.variable("var1").selection().set(new int[]{6});

    model.view("view2").tag("view5");
    model.view("view1").hideObjects().create("hide1");

    model.material().create("mat1", "Common", "mod1");
    model.material().create("mat2", "Common", "mod1");
    model.material().create("mat3", "Common", "mod1");
    model.material("mat1").selection().set(new int[]{2});
    model.material("mat2").selection().set(new int[]{1, 6});
    model.material("mat3").selection().set(new int[]{3, 4, 5, 6, 7});

    model.physics().create("ec", "ConductiveMedia", "geom1");
    model.physics("ec").create("term1", "Terminal", 2);
    model.physics("ec").feature("term1").selection().set(new int[]{9});
    model.physics("ec").create("ci1", "ContactImpedance", 2);
    model.physics("ec").feature("ci1").selection().set(new int[]{6});
    model.physics("ec").create("init2", "init", 3);
    model.physics("ec").feature("init2").selection().set(new int[]{2});
    model.physics("ec").create("gnd1", "Ground", 2);
    model.physics("ec").feature("gnd1").selection().set(new int[]{33});
    model.physics("ec").create("ein2", "ElectricInsulation", 2);
    model.physics("ec").feature("ein2").selection().set(new int[]{4, 14, 27});

    model.mesh("mesh1").create("ftet1", "FreeTet");
    model.mesh("mesh1").feature("ftet1").create("size1", "Size");
    model.mesh("mesh1").feature("ftet1").feature("size1").selection().geom("geom1", 2);
    model.mesh("mesh1").feature("ftet1").feature("size1").selection().set(new int[]{6});

    model.probe().create("var1", "GlobalVariable");
    model.probe("var1").model("mod1");

    model.view("view1").label("Side");
    model.view("view1").set("renderwireframe", true);
    model.view("view1").set("locked", true);
    model.view("view1").set("showgrid", false);
    model.view("view1").hideObjects("hide1").init(3);
    model.view("view5").label("View 5");
    model.view("view5").axis().set("xmin", "0");
    model.view("view5").axis().set("ymin", "0");

    model.material("mat1").label("Electrode");
    model.material("mat1").propertyGroup("def")
         .set("electricconductivity", new String[]{"94.35e5", "0", "0", "0", "94.35e5", "0", "0", "0", "94.35e5"});
    model.material("mat1").propertyGroup("def")
         .set("relpermittivity", new String[]{"1", "0", "0", "0", "1", "0", "0", "0", "1"});
    model.material("mat2").label("Electrolyte");
    model.material("mat2").propertyGroup("def")
         .set("electricconductivity", new String[]{"1.4", "0", "0", "0", "1.4", "0", "0", "0", "1.4"});
    model.material("mat2").propertyGroup("def")
         .set("relpermittivity", new String[]{"78", "0", "0", "0", "78", "0", "0", "0", "78"});
    model.material("mat3").label("Insulator");
    model.material("mat3").propertyGroup("def")
         .set("electricconductivity", new String[]{"1e-14", "0", "0", "0", "1e-14", "0", "0", "0", "1e-14"});
    model.material("mat3").propertyGroup("def")
         .set("relpermittivity", new String[]{"4.2", "0", "0", "0", "4.2", "0", "0", "0", "4.2"});

    model.physics("ec").prop("ShapeProperty").set("frame", "material");
    model.physics("ec").feature("cucn1").set("materialType", "solid");
    model.physics("ec").feature("cucn1").set("minput_strainreferencetemperature", "0");
    model.physics("ec").feature("term1").set("I0", "polarity*amps/4");
    model.physics("ec").feature("ci1").set("spec_type", "surfimp");
    model.physics("ec").feature("ci1").set("rhos", "((1/cpe(t))+(bv2(overpot)/overpot))^-1");
    model.physics("ec").feature("init2").set("V", "-0.001");

    model.mesh("mesh1").feature("size").set("hauto", 1);
    model.mesh("mesh1").feature("size").set("custom", "on");
    model.mesh("mesh1").feature("size").set("hnarrow", "0.5");
    model.mesh("mesh1").feature("size").set("hgrad", "1.2");
    model.mesh("mesh1").feature("size").set("hcurve", "0.6");
    model.mesh("mesh1").feature("size").set("hmin", "1E-9");
    model.mesh("mesh1").feature("ftet1").feature("size1").set("hauto", 1);
    model.mesh("mesh1").feature("ftet1").feature("size1").set("custom", "on");
    model.mesh("mesh1").feature("ftet1").feature("size1").set("hgradactive", true);
    model.mesh("mesh1").feature("ftet1").feature("size1").set("hminactive", true);
    model.mesh("mesh1").feature("ftet1").feature("size1").set("table", "cfd");
    model.mesh("mesh1").feature("ftet1").feature("size1").set("hmaxactive", true);
    model.mesh("mesh1").feature("ftet1").feature("size1").set("hmin", "1e-9");
    model.mesh("mesh1").feature("ftet1").feature("size1").set("hmax", "ELENG/60");
    model.mesh("mesh1").feature("ftet1").feature("size1").set("hcurveactive", false);
    model.mesh("mesh1").feature("ftet1").feature("size1").set("hnarrowactive", false);
    model.mesh("mesh1").feature("ftet1").feature("size1").set("hgrad", "1.3");
    model.mesh("mesh1").run();

    model.probe("var1").set("window", "window1");
    model.probe("var1").set("expr", "ec.V0_1");
    model.probe("var1").set("unit", "V");
    model.probe("var1").set("descr", "Terminal voltage");

    model.study().create("std2");
    model.study("std2").create("param", "Parametric");
    model.study("std2").create("time", "Transient");

    model.sol().create("sol1");
    model.sol("sol1").study("std2");
    model.sol("sol1").attach("std2");
    model.sol("sol1").create("st1", "StudyStep");
    model.sol("sol1").create("v1", "Variables");
    model.sol("sol1").create("t1", "Time");
    model.sol("sol1").feature("t1").create("fc1", "FullyCoupled");

    model.study("std2").feature("time").set("initstudyhide", "on");
    model.study("std2").feature("time").set("initsolhide", "on");
    model.study("std2").feature("time").set("solnumhide", "on");
    model.study("std2").feature("time").set("notstudyhide", "on");
    model.study("std2").feature("time").set("notsolhide", "on");
    model.study("std2").feature("time").set("notsolnumhide", "on");

    model.batch().create("p1", "Parametric");
    model.batch().create("b1", "Batch");
    model.batch("p1").create("so1", "Solutionseq");
    model.batch("p1").create("saDef", "Save");
    model.batch("b1").create("jo1", "Jobseq");
    model.batch("p1").study("std2");
    model.batch("b1").study("std2");

    model.study("std2").label("Study 1");
    model.study("std2").feature("param").set("pname", new String[]{"area", "polarity", "ChargeDensity", "recess"});
    model.study("std2").feature("param").set("keepsol", "last");
    model.study("std2").feature("param")
         .set("filename", "C:\\Users\\Andrian\\Desktop\\HalfBandRecess\\Symmetric\\HalfBandSymmetric.mph");
    model.study("std2").feature("param").set("probesel", "none");
    model.study("std2").feature("param")
         .set("plistarr", new String[]{"0.0785 [mm^2] 0.1571[mm^2] 0.2356[mm^2] 0.3142[mm^2]", "1 -1", "16[uC/cm^2]", "0.015[mm] 0.02[mm] 0.04[mm] 0.06[mm]"});
    model.study("std2").feature("param").set("sweeptype", "filled");
    model.study("std2").feature("param").set("punit", new String[]{"", "", "", ""});
    model.study("std2").feature("param").set("save", "on");
    model.study("std2").feature("time").set("tlist", "range(1e-10,0.5e-6,pw)");
    model.study("std2").feature("time").set("rtol", "1e-3");
    model.study("std2").feature("time").set("rtolactive", true);

    model.sol("sol1").attach("std2");
    model.sol("sol1").label("Solver 1");
    model.sol("sol1").feature("st1").label("Compile Equations: Time Dependent {time}");
    model.sol("sol1").feature("t1").set("tlist", "range(1e-10,0.5e-6,pw)");
    model.sol("sol1").feature("t1").set("fieldselection", "mod1_ec_term1_V0_ode");
    model.sol("sol1").feature("t1").set("bwinitstepfrac", "0.0010");
    model.sol("sol1").feature("t1").set("eventtol", "0.0001");
    model.sol("sol1").feature("t1").set("solfile", false);
    model.sol("sol1").feature("t1").set("initialstepbdf", "0.0010");
    model.sol("sol1").feature("t1").set("control", "user");
    model.sol("sol1").feature("t1").set("atolglobal", "0.000010");
    model.sol("sol1").feature("t1").set("rtol", "1e-3");
    model.sol("sol1").feature("t1").feature("dDef").active(true);
    model.sol("sol1").feature("t1").feature("dDef").set("pardmtsolve", true);
    model.sol("sol1").feature("t1").feature("dDef").set("pivotstrategy", true);
    model.sol("sol1").feature("t1").feature("dDef").set("errorchk", "off");
    model.sol("sol1").feature("t1").feature("dDef").set("linsolver", "pardiso");
    model.sol("sol1").feature("t1").feature("aDef").set("convinfo", "detailed");
    model.sol("sol1").feature("t1").feature("i1").set("linsolver", "cg");
    model.sol("sol1").feature("t1").feature("i1").feature("mg1").set("prefun", "amg");

    model.batch("p1").label("Parametric 1");
    model.batch("p1").set("probesel", "none");
    model.batch("p1").set("punit", new String[]{"", "", "", ""});
    model.batch("p1").set("err", true);
    model.batch("p1").set("sweeptype", "filled");
    model.batch("p1")
         .set("plistarr", new String[]{"0.0785 [mm^2] 0.1571[mm^2] 0.2356[mm^2] 0.3142[mm^2]", "1 -1", "16[uC/cm^2]", "0.015[mm] 0.02[mm] 0.04[mm] 0.06[mm]"});
    model.batch("p1").set("pname", new String[]{"area", "polarity", "ChargeDensity", "recess"});
    model.batch("p1").set("control", "param");
    model.batch("p1").feature("so1").label("Solver 1");
    model.batch("p1").feature("so1")
         .set("param", new String[]{"\"ELENG\",\"1e-4\",\"polarity\",\"1\"", "\"ELENG\",\"1e-4\",\"polarity\",\"-1\"", "\"ELENG\",\"2e-4\",\"polarity\",\"1\"", "\"ELENG\",\"2e-4\",\"polarity\",\"-1\"", "\"ELENG\",\"3e-4\",\"polarity\",\"1\"", "\"ELENG\",\"3e-4\",\"polarity\",\"-1\"", "\"ELENG\",\"4e-4\",\"polarity\",\"1\"", "\"ELENG\",\"4e-4\",\"polarity\",\"-1\""});
    model.batch("p1").feature("so1").set("seq", "sol1");
    model.batch("p1").attach("std2");
    model.batch("p1").run();
    model.batch("b1").feature("jo1").label("Job 1");
    model.batch("b1").run();

    model.result().dataset().remove("dset1");
    model.result().remove("pg1");

    return model;
  }

  public static void main(String[] args) {
    run();
  }

}
