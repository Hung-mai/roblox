using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Minigame_card : MonoBehaviour
{
    [SerializeField] private Image game_img;
    

    public void SetGameImage(Sprite sprite)
    {
        game_img.sprite = sprite;
    }
}
