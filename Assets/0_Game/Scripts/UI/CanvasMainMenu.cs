using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CanvasMainMenu : UICanvas
{
    public Minigame_card minigameCard_Prefab;
    public Transform contentTransform;

    public override void Open()
    {
        base.Open();
        SpawnMinigameCards();
    }

    private void SpawnMinigameCards()
    {
        for (int i = 0; i < GameManager.ins.listMinigames.Count; i++)
        {
            Minigame_card card = Instantiate(minigameCard_Prefab, contentTransform);
            card.SetGameImage(GameManager.ins.listMinigames[i].minigameImage);
            card.data_Minigame = GameManager.ins.listMinigames[i];
        }
    }

    public void PlayGameButton()
    {
        UIManager.ins.OpenUI(UIID.UICGamePlay);

        Close();
    }
}
