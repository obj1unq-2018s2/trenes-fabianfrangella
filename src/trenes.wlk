class Deposito {

	var formacionesArmadas // es un conjunto
	var locomotorasSueltas // es un conjunto

	method vagonesMasPesados() = formacionesArmadas.map{ formacion => formacion.vagonMasPesado() }.asSet()

	method necesitaExperimentado() = formacionesArmadas.any{ formacion => formacion.esCompleja() }

	method agregarLocomotoraParaMover(formacion) {
		if (!formacion.sePuedeMover() && self.hayLocomotoraUtilPara(formacion)) {
			formacion.agregarLocomotora(self.getLocomotoraUtilPara(formacion))	
			}
	}

	method hayLocomotoraUtilPara(formacion) = 
		locomotorasSueltas.any{ locomotora => locomotora.arrastreUtil() >= formacion.kilosDeEmpujeFaltantes() }
	
	method esLocomotoraUtilPara(locomotora,formacion) =
		locomotora.arrastreUtil() >= formacion.kilosDeEmpujeFaltantes()
		
	method getLocomotoraUtilPara(formacion) =
		locomotorasSueltas.find{locomotora=>self.esLocomotoraUtilPara(locomotora,formacion)}
	
}

class Vagon {
	
	method pesoMaximo()

	method esLiviano() = self.pesoMaximo() < 2500
}

class VagonDePasajeros inherits Vagon {

	var largo
	var ancho
	var banios 
	
	method pasajerosQuePuedeTransportar() = if (ancho <= 2.5) largo * 8 else largo * 10

	override method pesoMaximo() = self.pasajerosQuePuedeTransportar() * 80

	method banios() = banios
	
}

class VagonDeCarga inherits Vagon {

	var cargaMaxima

	override method pesoMaximo() = cargaMaxima + 160
	
	method pasajerosQuePuedeTransportar() = 0
	
	method banios() = 0
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
	
	method agregarVagon(vagon){
		vagones.add(vagon)
	}

	method vagonesLivianos() = vagones.count{ vagon => vagon.esLiviano() }

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
	
	method cantidadDePasajeros() = vagones.sum{ vagon => vagon.pasajerosQuePuedeTransportar() }

	method cantidadDeBanios() = vagones.sum{ vagon => vagon.banios() }
	
	method limiteDeVelocidad()

	method velocidadMaxima() {
		if (locomotoras.min{ locomotora => locomotora.velocidadMaxima() }.velocidadMaxima() > self.limiteDeVelocidad()) {
			return self.limiteDeVelocidad()
		} else {
			return locomotoras.min{ locomotora => locomotora.velocidadMaxima() }.velocidadMaxima()
		}
	}
	
	method estaBienArmada() = self.sePuedeMover()	
	
}

class FormacionDeCortaDistancia inherits Formacion  {
	
	override method limiteDeVelocidad() = 60

	override method estaBienArmada() = super() && !self.esCompleja()
}

class FormacionDeLargaDistancia inherits Formacion {

	var ciudadesQueUne // numero

	override method limiteDeVelocidad() = if (ciudadesQueUne == 2) 200 else 150 

	method tieneBaniosSuficientes() = self.cantidadDeBanios() >= self.cantidadDePasajeros() / 50

	override method estaBienArmada() = super() && self.tieneBaniosSuficientes()
}

class FormacionDeAltaVelocidad inherits FormacionDeLargaDistancia {
	
	method todosLosVagonesSonLivianos() = vagones.all{ vagon => vagon.esLiviano() }
	
	override method limiteDeVelocidad() = 400

	override method estaBienArmada() = super() && self.velocidadMaxima() > 250 && self.todosLosVagonesSonLivianos()
}

