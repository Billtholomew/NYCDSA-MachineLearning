import numpy as np
import pandas as pd
import re
features=pd.read_csv('C:/Users/Marc Fridson/Desktop/feature_breakdown.csv')
features=features.drop(features.columns[[0]], axis=1)
laundry_att=[]
elevator_att=[]
hardwood_att=[]
pets_att=[]
doorman_att=[]
dishwasher_att=[]
gym_att=[]
fee_att=[]
pre_war_att=[]
common_space_att=[]
subway_att=[]
pool_att=[]
balcony_att=[]
a_c_att=[]
playroom_att=[]
parking_att=[]
luxury_att=[]
fireplace_att=[]
laundry=['laundry','washer','dryer']
elevator=['elevator']
hardwood=['hardwood']
pets=['pets','cats','dogs']
doorman=['doorman','concierge','valet']
dishwasher=['dish']
gym=['gym','fitness']
fee=['fee']
pre_war=['war']
common_space=['roof','outdoor','garden','common','lounge']
subway=['subway']
pool=['pool']
balcony=['balcony','terrace','patio','private outdoor space']
a_c=['ac','a/c','a-c']
playroom=['playroom']
parking=['garage','parking']
luxury=['new construction','stainless steel','granite','marble']
fireplace=['fireplace']

features.columns=['feat_list']
features = features.replace(np.nan, '', regex=True)

for i, line in enumerate(features['feat_list']):
    laundry_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in laundry:
        if (re.search(item,line)):
            laundry_att[i] = 1

for i, line in enumerate(features['feat_list']):
    elevator_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in elevator:
        if (re.search(item,line)):
            elevator_att[i] = 1

for i, line in enumerate(features['feat_list']):
    hardwood_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in hardwood:
        if (re.search(item,line)):
            hardwood_att[i] = 1

for i, line in enumerate(features['feat_list']):
    pets_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in pets:
        if (re.search(item,line)):
            pets_att[i] = 1

for i, line in enumerate(features['feat_list']):
    doorman_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in doorman:
        if (re.search(item,line)):
            doorman_att[i] = 1

for i, line in enumerate(features['feat_list']):
    dishwasher_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in dishwasher:
        if (re.search(item,line)):
            dishwasher_att[i] = 1

for i, line in enumerate(features['feat_list']):
    gym_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in gym:
        if (re.search(item,line)):
            gym_att[i] = 1

for i, line in enumerate(features['feat_list']):
    fee_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in fee:
        if (re.search(item,line)):
            fee_att[i] = 1

for i, line in enumerate(features['feat_list']):
    pre_war_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in pre_war:
        if (re.search(item,line)):
            pre_war_att[i] = 1

for i, line in enumerate(features['feat_list']):
    common_space_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in common_space:
        if (re.search(item,line)):
            common_space_att[i] = 1

for i, line in enumerate(features['feat_list']):
    subway_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in subway:
        if (re.search(item,line)):
            subway_att[i] = 1

for i, line in enumerate(features['feat_list']):
    pool_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in pool:
        if (re.search(item,line)):
            pool_att[i] = 1

for i, line in enumerate(features['feat_list']):
    balcony_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in balcony:
        if (re.search(item,line)):
            balcony_att[i] = 1

for i, line in enumerate(features['feat_list']):
    a_c_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in a_c:
        if (re.search(item,line)):
            a_c_att[i] = 1

for i, line in enumerate(features['feat_list']):
    playroom_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in playroom:
        if (re.search(item,line)):
            playroom_att[i] = 1

for i, line in enumerate(features['feat_list']):
    parking_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in parking:
        if (re.search(item,line)):
            parking_att[i] = 1

for i, line in enumerate(features['feat_list']):
    luxury_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in luxury:
        if (re.search(item,line)):
            luxury_att[i] = 1

for i, line in enumerate(features['feat_list']):
    fireplace_att.append(0)
    line = re.sub(' ', '', line)
    line = re.sub(',', '', line)
    for item in fireplace:
        if (re.search(item,line)):
            fireplace_att[i] = 1

df = pd.DataFrame({'laundry':laundry_att,'elevator':elevator_att,'hardwood':hardwood_att,'pets':pets_att,'doorman':doorman_att,'dishwasher':dishwasher_att,'gym':gym_att,'fee':fee_att,'pre_war':pre_war_att,'common_space':common_space_att,'subway':subway_att,'pool':pool_att,'balcony':balcony_att,'ac':a_c_att,'playroom':playroom_att,'parking':parking_att,'luxury':luxury_att,'fireplace':fireplace_att})
df.to_csv('binary_features_test.csv', sep=',')