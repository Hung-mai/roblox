using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class DataManager : MonoBehaviour
{
    public static DataManager ins;
    private void Awake()
    {
        ins = this;
        DontDestroyOnLoad(this.gameObject);
    }

    public bool isLoaded = false;
    public PlayerData playerData;
    public const string PLAYER_DATA = "PLAYER_DATA";


    private void OnApplicationPause(bool pause) { SaveData(); }
    private void OnApplicationQuit() { SaveData(); }

    public void LoadData()
    {
        string d = PlayerPrefs.GetString(PLAYER_DATA, "");
        if (d != "")
        {
            playerData = JsonUtility.FromJson<PlayerData>(d);
        }
        else
        {
            playerData = new PlayerData();
        }

        //loadskin
        //load pet

        // sau khi hoàn thành tất cả các bước load data ở trên
        isLoaded = true;
        // FirebaseManager.Ins.OnSetUserProperty();  
    }

    public void SaveData()
    {
        if (!isLoaded) return;
        string json = JsonUtility.ToJson(playerData);
        PlayerPrefs.SetString(PLAYER_DATA, json);
    }
}