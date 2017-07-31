#!/usr/bin/env python

import numpy as np
import sys, os
from scipy import sparse

fdrmsf = sys.argv[1]
refrmsf = sys.argv[2]
outf = sys.argv[3]

def unique_columns2(data):
    dt = np.dtype((np.void, data.dtype.itemsize * data.shape[0]))
    dataf = np.asfortranarray(data).view(dt)
    u,uind = np.unique(dataf, return_inverse=True)
    u = u.view(data.dtype).reshape(-1,data.shape[0]).T
    return (u,uind)


if os.path.isfile(fdrmsf) & os.path.isfile(refrmsf):
	fdrms = np.loadtxt(fdrmsf)
	if len(fdrms.shape) < 2:
		tmparray = np.zeros(len(fdrms),)
		fdrms = np.vstack((tmparray,fdrms))
		fdrms = fdrms.transpose()
		
	refrms = np.loadtxt(refrmsf)
	if len(refrms.shape) < 2:
		tmparray = np.zeros(len(refrms),)
		refrms = np.vstack((tmparray,refrms))
		refrms = refrms.transpose()

	allspikes = np.concatenate((fdrms, refrms),axis=1)
	u,uind = unique_columns2(allspikes)
	np.savetxt(outf,u)

elif os.path.isfile(fdrmsf) & (not os.path.isfile(refrmsf)):
	fdrms = np.loadtxt(fdrmsf)
	np.savetxt(outf,fdrms)
	
elif (not os.path.isfile(fdrmsf)) & os.path.isfile(refrmsf):
	refrms = np.loadtxt(refrmsf)
	np.savetxt(outf,refrms)
	
