import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import math
import keras_metrics
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation
from keras.layers import LSTM
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error

#Función para crear el dataset y retornar un arreglo de numpy
def create_dataset(dataset, look_back=30):
    dataX, dataY = [], []
    for i in range(len(dataset)-look_back-1):
        a = dataset[i:(i+look_back), 0]
        dataX.append(a)
        dataY.append(dataset[i + look_back, 0])
    
    return np.array(dataX), np.array(dataY)

#Función que le añade las fechas restantes en ceros. USO: df = makeDate(df)
def makeDate(df):
    df.fecha = pd.to_datetime(df.fecha)
    df.set_index(['fecha'],inplace=True)
    idx = pd.date_range(min(df.index), max(df.index))
    df = df.reindex(idx,fill_value=0)
    return df

columna = 'ecorregion_nivel_1'

#Abrir csv y filtrar por tipo de región
df = pd.read_csv("incendios_x_fecha_x_ecorregion.csv",parse_dates=True)[['fecha','num_incendios',columna]]
df = df.loc[df[columna] == "Selvas Calido-Humedas"]
del df[columna]

df = makeDate(df)
print(df)

np.random.seed(100)

#Conversión de datos a float
dataset = df.values
dataset = dataset.astype('float32')

#Normalización de valores
scaler = MinMaxScaler(feature_range=(0, 1))
dataset = scaler.fit_transform(dataset)

#Partición de datos en entrenamiento y prueba
train_size = int(len(dataset) * 0.7) #Tamaño del entrenamiento
test_size = len(dataset) - train_size #Tamaño de la prueba
train, test = dataset[0:train_size,:], dataset[train_size:len(dataset),:]

#Convertir los datos de entrenamiento a arreglos de numpy
look_back = 31
trainX, trainY = create_dataset(train, look_back)
testX, testY = create_dataset(test, look_back)

#Reshape de los datos
print("\n\nhola")
print(trainX)
trainX = np.reshape(trainX, (trainX.shape[0], 1, trainX.shape[1]))
print("\n\nhola")
print(trainX)
testX = np.reshape(testX, (testX.shape[0], 1, testX.shape[1]))

#Crear el modelo LSTM
model = Sequential()
#Primera capa de 256 entradas
model.add(LSTM(256, input_shape=(1, look_back),return_sequences=True))
model.add(Dropout(0.9))
#Segunda capa de 256 entradas
model.add(LSTM(256, input_shape=(1, int(look_back/3))))
#Capa densa
model.add(Dense(1))
#Función de activación
model.add(Activation('selu'))
model.compile(loss='mean_squared_error', optimizer='rmsprop',metrics=['accuracy','mae',keras_metrics.recall()])

#Ajuste de los datos al modelo
model.fit(trainX, trainY, epochs=15, batch_size=16, verbose=2)

#Resultado de las predicciones sobre los datos de entrenamiento y los datos de prueba
trainPredict = model.predict(trainX)
'''
for i in range(100):
    testX=np.append(testX,model.predict(testX))
'''
testPredict = model.predict(testX)

#Inversión de predicciones para graficación
trainPredict = scaler.inverse_transform(trainPredict)
trainY = scaler.inverse_transform([trainY])
testPredict = scaler.inverse_transform(testPredict)
testY = scaler.inverse_transform([testY])

#Calcular el error de cuadrado medio
#trainScore = math.sqrt(mean_squared_error(trainY[0], trainPredict[:,0]))
#print('Train Score: %.4f RMSE' % (trainScore))
#testScore = math.sqrt(mean_squared_error(testY[0], testPredict[:,0]))
#print('Test Score: %.4f RMSE' % (testScore))

#Desplazamiento de datos para graficación
trainPredictPlot = np.empty_like(dataset)
trainPredictPlot[:, :] = np.nan
trainPredictPlot[look_back:len(trainPredict)+look_back, :] = trainPredict

#Desplazamiento de datos para graficación
testPredictPlot = np.empty_like(dataset)
testPredictPlot[:, :] = np.nan
testPredictPlot[len(trainPredict)+(look_back*2)+1:len(dataset)-1, :] = testPredict

#Plot
plt.figure(figsize=(15,8))
plt.plot(scaler.inverse_transform(dataset),label='Número de Incendios')
plt.plot(trainPredictPlot,label='Entrenamiento')
plt.plot(testPredictPlot,color='yellow',label='Prueba')
plt.xlabel('Días')
plt.ylabel('Incendios')
plt.legend()
plt.show()
