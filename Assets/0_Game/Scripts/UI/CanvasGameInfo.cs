using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;
using UnityEngine.Networking;
using System;

public class CanvasGameInfo : UICanvas
{
    public Image gameImg;
    public TextMeshProUGUI gameName;
    public TextMeshProUGUI gameDescription;
    
    private AssetBundle assetBundle; 


    public override void Open()
    {
        GetInfoGame();
        base.Open();
    }

    // phải được gán trước khi show lên
    public void GetInfoGame()
    {
        gameImg.sprite = GameManager.ins.currentMinigame.minigameImage;
        gameName.text = GameManager.ins.currentMinigame.gameName;
        gameDescription.text = GameManager.ins.currentMinigame.description;
    }

    public void Btn_PlayGame()
    {
        StartCoroutine(AsyncLoadScene());
    }

    private IEnumerator AsyncLoadScene()
    {
        WWW www = WWW.LoadFromCacheOrDownload(GameManager.ins.currentMinigame.urlAssetBundle, GameManager.ins.currentMinigame.version);
        yield return www;
        assetBundle = www.assetBundle;
        www.Dispose();
        if (assetBundle != null)
        {
            string[] path = assetBundle.GetAllScenePaths();
            GameManager.ins.currentPathScene = path[0];
            SceneManager.LoadSceneAsync(path[0]);
        }
    }
}
