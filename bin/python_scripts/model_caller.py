import os
import sys
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import load_model
from sklearn.preprocessing import MinMaxScaler
import json

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
tf.get_logger().setLevel('ERROR')

def predict(input_data):
    model = load_model('lstm_model.h5')
    input_data = np.array(input_data).reshape(-1, 1)
    
    scaler = MinMaxScaler(feature_range=(0, 1))
    input_data_scaled = scaler.fit_transform(input_data)
    
    input_data_scaled = input_data_scaled.reshape(1, input_data_scaled.shape[0], 1)
    predicted_value = model.predict(input_data_scaled, verbose=0)
    
    predicted_value = scaler.inverse_transform(predicted_value)
    
    result = {"predicted_value": float(predicted_value[0][0])}
    print(json.dumps(result))

if __name__ == "__main__":
    input_json = sys.stdin.read()
    input_data = json.loads(input_json)
    
    predict(input_data)
