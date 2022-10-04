using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;


[System.Serializable]
public class PlayerData
{
    [Header("--------- Game Setting ---------")]
    public bool isNew = true;
    public bool isMusic = true;
    public bool isSound = true;
    public bool isVibrate = true;
    public bool isNoAds = false;
    public int starRate = -1;


    [Header("--------- Game Params ---------")]
    public int gold = 0;
    public int cup = 0;
    public int level = 0;//Level hiện tại
    public int idSkin = 0; //Skin
    

    [Header("--------- Firebase ---------")]
    public string timeInstall;//Thời điểm cài game
    public int timeLastOpen;//Thời điểm cuối cùng mở game. Tính số ngày kể từ 1/1/1970
    public int timeInstallforFirebase; //Dùng trong hàm bắn Firebase UserProperty. Số ngày tính từ ngày 1/1/1970
    public int daysPlayed = 0;//Số ngày đã User có mở game lên
    public int sessionCount = 0;//Tống số session
    public int playTime = 0;//Tổng số lần nhấn play game
    public int playTime_Session = 0;//Số lần nhấn play game trong 1 session
    public int dieCount_levelCur = 0;//Số lần chết tại level hiện tại
    public int firstDayLevelPlayed = 0;  //Số level đã chơi ở ngày đầu tiên

    //--------- Others ---------
    public MiniGame_Save[] list_Minigames;
}

[System.Serializable]
public class MiniGame_Save {
    public int id;
    public string keyID;//ID để sau này đổi thứ tự thì vẫn lấy đc data cũ

    //Những data sẽ thay đổi trong game
    public bool isUnlock;
    public int level;                   //Mỗi lần vào chơi game sẽ tăng 1 level
    public int winMiniGameCount = 0;    //Số lần chiến thắng 1 minigame bằng thực lực
    public int loseMiniGameCount = 0;   //Số lần thua 1 minigame bằng thực lực
    public int thisLevelLoseCount = 0;   //Số lần thua ở level gần nhất
    public int victoryAllCount = 0;     //Số lần chiến thắng tất cả các game
    public int dieCount_levelCur = 0;   //Số lần chết tại level hiện tại
    public bool isPlayed = false;       //Game đã được chơi
    public int timePlayThisGame = 0;    //Đếm số lần chơi minigame này
    public MiniGame_Save(int id_Minigame, string key_Minigame) {
        id = id_Minigame;
        keyID = key_Minigame;
        isUnlock = false;
        level = 0;
        winMiniGameCount = 0;
        loseMiniGameCount = 0;
        thisLevelLoseCount = 0;
        victoryAllCount = 0;
        dieCount_levelCur = 0;
        isPlayed = false;
        timePlayThisGame = 0;
    }
}