using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public enum GameState { MainMenu, GamePlay, Finish}
public class GameManager : SingletonMonoBehaviour<GameManager>
{
    
    private static GameState gameState = GameState.MainMenu;
    
    protected void Awake()
    {
        Input.multiTouchEnabled = false;
        Application.targetFrameRate = 60;
        Screen.sleepTimeout = SleepTimeout.NeverSleep;

        int maxScreenHeight = 1280;
        float ratio = (float)Screen.currentResolution.width / (float)Screen.currentResolution.height;
        if (Screen.currentResolution.height > maxScreenHeight)
        {
            Screen.SetResolution(Mathf.RoundToInt(ratio * (float)maxScreenHeight), maxScreenHeight, true);
        }

        ChangeState(GameState.MainMenu);
    }

    public static void ChangeState(GameState state)
    {
        gameState = state;
    }

    public static bool IsState(GameState state)
    {
        return gameState == state;
    }

    private void Start()
    {
        StartCoroutine(ie_LoadGame());
    }

    private IEnumerator ie_LoadGame()
    {
        yield return new WaitUntil(() =>
            LoadingScreen.ins != null
            && SoundManager.ins != null
        );

        //SoundManager.PlayMusicBg(SoundManager.ins.bgMusic);

        LoadingScreen.ins.SetPercent(0.35f, 1f);
        DataManager.ins.LoadData();
        //StartCoroutine(CountTime());
        yield return Cache.GetWFS(1f);

        LoadingScreen.ins.SetPercent(0.45f, 1f);
        yield return Cache.GetWFS(1f);

        LoadingScreen.ins.SetPercent(0.7f, 1f);
        yield return Cache.GetWFS(1f);

        // if (GameManager.ins.data.charUsed == CharacterType.None)
        // {
        //     var checkReward = false;
        //     Timer.Schedule(this, 3f, () => checkReward = true);

        //     yield return new WaitUntil(() => checkReward || MaxManager.Ins.isVideoLoaded);

        //     LoadingScene.ins.Close();
        //     OpenSelectChar();
        // }

        // yield return new WaitUntil(() => GameManager.ins.data.charUsed != CharacterType.None);

        yield return Cache.GetWFS(1f);

        var sync = SceneManager.LoadSceneAsync("Home");

        yield return new WaitUntil(() => sync.isDone);

        LoadingScreen.ins.SetPercent(1f, 0.5f);

        // yield return new WaitUntil(() =>
        //     PlayerController.ins != null
        //     && LevelManager.ins != null
        //     && MapParent.ins != null
        // );

        DataManager.ins.SaveData();

        //yield return new WaitUntil

        
    }
}
