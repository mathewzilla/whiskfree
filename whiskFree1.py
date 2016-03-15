# Loading plotting and (hopefully) modelling of whisker movements
import numpy as np
# import tables as tb
# import pandas as pd
# import scipy.io as sio
# from scipy import linalg
# import itertools


# from sklearn.decomposition import PCA
# from sklearn.cluster import KMeans
# from sklearn import mixture
# from sklearn.externals.six.moves import xrange

#%matplotlib inline
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from sklearn import mixture
from sklearn.externals.six.moves import xrange

import seaborn as sns

#from lightning import Lightning
#lgn = Lightning(host="http://localhost:3000")
#lgn.create_session("whiskfree1")
theta = np.loadtxt('/Users/mathew/GoogleDrive/Data/Gutnisky_final/behaviour/theta_N18.csv')
plt.plot(theta)

theta_bits = np.reshape(theta,(100,len(theta)/100))

#
pca = PCA(n_components=2,whiten='false')
# Fit the PCA
X_S = pca.fit(theta_bits).transform(theta_bits)
# Percentage of variance explained for each components
print('explained variance ratio (first few components): %s'
      % str(pca.explained_variance_ratio_))
#from sklearn.cluster import KMeans
#kmeans = KMeans(4, random_state=8)
#Y_hat = kmeans.fit(X_S).labels_
#plt.scatter(X_S[:,0], X_S[:,1], c=Y_hat,alpha = 0.4);
#mu = kmeans.cluster_centers_
#plt.scatter(mu[:,0], mu[:,1], s=100, c=np.unique(Y_hat))

from scipy import signal
acorr = signal.fftconvolve(theta, theta[::-1], mode='full') # much faster than np.correlate

plt.plot(theta_bits[12000:12010,:].T)

pca = PCA(n_components='mle')
X_S = pca.fit(theta_bits)

lgn.line(np.cumsum(pca.explained_variance_))
V = pca.components_
V.shape
plot(V[:,0:5])

sns.set_palette("husl",10)
sns.palplot(sns.color_palette)
from lpproj import LocalityPreservingProjection
lpp = LocalityPreservingProjection(n_components=2)
X_2D = lpp(theta_bits)
X_2D = lpp.fit_transform(theta_bits)

# Jake VDP wpca example function
from wpca import WPCA, EMPCA, PCA
def plot_results(ThisPCA, X, weights=None, Xtrue=None, ncomp=2):
    # Compute the standard/weighted PCA
    if weights is None:
        kwds = {}
    else:
        kwds = {'weights': weights}

    # Compute the PCA vectors & variance
    pca = ThisPCA(n_components=10).fit(X, **kwds)

    # Reconstruct the data using the PCA model
    Y = ThisPCA(n_components=ncomp).fit_reconstruct(X, **kwds)

    # Create the plots
    fig, ax = plt.subplots(2, 2, figsize=(16, 6))
    if Xtrue is not None:
        ax[0, 0].plot(Xtrue[:10].T, c='gray', lw=1)
        ax[1, 1].plot(Xtrue[:10].T, c='gray', lw=1)
    ax[0, 0].plot(X[:10].T, c='black', lw=1)
    ax[1, 1].plot(Y[:10].T, c='black', lw=1)

    ax[0, 1].plot(pca.components_[:ncomp].T, c='black')

    ax[1, 0].plot(np.arange(1, 11), pca.explained_variance_ratio_)
    ax[1, 0].set_xlim(1, 10)
    ax[1, 0].set_ylim(0, None)

    ax[0, 0].xaxis.set_major_formatter(plt.NullFormatter())
    ax[0, 1].xaxis.set_major_formatter(plt.NullFormatter())

    ax[0, 0].set_title('Input Data')
    ax[0, 1].set_title('First {0} Principal Vectors'.format(ncomp))
    ax[1, 1].set_title('Reconstructed Data ({0} components)'.format(ncomp))
    ax[1, 0].set_title('PCA variance ratio')
    ax[1, 0].set_xlabel('principal vector')
    ax[1, 0].set_ylabel('proportion of total variance')

    fig.suptitle(ThisPCA.__name__, fontsize=16)
