
# coding: utf-8

# # 3 class discrimination of trialtype.
# ### Using sklean and skflow. Comparison to each of the 4 mice

# In[163]:

import tensorflow as tf
import tensorflow.contrib.learn as skflow
import numpy as np
import matplotlib.pyplot as plt
# get_ipython().magic('matplotlib inline')
import pandas as pd
import seaborn as sns
import random
from scipy.signal import resample
from scipy.stats import zscore
from scipy import interp
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
from sklearn import metrics
from sklearn import cross_validation
from IPython import display # For plotting intermediate results


# In[365]:

# data loading function
def data_loader(mouse_name):
    theta = pd.read_csv('~/work/whiskfree/data/theta_' + mouse_name + '.csv',header=None)
    kappa = pd.read_csv('~/work/whiskfree/data/kappa_' + mouse_name + '.csv',header=None)
    tt = pd.read_csv('~/work/whiskfree/data/trialtype_' + mouse_name + '.csv',header=None)
    ch = pd.read_csv('~/work/whiskfree/data/choice_' + mouse_name + '.csv',header=None)

    return theta, kappa, tt, ch

def data_parser(theta,kappa,tt,ch,tt_ch):

    theta_r = np.array([[resample(theta.values.squeeze()[i,950:1440],50)] for i in range(0,theta.shape[0])])
    theta_r = zscore(theta_r.squeeze(),axis=None)

    kappa_r = np.array([[resample(kappa.values.squeeze()[i,950:1440],50)] for i in range(0,kappa.shape[0])])
    kappa_r = zscore(kappa_r.squeeze(),axis=None)

    kappa_df = pd.DataFrame(kappa_r)
    theta_df = pd.DataFrame(theta_r)

    both_df = pd.concat([theta_df,kappa_df],axis=1)

    if tt_ch == 'tt':
        # trial type
        clean = np.nan_to_num(tt) !=0
        tt_c = tt[clean.squeeze()].values
    else :
        # choice
        clean = np.nan_to_num(ch) !=0
        tt_c = ch[clean.squeeze()].values

    # tt_c = tt[tt.values !=0|3].values
    both = both_df.values
    # both_c = both[clean.squeeze(),:]
    both_c = both[clean.squeeze(),:]

    # keeping one hot vector for now (incase we want it later)
#     labs = np.eye(3)[tt_c.astype(int)-1]
    # y[np.arange(3), a] = 1
#     labs = labs.squeeze()

    return both_c, tt_c, clean


# In[466]:

mouse_name = '32'
theta, kappa, tt, ch = data_loader(mouse_name)
fig, ax = plt.subplots(1,2)
_ = ax[0].plot(theta[:100].T)
_ = ax[1].plot(kappa[:100].T)
plt.show()

# In[495]:

both_c, tt_c, clean = data_parser(theta,kappa,tt,ch,'tt')
_ = plt.plot(both_c[:100].T)
display.display(plt.gcf)
plt.show(block=False)


# In[496]:

# Let's use 20% of the data for testing and 80% for training
trainsize = int(len(both_c) * 0.8)
testsize = len(both_c) - trainsize
print('Desired training/test set sizes:',trainsize, testsize)

subset = random.sample(range(len(both_c)),trainsize)
fullrange = range(0,len(both_c))
toexclude = np.delete(fullrange,subset)
traindata = both_c[subset,:]
# trainlabs = labs[subset,:]
testdata = np.delete(both_c,subset,axis=0)
# testlabs = np.delete(labs,subset,axis=0)

# non one-hot style labels
trainlabs1D = tt_c[subset].squeeze()
testlabs1D = np.delete(tt_c,subset)

print('training set shape:',traindata.shape)
print('test set shape:',testdata.shape)
# print('training labels shape:',trainlabs.shape)
# print('test labels shape:',testlabs.shape)
print('1D train label shape:', trainlabs1D.shape)
print('1D test label shape:', testlabs1D.shape)


# In[497]:

# ROC mouse + 2 MODELS of all trials with binarised labels
fpr = dict()
tpr = dict()
roc_auc = dict()
n_classes = 3


trialtypes = ['Anterior Pole','Posterior Pole','No Go'] # 32-34
# trialtypes = ['Posterior Pole','Anterior Pole','No Go'] # 36

