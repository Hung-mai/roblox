using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class LoadingScreen : SingletonMonoBehaviour<LoadingScreen>
{
    public Image imgProgress;

    public void SetPercent(float to, float time)
    {
        imgProgress.DOFillAmount(to, time)
            .SetEase(Ease.Linear);
    }

    public void Close()
    {
        gameObject.SetActive(false);
    }
}
