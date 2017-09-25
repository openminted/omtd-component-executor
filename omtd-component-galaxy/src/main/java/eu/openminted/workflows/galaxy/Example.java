package eu.openminted.workflows.galaxy;

public class Example {

	public static void main(String args[]) {
		GalaxyWrapperGeneratorMain main = new GalaxyWrapperGeneratorMain();
		main.main(exampleArgsDKPRO());
		main.main(exampleArgsGATE());

	}

	public static String[] exampleArgsDKPRO() {
		String root = "/home/ilsp/Desktop/OMTDTemp/";
		String omtdShareDescFolder = "omtds-dkpro-core-1.9.0-SNAPSHOT";
		String galaxyWrappersFolderInGalaxy = "omtdDKPro";
		String dockerImage = "snf-765691.vm.okeanos.grnet.gr/openminted/omtd-workflows-executor";

		String[] myArgs = { root, omtdShareDescFolder, galaxyWrappersFolderInGalaxy, dockerImage};
		return myArgs;
	}

	public static String[] exampleArgsGATE() {
		String root = "/home/ilsp/Desktop/OMTDTemp/";
		String omtdShareDescFolder = "annie-descriptors";
		String galaxyWrappersFolderInGalaxy = "omtdGATE";
		String dockerImage = "snf-765691.vm.okeanos.grnet.gr/openminted/omtd-workflows-executor";
		
		String[] myArgs = { root, omtdShareDescFolder, galaxyWrappersFolderInGalaxy, dockerImage};

		return myArgs;
	}

}