lr = LogisticRegression()
NN = skflow.TensorFlowDNNClassifier(hidden_units=[100], n_classes=3,batch_size=128, steps=1000, optimizer = 'Adam',learning_rate=0.001,verbose=0)


# Change the model here
preds = cross_validation.cross_val_predict(lr, both_c, tt_c.squeeze()-1, cv=5)
preds_NN = cross_validation.cross_val_predict(NN, both_c, tt_c.squeeze()-1, cv=5)

with plt.style.context('fivethirtyeight'):
    fig, ax = plt.subplots(1,3,figsize=(15,6))

    # MOUSE
    mouse_choice = ch[clean.squeeze()].values
    n_classes = 3
    for i in range(0,3):
        these_trials = tt_c == i+1
        binary_trials = np.zeros_like(tt_c.squeeze())
        binary_trials[these_trials.squeeze()] = 1

        wrong = mouse_choice != i+1
        binary_preds = np.ones_like(mouse_choice)
        binary_preds[wrong] = 0
        fpr[i], tpr[i], thresholds = metrics.roc_curve(binary_trials,binary_preds)
        roc_auc[i] = metrics.auc(fpr[i], tpr[i])
        ax[0].plot(fpr[i], tpr[i], lw=1, label='ROC ' + trialtypes[i] +' (area = %0.2f)' % (roc_auc[i]))


    # Compute macro-average ROC following sklearn docs

    # First aggregate all false positive rates
    all_fpr = np.unique(np.concatenate([fpr[i] for i in range(n_classes)]))
    # Then interpolate all ROC curves at this points
    mean_tpr = np.zeros_like(all_fpr)
    for i in range(n_classes):
        mean_tpr += interp(all_fpr, fpr[i], tpr[i])
    # Finally average it and compute AUC
    mean_tpr /= n_classes
    fpr["macro"] = all_fpr
    tpr["macro"] = mean_tpr
    roc_auc["macro"] = metrics.auc(fpr["macro"], tpr["macro"])
    ax[0].plot(fpr["macro"], tpr["macro"],
             label='macro-average ROC curve (area = {0:0.2f})'''.format(roc_auc["macro"]),linewidth=2)

    ax[0].plot([0, 1], [0, 1], '--', color=(0.6, 0.6, 0.6), label='Chance')
    ax[0].legend(loc=4)
    ax[0].set_title('Mouse ' + mouse_name)
    ax[0].set_xlim([-0.2,1.1])
    ax[0].set_ylim([-0.2,1.1])

    # Logistic Regression
    for i in range(0,3):
        these_trials = tt_c == i+1
        binary_trials = np.zeros_like(tt_c.squeeze())
        binary_trials[these_trials.squeeze()] = 1

        wrong = preds != i
        binary_preds = np.ones_like(preds)
        binary_preds[wrong] = 0
        fpr[i], tpr[i], thresholds = metrics.roc_curve(binary_trials,binary_preds)
        roc_auc[i] = metrics.auc(fpr[i], tpr[i])
        ax[1].plot(fpr[i], tpr[i], lw=1, label='ROC ' + trialtypes[i] +' (area = %0.2f)' % (roc_auc[i]))


    # Compute macro-average ROC following sklearn docs

    # First aggregate all false positive rates
    all_fpr = np.unique(np.concatenate([fpr[i] for i in range(n_classes)]))
    # Then interpolate all ROC curves at this points
    mean_tpr = np.zeros_like(all_fpr)
    for i in range(n_classes):
        mean_tpr += interp(all_fpr, fpr[i], tpr[i])
    # Finally average it and compute AUC
    mean_tpr /= n_classes
    fpr["macro"] = all_fpr
    tpr["macro"] = mean_tpr
    roc_auc["macro"] = metrics.auc(fpr["macro"], tpr["macro"])
    ax[1].plot(fpr["macro"], tpr["macro"],
             label='macro-average ROC curve (area = {0:0.2f})'''.format(roc_auc["macro"]),linewidth=2)

    ax[1].plot([0, 1], [0, 1], '--', color=(0.6, 0.6, 0.6), label='Chance')
    ax[1].legend(loc=4)
    ax[1].set_title('Logistic Regression')
    ax[1].set_xlim([-0.2,1.1])
    ax[1].set_ylim([-0.2,1.1])


    # Neural Network
    for i in range(0,3):
        these_trials = tt_c == i+1
        binary_trials = np.zeros_like(tt_c.squeeze())
        binary_trials[these_trials.squeeze()] = 1

        wrong = preds_NN != i
        binary_preds = np.ones_like(preds)
        binary_preds[wrong] = 0
        fpr[i], tpr[i], thresholds = metrics.roc_curve(binary_trials,binary_preds)
        roc_auc[i] = metrics.auc(fpr[i], tpr[i])
        ax[2].plot(fpr[i], tpr[i], lw=1, label='ROC ' + trialtypes[i] +' (area = %0.2f)' % (roc_auc[i]))


    # Compute macro-average ROC following sklearn docs

    # First aggregate all false positive rates
    all_fpr = np.unique(np.concatenate([fpr[i] for i in range(n_classes)]))
    # Then interpolate all ROC curves at this points
    mean_tpr = np.zeros_like(all_fpr)
    for i in range(n_classes):
        mean_tpr += interp(all_fpr, fpr[i], tpr[i])
    # Finally average it and compute AUC
    mean_tpr /= n_classes
    fpr["macro"] = all_fpr
    tpr["macro"] = mean_tpr
    roc_auc["macro"] = metrics.auc(fpr["macro"], tpr["macro"])
    ax[2].plot(fpr["macro"], tpr["macro"],
             label='macro-average ROC curve (area = {0:0.2f})'''.format(roc_auc["macro"]),linewidth=2)

    ax[2].plot([0, 1], [0, 1], '--', color=(0.6, 0.6, 0.6), label='Chance')
    ax[2].legend(loc=4)
    ax[2].set_title('Neural Network')
    ax[2].set_xlim([-0.2,1.1])
    ax[2].set_ylim([-0.2,1.1])

