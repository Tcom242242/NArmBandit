
import yaml
# グラフ化に必要なものの準備
import matplotlib
import matplotlib.pyplot as plt

# データの扱いに必要なライブラリ
import pandas as pd
import numpy as np
import datetime as dt
import pdb
import numpy as np

plt.style.use('ggplot') 
font = {'family' : 'meiryo'}
matplotlib.rc('font',  **font)

f = open("result.yml")
data = yaml.load(f)
data = np.array(data)

# eg = pd.Series(data[0])      
# sm = pd.Series(data[1])      
# df = pd.DataFrame(data, index=(0,2000), columns=['B', 'C']).cumsum()
# df = pd.DataFrame({"e_greedy":eg, "softmax":sm}, columns=['e_greedy', 'softmax'])
# df = pd.DataFrame([ts, ts2], columns=['B', 'C']).cumsum()
# df.plot(x='cycle', y='average reward')
# df.plot()

plt.plot(data[0], label = "e_greedy epsilon=0.1")
plt.plot(data[1], label = "softmax T=0.1")
plt.legend(loc="lower right")
plt.xlabel("cycle")
plt.ylabel("average reward")
plt.show()
plt.savefig("result.png")


