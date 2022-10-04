using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerSkinManager : MonoBehaviour
{
    public bool isUser;
    public int idSkin = -1;

    public List<CharSkin> listSkins;
    public CharSkin charSkin;

    // private void Start()
    // {
    //     ReloadSkin();
    // }

    public void ReloadSkin()
    {
        if (isUser && DataManager.ins != null) 
        {
            //Nếu là User
            idSkin = DataManager.ins.playerData.idSkin;
        }
        else
        {   // nếu là bot
            idSkin = Random.Range(0, listSkins.Count);
                    
        }
        
        charSkin = Instantiate(listSkins[idSkin], transform);
    }
}
