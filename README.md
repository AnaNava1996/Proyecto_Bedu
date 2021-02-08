# Proyecto Fase 2.1 BEDU - Equipo 23

## Tabla de contenido
- [0. Panorama Inicial](#panorama_inicial)
- [1. Introducción](#problemática)
- [2. Objetivo](#objetivo)
- [3. Alcance](#alcance)
- [4. Justificación](#justificación)
- [5. Desarrollo](#desarrollo)
- [6. Resultados](#resultados)
- [7. Discusión](#discusión)
- [8. Conclusiones](#conclusiones)
- [9. Referencias](#referencias)

## Panorama Inicial
El presente repositorio almacena los recursos utilizados para la realización del proyecto en equipo correspondiente a la segunda fase del programa BEDU – Santander: Disruptive Innovation: Data Science.

El proyecto elegido lleva por título “Análisis de riesgo de incendio forestal (mejorar titulo)l” y fue desarrollado en el lenguaje de programación con enfoque en estadístico ‘R’.

Integrantes: (hay q poner nuestros nombres completos)

- Eréndira Celis Acosta

- Ana Paola Nava Vivas

- Hegar

- Gerardo Leonel García Pegueros


## 1. Introducción
Las zonas forestales son imprescindibles para la vida en el planeta. Además de ser parte fundamental en los ciclos de producción y distribución del agua, purifican el aire que respiramos al capturar bióxido de carbono y liberar oxígeno. También regulan la temperatura y la humedad, con lo que se equilibra el clima; proporcionan alimento, medicina y refugio a los seres vivos; y son fuente de materia prima en muchas actividades humanas.


### 1.1. Factores relevantes en la iniciación de un incendio forestal [1]

#### 1.1.1. Las fuentes de calor 
En el bosque no existe la combustión espontánea, siempre se requiere de una fuente de incandescencia externa mayor a 200°C para que ocurra un incendio. Estos puntos son los principales datos utilizados en este estudio.

#### 1.1.2. La temporada
Los incendios forestales pueden ocurrir en cualquier momento; sin embargo, en México se presentan dos temporadas de mayor incidencia: la primera, correspondiente a las zonas centro, norte, noreste, sur y sureste del país, que inicia en enero y concluye en junio. La segunda temporada inicia en mayo y termina en septiembre, y se registra en el noroeste del país. Ambas coinciden con la época de mayor estiaje (sequía) en el territorio nacional.

#### 1.1.3. Los asentamientos humanos 
Una zona forestal a la que los humanos ingresan con facilidad y constancia es más susceptible a la ocurrencia de incendios forestales.


### 1.2. Sistemas públicos de información relevantes
Para detectar los incendios se cuenta con varios recursos, almacenados en las bases de datos utilizados; este proyecto se centra en tres de ellos:

#### 1.2.1. Puntos de calor de NASA-FIRMS
La Sistema de Información de Incendios para Manejo de Recursos (Fire Information for Resource Management System: FIRMS) de la NASA utiliza observaciones satelitales de los sensores MODIS y VIIRS para detectar incendios activos y anomalías térmicas; y proporcionar esta información en tiempo casi real a tomadores de decisiones por medio de alertas de correo electrónico, datos aptos para análisis, mapas online y servicios web.

#### 1.2.2. Datos geoespaciales CONABIO
La Comisión Nacional para el Conocimiento y Uso de la Biodiversidad (CONABIO) mediante su geoportal proporciona diversos sets de datos geoespaciales temáticos relacionados con la biósfera en nuestro país. Asimismo permite descargar dichos sets de datos en diversos formatos.[5]

### 1.3. Principales factores iniciadores de un incendio forestal

#### 1.3.1. Factores ambientales
La mayoría de los incendios forestales son ocasionados por la actividad humana, pero también es interesante estudiar cuáles factores ambientales hay que tener en cuenta para la prevención de incendios ya que la humedad, el tipo de vegetación, influyen y son importantes para que se expresen los incendios.

#### 1.3.2. Factor humano
Si bien hay ciertos factores que no se pueden predecir, como la oportunidad de que una persona entre a un bosque haga un baby shower y desencadene un incendio en California, [2] existen otros eventos de los cuales sí se puede hacer una correlación con los incendios forestales, como lo son la tala y la quema de bosques. 

Se cree que entre el 95% y el 99% de los incendios forestales son ocasionados por actividades derivadas de los humanos [1]. Entre las cuales destacan las siguientes actividades: [3]

- Actividades ilícitas (27%)
- Agrícolas (27%) 
- Desconocidas (13%)
- Pecuarias (9%)
- Fogatas (9%)


## 2. Objetivo
Se pretende encontrar la relación entre factores iniciadores de un incendio, ponderar cada factor según la relación encontrada, y encontrar la probabilidad de que suceda un incendio en una temporada y ubicación específica.


## 3. Alcance
Este proyecto estudia los puntos de calor y la probabilidad de causar un incendio en México y en diferenciadas regiones del país haciendo uso de datos recabados entre los años 2002 y 2018 (?).


## 4. Justificación
Los bosques son esenciales para la vida en nuestro planeta, purifican el aire, mantienen el ciclo del agua, regulan la humedad y la temperatura, y son el hogar de numerosas especies animales. Son estas razones las que hacen necesario el contar con un control estadístico que nos permita conocer las principales causas y prevenir los posibles incendios.


## 5. Desarrollo

### 5.1. Recolección de los datos
La principal fuente utilizada fueron los datos históricos de puntos de calor de NASA-FIRMS para México del sensor MODIS de 2000 a 2019. 
Dichos datos se recolectaron por medio del script read_files.R, contenido en este mismo repositorio. 

Asimismo, se utilizaron los datos vectoriales (polígonos) de dos mapas temáticos de CONABIO: 
[1) eco-regiones terrestres] (http://www.conabio.gob.mx/informacion/metadata/gis/ecort08gw.xml?_xsl=/db/metadata/xsl/fgdc_html.xsl&_indent=no)
[2) usos de suelo] (http://www.conabio.gob.mx/informacion/metadata/gis/usv731mgw.xml?_xsl=/db/metadata/xsl/fgdc_html.xsl&_indent=no)


### 5.x Preparación de los datos
En el mismo script read_files.R se filtraron los puntos de calor cuyo campo “Confidence” superara el percentil 90. Esto para tomar en cuenta dentro de nuestro estudio, solo aquellos puntos de calor con mayor probabilidad de estar asociados a un incendio. Asimismo se realizó una operación de cadena de caracteres en la columna de la hora de adquisición acq_date, para que el formato de la cadena fuera fácilmente convertible a formato time en pasos subsecuentes. 

Los datos obtenidos como output tabular CSV de read_files.R se procesaron posteriormente en el software libre QGIS para asociar los puntos de calor a un contexto geo-ecológico. Los pasos a seguir en este proceso fueron los siguientes:

Se generó un nuevo proyecto QGIS con las capas vectoriales de los dos mapas temáticos de CONABIO (archivos SHP) y se importó a este proyecto QGIS el archivo CSV generado en read_files.R . 

<img src="https://github.com/AnaNava1996/Proyecto_Bedu/blob/main/figuras/qgis_01.png" width="503" height="345">
<img src="https://github.com/AnaNava1996/Proyecto_Bedu/blob/main/figuras/qgis_02.PNG" width="355" height="315">
<img src="https://github.com/AnaNava1996/Proyecto_Bedu/blob/main/figuras/qgis_03.PNG" width="371" height="345">

Se utilizó la herramienta de SAGA de agregar atributos de polígonos a puntos, con esto los puntos de calor ubicados dentro del polígono de una eco-región o tipo de suelo dado adquieren los atributos (columnas) de dichos polígonos. Esto tiene el efecto de un join, así los puntos de calor adquieren la información del tipo de suelo y eco-región en donde ocurrieron. Como se ve en las capturas de pantalla, este proceso se realizó dos veces ya que se requirió agregar los atributos (columnas) de dos datasets de polígonos: tipos de suelo y eco-regiones.

<img src="https://github.com/AnaNava1996/Proyecto_Bedu/blob/main/figuras/qgis_04.PNG" width="220" height="345">
<img src="https://github.com/AnaNava1996/Proyecto_Bedu/blob/main/figuras/qgis_05.PNG" width="344" height="260">
<img src="https://github.com/AnaNava1996/Proyecto_Bedu/blob/main/figuras/qgis_06.PNG" width="297" height="346">
<img src="https://github.com/AnaNava1996/Proyecto_Bedu/blob/main/figuras/qgis_07.PNG" width="344" height="260">

Los datos obtenidos del proceso anterior se exportaron a un CSV incendios_con_ecoregiones_y_tiposdesuelo.csv en la carpeta Data_Sets de este repositorio. Este archivo es el que se utilizó para los análisis posteriores. 

<img src="https://github.com/AnaNava1996/Proyecto_Bedu/blob/main/figuras/qgis_08.png" width="416" height="329">
<img src="https://github.com/AnaNava1996/Proyecto_Bedu/blob/main/figuras/qgis_09.PNG" width="295" height="344">

### 5.x Aproximaciones analíticas
Aquí se describen las aproximaciones analíticas con las que el equipo se enfrentó al problema. Todos estos análisis pueden ser consultados en la sección de resultados.


#### 5.x Aproximación Descriptiva
Se decidió utilizar esta aproximación desde un principio para conocer el contexto de la situación y nuestra realidad actual. Para esto se encontraron diversas relaciones entre los incendios forestales, puntos de calor y tipo de vegetación. 


#### 5.x Aproximación diagnóstica
Esta aproximación se empleó con el fin de entender la causa de los incendios forestales en México. Estudios estadísticos fueron representados en un histograma dinámico que muestra las frecuencias de incendios por zonas del país, un diagrama de dispersión que…(?) y series de tiempo que indican las tendencias entre los años 2002 y 2018 por regiones del país.


#### 5.x Aproximación predictiva

Se hará uso de este tipo de predicción para decidir si las tendencias en incendios forestales continuarán. (?)

## 6. Resultados


## 7. Discusión
Según la Secretaría de Medio Ambiente y Recursos Naturales (Semarnat) y la Comisión Nacional Forestal (Conafor), aunque los incendios forestales ocurren durante todo el año, la temporada fuerte para la región Centro, Norte, Noreste, Sur y Sureste del país se presenta principalmente del mes de enero a junio. En nuestro análisis podemos comprobar que…(?) 

En tanto que, para la región Noroeste, la temporada crítica es de mayo a septiembre, coincidiendo (o no) (?) con nuestros estudios que…
También la Semarnat y la Conafor indican que la mayor vegetación afectada es en su mayoría pastos y matorrales, en nuestro estudio se encontró que… (?) 


## 8. Conclusiones 
Los datos que poseen mayor relación con los positivos de incendios fueron:

Las gráficas de tiempo indican que...

Disclaimer. Se invita a la población a considerar las advertencias expedidas por nuestras autoridades reiterando el llamado a no hacer uso del fuego en las zonas forestales. Los incendios en áreas urbanas son atendidos por Protección Civil, y se deben reportar al número gratuito 800-INCENDIO (46236346) o al 911.


## 9. Referencias

[[1] Comisión Nacional Forestal (2010). Guía práctica para comunicadores. Incendios forestales.]( http://www.conafor.gob.mx:8080/documentos/docs/10/236Gu%C3%ADa%20pr%C3%A1ctica%20para%20comunicadores%20-%20Incendios%20Forestales.pdf)

[[2]  Morales, C., y Waller, A. (8 de septiembre de 2020). Una fiesta para dar conocer el sexo de un bebé termina en incendio. Ya había pasado antes. New York Times.](https://www.nytimes.com/es/2020/09/08/espanol/estados-unidos/incendio-california-fiesta.html)

[[3]  Comisión Nacional Forestal (2020) Situacion de incendios forestales al 23 de julio]( https://www.gob.mx/conafor/prensa/situacion-de-incendios-forestales-en-mexico-al-23-de-julio#:~:text=La%20Secretar%C3%ADa%20de%20Medio%20Ambiente,su%20mayor%C3%ADa%20pastos%20y%20matorrales.)

[[4] NASA (s.f.) Fire Information for Resource Management System](https://firms.modaps.eosdis.nasa.gov/)

[[5] CONABIO (s.f.) Geoportal. ](http://www.conabio.gob.mx/informacion/gis/)

[Link al data set de incendios forestales de la NASA](https://firms.modaps.eosdis.nasa.gov/country/)
