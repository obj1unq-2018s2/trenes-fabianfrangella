class Deposito {

	var formacionesArmadas
	var locomotorasSueltas

	method vagonesMasPesados() = formacionesArmadas.filter{ formacion => formacion.vagonMasPesado() }.asSet()

	method necesitaExperimentado() = formacionesArmadas.any{ formacion => formacion.esCompleja() }

	method agregarLocomotoraParaMover(formacion) {
		if (!formacion.sePuedeMover() && self.hayLocomotoraUtilPara(formacion)) {
			formacion.agregarLocomotora(locomotorasSueltas.any{locomotora=>locomotora.esLocomotoraUtilPara(locomotora,formacion)})
		}
	}

	method hayLocomotoraUtilPara(formacion) = 
		locomotorasSueltas.any{ locomotora => locomotora.arrastreUtil() >= formacion.kilosDeEmpujeFaltantes() }
	
	method esLocomotoraUtilPara(locomotora,formacion) =
		locomotora.arrastreUtil() >= formacion.kilosDeEmpujeFaltantes()
}

class VagonDePasajeros {

	var largo
	var ancho

	method pasajerosQuePuedeTransportar() = if (ancho <= 2.5) largo * 8 else largo * 10

	method pesoMaximo() = self.pasajerosQuePuedeTransportar() * 80

	method esLiviano() = self.pesoMaximo() < 2500

}

class VagonDeCarga {

	var cargaMaxima

	method pesoMaximo() = cargaMaxima + 160

	method esLiviano() = self.pesoMaximo() < 2500

}

class Locomotora {

	var peso
	var pesoMaxArrastre
	var property velocidadMaxima

	method arrastreUtil() = pesoMaxArrastre - peso

	method peso() = peso

	method pesoMaxArrastre() = pesoMaxArrastre

}

class Formacion {

	var vagones = #{}
	var locomotoras = #{}

	method agregarLocomotora(locomotora) {
		locomotoras.add(locomotora)
	}

	method vagonesLivianos() = vagones.count{ vagon => vagon.esLiviano() }

	method velocidadMaxima() = locomotoras.min{ locomotora => locomotora.velocidadMaxima() }

	method pesoTotalVagones() = vagones.sum{ vagon => vagon.pesoMaximo() }

	method pesoTotalLocomotoras() = locomotoras.sum{ locomotora => locomotora.peso() }

	method arrastreUtilTotal() = locomotoras.sum{ locomotora => locomotora.arrastreUtil() }

	method esEficiente() = locomotoras.all{ locomotora => locomotora.arrastreUtil() >= locomotora.peso() * 5 }

	method sePuedeMover() = self.arrastreUtilTotal() >= self.pesoTotalVagones()

	method kilosDeEmpujeFaltantes() = if (self.sePuedeMover()) 0 else self.pesoTotalVagones() - self.arrastreUtilTotal()

	method vagonMasPesado() = vagones.max{ vagon => vagon.pesoMaximo() }

	method cantUnidades() = vagones.size() + locomotoras.size()

	method pesoTotal() = self.pesoTotalVagones() + self.pesoTotalLocomotoras()

	method esCompleja() = self.cantUnidades() > 20 || self.pesoTotal() > 10000

}

