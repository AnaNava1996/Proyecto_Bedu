# Proyecto_Bedu

## Tabla de contenidos
- [Introducción](#problemática)
- [Objetivo](#objetivo)
- [Alcance](#alcance)
- [Justificación](#justificacion)
- [Desarrollo](#desarrollo)
- [Resultados](#resultados)
- [Discusión](#discusion)
- [Conclusiones](#conclusiones)
- [Referencias](#referencias)

## Panorama Inicial
El presente repositorio almacena los recursos utilizados para la realización del proyecto en equipo correspondiente a la segunda fase del programa BEDU – Santander: Disruptive Innovation: Data Science.
El proyecto elegido lleva por título “Análisis de riesgo de incendio forestal (mejorar titulo)l” y fue desarrollado en el lenguaje de programación con enfoque en estadístico ‘R’.

## Introducción
Las zonas forestales son imprescindibles para la vida en el planeta. Además de ser parte fundamental en los ciclos de producción y distribución del agua, purifican el aire que respiramos al capturar bióxido de carbono y liberar oxígeno. También regulan la temperatura y la humedad, con lo que se equilibra el clima; proporcionan alimento, medicina y refugio a los seres vivos; y son fuente de materia prima en muchas actividades humanas.


###Condiciones que influyen en la iniciación de un incendio forestal

#### Las fuentes o puntos de calor. 
En el bosque no existe la combustión espontánea, siempre se requiere de una fuente de incandescencia externa mayor a 200°C para que ocurra un incendio. Estos puntos son los principales datos utilizados en este estudio.

#### La temporada
Los incendios forestales pueden ocurrir en cualquier momento; sin embargo, en México se presentan dos temporadas de mayor incidencia: la primera, correspondiente a las zonas centro, norte, noreste, sur y sureste del país, que inicia en enero y concluye en junio. La segunda temporada inicia en mayo y termina en septiembre, y se registra en el noroeste del país. Ambas coinciden con la época de mayor estiaje (sequía) en el territorio nacional.

#### Los asentamientos humanos 
Una zona forestal a la que los humanos ingresan con facilidad y constancia es más susceptible a la ocurrencia de incendios forestales.


### Otros elementos para tener en cuenta
Para detectar los incendios se cuenta con varios recursos, almacenados en las bases de datos utilizados; este proyecto se centra en tres de ellos:

#### Información satelital
La Comisión Nacional para el Conocimiento y Uso de la Biodiversidad (conabio) y del Servicio Meteorológico Nacional de la Comisión Nacional del Agua (cna), que reciben en dos ocasiones durante el día (conabio) o cada 20 minutos (cna) imágenes del territorio nacional que muestran los focos de calor, señales de un posible incendio forestal. 

#### Un programa para la Detección de Puntos de Calor 
La conabio y el Servicio Meteorológico Nacional desarrollan este programa mediante técnicas de percepción remota en tiempo real. La información de la conabio se encuentra estructurada por años y adicionalmente a los puntos de calor, se puede obtener información tabular, georreferenciada (mapas dinámicos) y cuadros de noticias. 

#### Un Sistema de Información Geográfica diseñado por el Servicio Forestal de Canadá 
Este produce mapas de riesgo meteorológico, y el análisis de técnicos especializados en el Centro Nacional de Control de Incendios Forestales, para emitir un reporte diario y reportes especiales cuando las condiciones sobre los incendios forestales se consideran extremas o peligrosas


### Principales factores iniciadores de un incendio forestal

#### Factores ambientales
La mayoría de los incendios forestales son ocasionados por la actividad humana, pero también es interesante estudiar cuáles factores ambientales hay que tener en cuenta para la prevención de incendios ya que la humedad, el tipo de vegetación, influyen y son importantes para que se expresen los incendios.

#### Factor humano
Si bien hay ciertos factores que no se pueden predecir, como la oportunidad de que una persona entre a un bosque haga un baby shower y desencadene un incendio en California, [2] existen otros eventos de los cuales sí se puede hacer una correlación con los incendios forestales, como lo son la tala y la quema de bosques. 
Se cree que entre el 95% y el 99% de los incendios forestales son ocasionados por actividades derivadas de los humanos [1]. Entre las cuales destacan las siguientes actividades: [3]
Actividades ilícitas (27%)
Agrícolas (27%) 
Desconocidas (13%)
Pecuarias (9%)
Fogatas (9%)


## Objetivo
Se pretende encontrar la relación entre factores iniciadores de un incendio, ponderar cada factor según la relación encontrada, y encontrar la probabilidad de que suceda un incendio en una temporada y ubicación específica.


## Alcance
Este proyecto estudia los puntos de calor y la probabilidad de causar un incendio en México y en diferenciadas regiones del país haciendo uso de datos recabados entre los años 2002 y 2018 (?).


## Justificación
Los bosques son esenciales para la vida en nuestro planeta, purifican el aire, mantienen el ciclo del agua, regulan la humedad y la temperatura, y son el hogar de numerosas especies animales. [2] Son estas razones las que hacen necesario el contar con un control estadístico que nos permita conocer las principales causas y prevenir los posibles incendios.


## Desarrollo

### Recolección de los datos
La principal fuente de datos utilizada fue una recolección de información de incendios que datan del 2000 al 2019, recolectadas por la NASA vía satelital.
[Link al data set de incendios forestales de la NASA](https://firms.modaps.eosdis.nasa.gov/country/)
[Link al data set de la CONABIO](http://www.conabio.gob.mx/informacion/metadata/gis/ecort08gw.xml?_xsl=/db/metadata/xsl/fgdc_html.xsl&_indent=no)
http://www.conabio.gob.mx/informacion/metadata/gis/usv731mgw.xml?_xsl=/db/metadata/xsl/fgdc_html.xsl&_indent=no

### Preparación de los datos
Se filtraron los puntos de calor cuyo campo de confianza “Confidence” superara el percentil 90. Esto para tomar en cuenta dentro de nuestro estudio, solo aquellos puntos de calor con mayor probabilidad de causar un incendio

### Aproximaciones analíticas
Aquí se describen las aproximaciones analíticas con las que el equipo se enfrentó al problema. Todos estos análisis pueden ser consultados en la sección de resultados.

#### Aproximación Descriptiva
Se decidió utilizar esta aproximación desde un principio para conocer el contexto de la situación y nuestra realidad actual. Para esto se encontraron diversas relaciones entre los incendios forestales, puntos de calor y tipo de vegetación. 

#### Aproximación diagnóstica
Esta aproximación se empleó con el fin de entender la causa de los incendios forestales en México. Estudios estadísticos fueron representados en un histograma dinámico que muestra las frecuencias de incendios por zonas del país, un diagrama de dispersión que…(?) y series de tiempo que indican las tendencias entre los años 2002 y 2018 por regiones del país.
#### Aproximación predictiva

Se hará uso de este tipo de predicción para decidir si las tendencias en incendios forestales continuarán. (?)

## Resultados


## Discusión
Según la Secretaría de Medio Ambiente y Recursos Naturales (Semarnat) y la Comisión Nacional Forestal (Conafor), aunque los incendios forestales ocurren durante todo el año, la temporada fuerte para la región Centro, Norte, Noreste, Sur y Sureste del país se presenta principalmente del mes de enero a junio. En nuestro análisis podemos comprobar que…(?) En tanto que, para la región Noroeste, la temporada crítica es de mayo a septiembre, coincidiendo (o no) (?) con nuestros estudios que…
También la Semarnat y la Conafor indican que la mayor vegetación afectada es en su mayoría pastos y matorrales, en nuestro estudio se encontró que… (?) 


## Conclusiónes 
Los datos que poseen mayor relación con los positivos de incendios fueron:
Las gráficas de tiempo indican que...
Disclaimer. Se invita a la población a considerar las advertencias expedidas por nuestras autoridades reiterando el llamado a no hacer uso del fuego en las zonas forestales. Los incendios en áreas urbanas son atendidos por Protección Civil, y se deben reportar al número gratuito 800-INCENDIO (46236346) o al 911.


## Referencias

[[1] Comisión Nacional Forestal (2010). Guía práctica para comunicadores. Incendios forestales.]( http://www.conafor.gob.mx:8080/documentos/docs/10/236Gu%C3%ADa%20pr%C3%A1ctica%20para%20comunicadores%20-%20Incendios%20Forestales.pdf)

[[2]  Morales, C., y Waller, A. (8 de septiembre de 2020). Una fiesta para dar conocer el sexo de un bebé termina en incendio. Ya había pasado antes. New York Times.](https://www.nytimes.com/es/2020/09/08/espanol/estados-unidos/incendio-california-fiesta.html)

[[3]  SITUACIÓN DE INCENDIOS FORESTALES EN MÉXICO AL 23 DE JULIO. Comisión Nacional Forestal ]( https://www.gob.mx/conafor/prensa/situacion-de-incendios-forestales-en-mexico-al-23-de-julio#:~:text=La%20Secretar%C3%ADa%20de%20Medio%20Ambiente,su%20mayor%C3%ADa%20pastos%20y%20matorrales.)