# plt.savefig('figs/ROC_allthree_trailtype_preds_'+ mouse_name +'.png')
plt.draw()

# In[498]:

# Softmax probability version
fpr = dict()
tpr = dict()
roc_auc = dict()
n_classes = 3

probs = lr.fit(traindata,trainlabs1D-1).predict_proba(testdata)
probs_NN = NN.fit(traindata,trainlabs1D-1).predict_proba(testdata)

with plt.style.context('fivethirtyeight'):
    fig, ax = plt.subplots(1,3, figsize=(15,5))

    # MOUSE
    mouse_choice = ch[clean.squeeze()].values
    n_classes = 3
    for i in range(0,3):
        these_trials = tt_c == i+1
        binary_trials = np.zeros_like(tt_c.squeeze())
        binary_trials[these_trials.squeeze()] = 1

        wrong = mouse_choice != i+1
        binary_preds = np.ones_like(mouse_choice)
        binary_preds[wrong] = 0
        fpr[i], tpr[i], thresholds = metrics.roc_curve(binary_trials,binary_preds)
        roc_auc[i] = metrics.auc(fpr[i], tpr[i])
        ax[0].plot(fpr[i], tpr[i], lw=1, label='ROC ' + trialtypes[i] +' (area = %0.2f)' % (roc_auc[i]))


    # Compute macro-average ROC following sklearn docs

    # First aggregate all false positive rates
    all_fpr = np.unique(np.concatenate([fpr[i] for i in range(n_classes)]))
    # Then interpolate all ROC curves at this points
    mean_tpr = np.zeros_like(all_fpr)
    for i in range(n_classes):
        mean_tpr += interp(all_fpr, fpr[i], tpr[i])
    # Finally average it and compute AUC
    mean_tpr /= n_classes
    fpr["macro"] = all_fpr
    tpr["macro"] = mean_tpr
    roc_auc["macro"] = metrics.auc(fpr["macro"], tpr["macro"])
    ax[0].plot(fpr["macro"], tpr["macro"],
             label='macro-average ROC curve (area = {0:0.2f})'''.format(roc_auc["macro"]),linewidth=2)
    ax[0].plot([0, 1], [0, 1], '--', color=(0.6, 0.6, 0.6), label='Chance')
    ax[0].legend(loc=4)
    ax[0].set_title('Mouse ' + mouse_name)
    ax[0].set_xlim([-0.2,1.1])
    ax[0].set_ylim([-0.2,1.1])

    # Logistic Regression
    for i in range(0,3):
        these_trials = testlabs1D == i+1
        binary_trials = np.zeros_like(testlabs1D.squeeze())
        binary_trials[these_trials.squeeze()] = 1

        fpr[i], tpr[i], thresholds = metrics.roc_curve(binary_trials,probs[:,i])
        roc_auc[i] = metrics.auc(fpr[i], tpr[i])
        ax[1].plot(fpr[i], tpr[i], lw=1, label='ROC ' + trialtypes[i] +' (area = %0.2f)' % (roc_auc[i]))


    # Compute macro-average ROC following sklearn docs
    # First aggregate all false positive rates
    all_fpr = np.unique(np.concatenate([fpr[i] for i in range(n_classes)]))
    # Then interpolate all ROC curves at this points
    mean_tpr = np.zeros_like(all_fpr)
    for i in range(n_classes):
        mean_tpr += interp(all_fpr, fpr[i], tpr[i])
    # Finally average it and compute AUC
    mean_tpr /= n_classes
    fpr["macro"] = all_fpr
    tpr["macro"] = mean_tpr
    roc_auc["macro"] = metrics.auc(fpr["macro"], tpr["macro"])
    ax[1].plot(fpr["macro"], tpr["macro"],label='macro-average ROC curve (area = {0:0.2f})'''.format(roc_auc["macro"]),linewidth=2)
    ax[1].plot([0, 1], [0, 1], '--', color=(0.6, 0.6, 0.6), label='Chance')
    ax[1].legend(loc=4)
    ax[1].set_title('Logistic Regression')
    ax[1].set_xlim([-0.2,1.1])
    ax[1].set_ylim([-0.2,1.1])

    # Neural Network
    for i in range(0,3):
        these_trials = testlabs1D == i+1
        binary_trials = np.zeros_like(testlabs1D.squeeze())
        binary_trials[these_trials.squeeze()] = 1

        fpr[i], tpr[i], thresholds = metrics.roc_curve(binary_trials,probs_NN[:,i])
        roc_auc[i] = metrics.auc(fpr[i], tpr[i])
        ax[2].plot(fpr[i], tpr[i], lw=1, label='ROC ' + trialtypes[i] +' (area = %0.2f)' % (roc_auc[i]))


    # Compute macro-average ROC following sklearn docs
    # First aggregate all false positive rates
    all_fpr = np.unique(np.concatenate([fpr[i] for i in range(n_classes)]))
    # Then interpolate all ROC curves at this points
    mean_tpr = np.zeros_like(all_fpr)
    for i in range(n_classes):
        mean_tpr += interp(all_fpr, fpr[i], tpr[i])
    # Finally average it and compute AUC
    mean_tpr /= n_classes
    fpr["macro"] = all_fpr
    tpr["macro"] = mean_tpr
    roc_auc["macro"] = metrics.auc(fpr["macro"], tpr["macro"])
    ax[2].plot(fpr["macro"], tpr["macro"],label='macro-average ROC curve (area = {0:0.2f})'''.format(roc_auc["macro"]),linewidth=2)
    ax[2].plot([0, 1], [0, 1], '--', color=(0.6, 0.6, 0.6), label='Chance')
    ax[2].legend(loc=4)
    ax[2].set_title('Neural Network')
    ax[2].set_xlim([-0.2,1.1])
    ax[2].set_ylim([-0.2,1.1])

