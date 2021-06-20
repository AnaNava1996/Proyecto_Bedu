import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.tsa.statespace.sarimax import SARIMAX

from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.stattools import adfuller
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from matplotlib.pylab import rcParams
from pmdarima import auto_arima
from statsmodels.tsa.arima_model import ARIMA,ARIMAResults,ARMA,ARMAResults
import statsmodels.api as sm

columna = 'ecorregion_nivel_1'

fdf = pd.read_csv("../datasets/incendios_x_fecha_x_ecorregion.csv",parse_dates=True)[['fecha','num_incendios',columna]]
fdf.fecha = pd.to_datetime(fdf.fecha)
fdf.set_index(['fecha'],inplace=True)

fdf = fdf.loc[fdf[columna] == "Selvas Calido-Humedas"]

print(fdf.head(100))

#exit()
start_date = '2011-01-01'
end_date = '2016-12-31'
second_end_date = '2018-12-31'

mask = ((fdf.index >= start_date) & (fdf.index <= end_date))
second_mask = ((fdf.index >= start_date) & (fdf.index <= second_end_date))

#print(df.fecha.sort_values())
df = fdf.loc[mask].copy()
df2 = fdf.loc[second_mask].copy()

print(df)
#df['día'] = df.fecha.dt.day
df['semana'] = df.index.week
df['mes'] = df.index.month
df['año'] = df.index.year
df = df.groupby(['año','mes','semana'],as_index=True).mean().reset_index()
#df = df.groupby(['mes','año'],as_index=False).mean()
#df = df.groupby(['semana'],as_index=False).mean()
#df = df.groupby(['año'],as_index=False).mean()

#df2['día'] = df2.fecha.dt.day
df2['semana'] = df2.index.week
df2['mes'] = df2.index.month
df2['año'] = df2.index.year
df2 = df2.groupby(['año','mes','semana'],as_index=True).mean().reset_index()
#df = df.groupby(['mes','año'],as_index=False).mean()
#df = df.groupby(['semana'],as_index=False).mean()
#df = df.groupby(['año'],as_index=False).mean()

print(df.head(30))

#exit()
model = SARIMAX(df['num_incendios'],
                order=(1,0,1),#(0, 1, 1),#(p,d,q)
                seasonal_order=(2,1,7,52),#(1,0,0,52),#(2, 1, 7, 52),#(P,D,Q,s)
                enforce_stationarity=False,
                enforce_invertibility=False
                )

results = model.fit()

factor = 4

forecast = results.predict(start = len(df),
                          end=len(df)+(52*factor),
                          typ='levels').rename('data sarimax (1,0,1) forecast')


df2['num_incendios'].plot(figsize=(12,8),legend=True)
print(df2)


forecast.plot(legend=True)
print(df.shape)

plt.show()
