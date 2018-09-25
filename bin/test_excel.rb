require 'spreadsheet'
require 'rubyXL'
require 'pry'
require 'ostruct'

#Spreadsheet.client_encoding = 'UTF-8'
#book = Spreadsheet.open File.join("..","files","Venezuela","VZLA 20OT ESP ING POR.xlsx")
class BaremoFile
  attr_accessor :sheet,:metadata
  attr_reader :nombre , :idioma
  def initialize sheet
    self.sheet = sheet
    set_data
    puts "BaremoFile.intialize: #{@nombre}, Baremo: #{@baremo}, idioma: #{@idioma}"
  end

  def set_data
    #puts "SET_DATA: #{sheet.methods.sort.grep(/name/)}" 
    #puts "SHEET_NAME: #{self.sheet.sheet_name.split.inspect}"
    @nombre,@baremo,@idioma = self.sheet.sheet_name.split
  end

  def nombre
    #puts "BaremoFile.nombre: #{@nombre}"
    #@nombre ||= 
    @val ||= "#{@nombre} #{@baremo}"
  end

  def idioma
    case @idioma
      when "ESP"
        "ESPAÑOL"
      when "ING"
        "INGLES"
      when "POR"
        "PORTUGUEZ"
    end
  end

  def metadata
    @metadata ||= self.sheet
  end
 
  def rows &block
    self.sheet.sheet_data
  end
end

class Origen
# Origen -> direcotries -> 
#           [ [ directory , baremos: [{archivo, sheets(rows)),...] ] ]
  attr_accessor :dir, :info
  attr_reader :rows
  attr_accessor :directories
  def initialize(dir = "")
     self.dir = File.join(dir,"*")
     self.directories = []
     preparar
  end

  def procesar &block
    #3.times do |time|
    #puts "iteracion #{time}"
    directories.each do |directorio|
      directorio.baremos.each do |baremo|
        baremo.sheets.each do |sheet|
          puts "Procesando: #{sheet.nombre}, idioma: #{sheet.idioma}"
          yield directorio.nombre,sheet
          #yield directorio.directorio,baremo
        end 
      end 
    end
    #end # times
  end

  def valid_file?(file)
    valid = File.extname(file) =='.xlsx'
    puts "EXCEL FILE: #{valid}, --->  FILE: #{file}"
    valid
  end

  def preparar
    # Leer los directorios 
    Dir.glob(dir).each do |directory| 
      puts "DIR: #{directory}, --> DIR?: #{File.directory?(directory)}"
      if File.directory?(directory); 
        dir_obj = OpenStruct.new( directory: directory , baremos: [],nombre: File.basename(directory) )
        Dir.glob(File.join(directory,"*")).each do |file|
          if valid_file?(file)
            #Obtener los datos del archivo
            #puts metadata file
            dir_obj.baremos << process_file( file )
            puts "   BAREMOS COUNT:  #{dir_obj.baremos.size}"
            #dir_obj.baremos.flatten!
          end # if
         #valid = false
        end # glob
        directories << dir_obj
      end #if
      puts "PROCESÉ DIR: #{directory}"
    end # glob
  end

   def metadata file 
     workbook = RubyXL::Parser.parse(file)
     worksheets = workbook.worksheets 
     worksheets.each do |sheet|
       #puts sheet.sort.inspect
       puts "Sheet: #{sheet.sheet_name}, CEL: #{sheet.sheet_data.rows[0]}"
     end
   end

   def process_file file
     puts "--- PROCESANDO FILE: #{file}"
     o = OpenStruct.new
     o.archivo = RubyXL::Parser.parse(file)
     o.sheets =  o.archivo.worksheets.map{|sheet| BaremoFile.new sheet }
     o
   end
end

exit 0 if __FILE__ != $0

filename = File.join("..","files","Venezuela","VZLA 20OT ESP ING POR.xlsx")
workbook = RubyXL::Parser.parse(filename)
puts workbook.worksheets

worksheets = workbook.worksheets

#pry

puts worksheets[0].methods.sort.inspect
worksheets.each do |sheet|
  #puts sheet..sort.inspect
  puts "Sheet: #{sheet.sheet_name}, CEL:  #{sheet.sheet_data.rows[0]}"
end

origen = Origen.new File.join("..","files")
#origen.preparar
puts "Luego de preparar"
puts "    Directories: #{origen.directories.size}"
puts origen.directories[0].directory,origen.directories[0].baremos.count
origen.procesar do |pais,sheet|
  # Crear La oficina, y el proveedor
  # Crear el Baremo
  # Crear el grupo de componentes

  # Subcomponentes 
  total_rows_count = sheet.rows.size
  puts "Pais: #{pais}, rows: #{total_rows_count}"
  total_rows_count = 3
  1.upto(total_rows_count) do |row_index| 
    row = sheet.rows[row_index] # do |row|
    obj = OpenStruct.new(
            seccion: row[1].value,
            tipo_equipo: row[15].value,
            subcomponente: row[3].value,
            largo: row[8].value,
            ancho: row[9].value,
            componente_dano: row[5].value,
            componente_accion: row[7].value,
            componente_costo: row[14].value
    )
    puts "  OBJ: #{obj.inspect}"
    Subcomponente.procesar obj,baremo
  end
  #end
end # Procesar
pry

#else
#  puts "NO ES EL MISMO ARCHIVO"
#end