# plt.savefig('figs/ROC_both_trialtype_3probs_'+ mouse_name +'.png')
plt.draw()

# In[544]:

# TRIALTYPE
# Confusion matrices. Mouse vs model
mouse_choice = ch[clean.squeeze()].values
cm_m = confusion_matrix(tt_c,mouse_choice)

# Confusion matrices
cm_lr = confusion_matrix(tt_c,preds+1)
cm_NN = confusion_matrix(tt_c,preds_NN+1)

# # CHOICE
# # Confusion matrices. Mouse vs model
# mouse_choice = ch[clean.squeeze()].values
# cm_m = confusion_matrix(tt[clean.squeeze()].values,mouse_choice)

# # Confusion matrices
# cm_lr = confusion_matrix(tt[clean.squeeze()].values,preds+1)
# cm_NN = confusion_matrix(tt[clean.squeeze()].values,preds_NN+1)


with sns.axes_style("white"):
    fig,ax = plt.subplots(1,3,figsize=(15,6))


    ax[0].imshow(cm_m,interpolation='none',cmap="Greys")
    ax[0].set_title('Mouse ' + mouse_name + '. ' + str(int(100 * accuracy_score(tt_c,mouse_choice))) + '%')
    ax[0].set_ylabel('True label')
    ax[0].set_xlabel('Predicted label')
    tick_marks = np.arange(len(trialtypes))
    ax[0].set_xticks(tick_marks, trialtypes)
    ax[0].set_yticks(tick_marks, trialtypes)

    for i in range(0,3):
        for j in range(0,3):
            ax[0].text(j, i, cm_m[i,j], va='center', ha='center',bbox=dict(facecolor='white',edgecolor='white', alpha=0.5))

    ax[1].imshow(cm_lr,interpolation='none',cmap="Greys")
    ax[1].set_title('Logistic Regression' + '. ' + str(int(100 * accuracy_score(tt_c,preds+1))) + '%')
    ax[1].set_ylabel('True label')
    ax[1].set_xlabel('Predicted label')

    for i in range(0,3):
        for j in range(0,3):
            ax[1].text(j, i, cm_lr[i,j], va='center', ha='center',bbox=dict(facecolor='white',edgecolor='white', alpha=0.5))

    ax[2].imshow(cm_NN,interpolation='none',cmap="Greys")
    ax[2].set_title('Neural Network' + '. ' + str(int(100 * accuracy_score(tt_c,preds_NN+1))) + '%')
    ax[2].set_ylabel('True label')
    ax[2].set_xlabel('Predicted label')

    for i in range(0,3):
        for j in range(0,3):
            ax[2].text(j, i, cm_NN[i,j], va='center', ha='center',bbox=dict(facecolor='white',edgecolor='white', alpha=0.5))


