using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[CreateAssetMenu(fileName = "Data", menuName = "ScriptableObjects/Data_Minigame", order = 1)]
public class Data_Minigame : ScriptableObject
{
    public MinigameID minigameID;
    public Sprite minigameImage;
    public string gameName;
    public string description;
    public string urlAssetBundle;
    public int version = 0;
    public ScreenOrientation creenOrientationGame;
}
