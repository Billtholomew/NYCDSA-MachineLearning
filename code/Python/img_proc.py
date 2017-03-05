import numpy as np
import os
import cv2
import re
from collections import defaultdict
from scipy.stats import mode

rootdir = r'D:/images_retry/images/'


with open('img_data3.csv', 'w+') as fout:
    fout.write('listing,mode_h,mu_l,mu_s,sd_l,sd_s\n')
	
for dirpath, dirnames, _ in os.walk(rootdir):
    for d in dirnames:
        for _, _, files in os.walk(rootdir + d):
            musd = defaultdict(list)
            for f in files:
                fName = rootdir + d + '/' + f
                try:
                    img = cv2.imread(fName)
                    if img is None:
                        continue
                except:
                    continue
                img = img.astype(np.uint8)
                img = cv2.cvtColor(img, cv2.COLOR_BGR2HLS_FULL)
                mode_h = mode(np.round(img[:, :, 0]), axis=None)[0]
				#mu_h, sd_h = cv2.meanStdDev(img[:, :, 0])
                mu_l, sd_l = cv2.meanStdDev(img[:, :, 1])
                mu_s, sd_s = cv2.meanStdDev(img[:, :, 2])
                musd['mode_h'].append(mode_h)
                musd['mu_l'].append(mu_l)
                musd['mu_s'].append(mu_s)
                musd['sd_l'].append(sd_l)
                musd['sd_s'].append(sd_s)
            for k,v in musd.iteritems():
                musd[k] = np.mean(v)
            musd['mode_h'] = mode(musd['mode_h'])
            line = '{listing},{mode_h},{mu_l},{mu_s},{sd_l},{sd_s}\n'.format(listing=d,
                                                                                  mode_h=musd['mode_h'], 
																				  mu_l=musd['mu_l'], sd_l=musd['sd_l'],
                                                                                  mu_s=musd['mu_s'], sd_s=musd['sd_s'],
                                                                                  )
            try:
                with open('img_data3.csv', 'a') as fout:
                    fout.write(line)
            except:
                continue