# plt.savefig('figs/Cmatrix_lr_trialtype_choice_'+ mouse_name +'.png')
plt.draw()

# In[479]:

# preds = cross_validation.cross_val_predict(lr, both_c, tt_c.squeeze()-1, cv=5)
# plt.hist(preds)
# x = tt_c[~np.isnan(tt_c)]
# x.shape
# plt.hist(np.nan_to_num(tt))
with plt.style.context('fivethirtyeight'):
    fig, ax = plt.subplots(1,3, figsize=(12,3))
    ax[0].hist(tt_c)
#     ax[0].hist(tt[clean.squeeze()].values) # when predicting choice
    ax[0].set_title('Trialtype')
#     ax[0].set_xticks([1,2,3],trialtypes)
    ax[0].set_xlim([0.5,3.5])

    ax[1].hist(mouse_choice)
    ax[1].set_title('Choice')
    ax[1].set_xlim([0.5,3.5])

    ax[2].hist(preds_NN+1)
    ax[2].set_title('NN choice')
    ax[2].set_xlim([0.5,3.5])


plt.suptitle('Mouse ' + mouse_name, x=0.5,y=1.1,fontsize=15)
# plt.savefig('figs/choice_number_'+ mouse_name +'.png')
plt.draw()

# In[557]:

# print('Mouse '+ mouse_name + '. '+ accuracy_score(tt_c,mouse_choice) + '%')
# int(100 *accuracy_score(tt_c,mouse_choice))
# print('Mouse ' + mouse_name + '. ' + str(int(100 * accuracy_score(tt_c,mouse_choice))) + '%')
trialtypes = ['Anterior Pole','Posterior Pole','No Go']

print(metrics.classification_report(tt_c,mouse_choice,target_names=trialtypes))
print('Weighted f1_score: ',metrics.f1_score(tt_c,mouse_choice,average='weighted'))
print(metrics.classification_report(tt_c,preds_NN+1,target_names=trialtypes))
print('Weighted f1_score: ',metrics.f1_score(tt_c,preds_NN+1,average='weighted'))

plt.show()
