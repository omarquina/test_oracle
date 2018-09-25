require 'models'

class Idioma
  def self.get idioma
	  maestro_idiomas = MaestroLista.find_by(descripcionlista:"LISTA DE IDIOMAS")
	  lista_idiomas = maestro_idiomas.valores_lista
	  idioma_obj = lista_idiomas.find_by(codigovalor: idioma)
	  puts "IDIOMAS: #{lista_idiomas.inspect}"
	  puts "IDIOMA:  #{idioma.inspect}","----"
	  idioma_obj
  end
end

################################################################################
################################################################################

class Ubicacion
  def self.get pais
	ubicacion = OpenStruct.new #(:pais,:estado,:ciudad,:municipio,:direc)
	case pais
	  when /VENEZUELA/i
	    ubicacion.pais = Pais.find_by( descpais: pais )
	    #ubicacion.estado = Estado.find_by( descestado: "DISTRITO CAPITAL" )
	    #ubicacion.ciudad = Ciudad.find_by( descciudad: "CARACAS" )
	    #ubicacion.municipio = Municipio.find_by( descmunicipio: "BARUTA" )
	    ubicacion.direc = pais
	    ubicacion.tipoid = "J"
	    ubicacion.numid = "010123456"
	    ubicacion.dvid = "2"
	  when /COLOMBIA/i
	    ubicacion.pais = Pais.find_by( descpais: pais )
	    #ubicacion.estado = Estado.find_by( descestado: "" )
	    #ubicacion.ciudad = Ciudad.find_by( descciudad: "" )
	    #ubicacion.municipio = Municipio.find_by( descmunicipio: "" )
	    ubicacion.direc = pais
	    ubicacion.tipoid = "J"
	    ubicacion.numid = "010123456"
	    ubicacion.dvid = "2"
	  when /COSTA RICA/i
	    ubicacion.pais = Pais.find_by( descpais: pais )
	    #ubicacion.estado = Estado.find_by( descestado: "" )
	    #ubicacion.ciudad = Ciudad.find_by( descciudad: "" )
	    #ubicacion.municipio = Municipio.find_by( descmunicipio: "" )
	    ubicacion.direc = pais
	    ubicacion.tipoid = "J"
	    ubicacion.numid = "010123456"
	    ubicacion.dvid = "2"
	  when /HONDURAS/i
	    ubicacion.pais = Pais.find_by( descpais: pais )
	    #ubicacion.estado = Estado.find_by( descestado: "" )
	    #ubicacion.ciudad = Ciudad.find_by( descciudad: "" )
	    #ubicacion.municipio = Municipio.find_by( descmunicipio: "" )
	    ubicacion.direc = pais
	    ubicacion.tipoid = "J"
	    ubicacion.numid = "010123456"
	    ubicacion.dvid = "2"
	end
     ubicacion
  end
end

####################################################################################
####################################################################################

class UnidadDeMedida
  def self.get unidad=""
  # Unidad siempre es "CENTIMETRO"
  maestro_unidades_medida = MaestroLista.find_by(descripcionlista:"UNIDADES DE MEDIDA")
  unidad_medida_obj = maestro_unidades_medida.valores_lista.find_by(descripcionvalor: "CENTIMETROS")
  puts "Unidad Medida #{unidad_medida_obj.inspect}"
  unidad_medida_obj
  end
end

################################################################################
################################################################################
