using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CanvasMainMenu : UICanvas
{
    public void PlayGameButton()
    {
        UIManager.ins.OpenUI(UIID.UICGamePlay);

        Close();
    }
}
