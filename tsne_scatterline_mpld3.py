"""
Defining a Custom Plugin
========================
Test the custom plugin demoed on the `Pythonic Perambulations
<http://jakevdp.github.io/blog/2014/01/10/d3-plugins-truly-interactive/>`_
blog.  Hover over the points to see the associated sinusoid.
Use the toolbar buttons at the bottom-right of the plot to enable zooming
and panning, and to reset the view.
"""
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import mpld3
from mpld3 import plugins, utils






class LinkedView(plugins.PluginBase):
    """A simple plugin showing how multiple axes can be linked"""

    JAVASCRIPT = """
    mpld3.register_plugin("linkedview", LinkedViewPlugin);
    LinkedViewPlugin.prototype = Object.create(mpld3.Plugin.prototype);
    LinkedViewPlugin.prototype.constructor = LinkedViewPlugin;
    LinkedViewPlugin.prototype.requiredProps = ["idpts", "idline", "data"];
    LinkedViewPlugin.prototype.defaultProps = {}
    function LinkedViewPlugin(fig, props){
        mpld3.Plugin.call(this, fig, props);
    };

    LinkedViewPlugin.prototype.draw = function(){
      var pts = mpld3.get_element(this.props.idpts);
      var line = mpld3.get_element(this.props.idline);
      var data = this.props.data;

      function mouseover(d, i){
        line.data = data[i];
        line.elements().transition()
            .attr("d", line.datafunc(line.data))
            .style("stroke", this.style.fill);
      }
      pts.elements().on("mouseover", mouseover);
    };
    """

    def __init__(self, points, line, linedata):
        if isinstance(points, matplotlib.lines.Line2D):
            suffix = "pts"
        else:
            suffix = None

        self.dict_ = {"type": "linkedview",
                      "idpts": utils.get_id(points, suffix),
                      "idline": utils.get_id(line),
                      "data": linedata}



# scatter periods and amplitudes
# np.random.seed(0)
# P = 0.2 + np.random.random(size=20)
# A = np.random.random(size=20)
# x = np.linspace(0, 10, 100)
# data = np.array([[x, Ai * np.sin(x / Pi)]
#                  for (Ai, Pi) in zip(A, P)])
# points = ax[1].scatter(P, A, c=P + A,
#                        s=200, alpha=0.5)
# ax[1].set_xlabel('Period')
# ax[1].set_ylabel('Amplitude')

"""
Data loading and t-sne stuff
"""
from sklearn import manifold
from sklearn.decomposition import PCA
import random
from scipy.signal import resample
from sklearn.cluster import KMeans


np.random.seed(0)
theta = pd.read_csv('/Users/mathew/work/whiskfree/data/theta_36.csv',header=None)
kappa = pd.read_csv('/Users/mathew/work/whiskfree/data/kappa_36.csv',header=None)
tt = pd.read_csv('/Users/mathew/work/whiskfree/data/trialtype_36.csv',header=None)
ch = pd.read_csv('/Users/mathew/work/whiskfree/data/choice_36.csv',header=None)

# Xpca_theta = PCA(n_components=30).fit_transform(theta.values.squeeze()[:,499:2499])
# Xpca_kappa = PCA(n_components=30).fit_transform(kappa.values.squeeze()[:,499:2499])

# resample, then remove mean of first 100ms

theta_r = np.array([[resample(theta.values.squeeze()[i,900:1890],100)] for i in xrange(0,theta.shape[0])])
# theta_r = theta_r.squeeze()
# theta_dm = np.array([[theta_r[i] - np.mean(theta_r[i,0:10])] for i in xrange(0,theta_r.shape[0])])
theta_dm = theta_r.squeeze()

Xpca_theta = PCA(n_components=30).fit_transform(theta_dm)

# tsne = manifold.TSNE(n_components=2,learning_rate=500,verbose=1,random_state=0)
# mappedX_theta = tsne.fit_transform(Xpca_theta)

kmeans = KMeans(9, random_state=8)
Y_hat = kmeans.fit(Xpca_theta)


subset = random.sample(theta.index, theta.shape[0])
# x = np.linspace(500, 2499, 2000)
x = np.linspace(900,1890,100)
# data = np.array([[x,theta.values.squeeze()[si,499:2499]] for si in subset]) # data needs to be N by 2 x time (for x and y axes)
data = np.array([[x,theta_dm[si]] for si in subset]) # data needs to be N by 2 x time (for x and y axes)


fig, ax = plt.subplots(1,2,figsize = (12,12))

ax[0] = plt.subplot2grid((3,3), (0, 0), colspan=3)
ax[1] = plt.subplot2grid((3,3), (1, 0), colspan=3,rowspan=2)

# points = ax[1].scatter(mappedX_theta[subset,0],mappedX_theta[subset,1],s = 100,c=Y_hat.labels_[subset],alpha=0.5)
points = ax[1].scatter(Xpca_theta[subset,0],Xpca_theta[subset,1],s = 100,c=Y_hat.labels_[subset],alpha=0.5)

ax[1].set_xlabel('t-sne dim 1')
ax[1].set_ylabel('t-sne dim 2')



# create the line object
lines = ax[0].plot(x, 0 * x, '-w', lw=3, alpha=0.5)
# ax[0].set_ylim(-6e-3, 6e-3)
ax[0].set_ylim(60,140)
# ax[0].set_ylim(-10,70)

ax[0].set_title("Mouse 36")

# transpose line data and add plugin
linedata = data.transpose(0, 2, 1).tolist()
plugins.connect(fig, LinkedView(points, lines[0], linedata))

mpld3.show()
