using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Minigame_card : MonoBehaviour
{
    [SerializeField] private Image game_img;
    public Data_Minigame data_Minigame;

    public void SetGameImage(Sprite sprite)
    {
        game_img.sprite = sprite;
    }

    public void Btn_ClickToMinigameCard()
    {
        GameManager.ins.currentMinigame = data_Minigame;
        UIManager.ins.OpenUI(UIID.UICGameInfo);
    }
}
