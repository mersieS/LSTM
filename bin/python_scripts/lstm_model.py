import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense
from sklearn.preprocessing import MinMaxScaler
import json

def build_model(input_shape):
    model = Sequential()
    model.add(LSTM(units=50, return_sequences=False, input_shape=input_shape))
    model.add(Dense(units=1))
    model.compile(optimizer='adam', loss='mean_squared_error')
    return model

def create_dataset(data, time_step=1):
    x_data, y_data = [], []
    for i in range(len(data) - time_step - 1):
        x_data.append(data[i:(i + time_step), 0])
        y_data.append(data[i + time_step, 0])
    return np.array(x_data), np.array(y_data)

def train_and_save_model():
    seq_length = 100
    x = np.linspace(0, seq_length, seq_length)
    y = np.sin(x)

    data = np.array(y)
    data = data.reshape(-1, 1)

    scaler = MinMaxScaler(feature_range=(0, 1))
    data_scaled = scaler.fit_transform(data)

    time_step = 10
    X, y = create_dataset(data_scaled, time_step)
    X = X.reshape(X.shape[0], X.shape[1], 1)

    model = build_model((X.shape[1], 1))

    model.fit(X, y, epochs=10, batch_size=16, verbose=1)

    model.save('lstm_model.h5')
    print("Model başarıyla kaydedildi.")

if __name__ == "__main__":
    train_and_save_model()
