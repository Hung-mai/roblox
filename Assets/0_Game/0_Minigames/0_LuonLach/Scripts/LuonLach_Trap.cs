using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LuonLach_Trap : MonoBehaviour
{
    public Transform _transform;
    public Transform chop;
    public List<GameObject> trapPieces;
    private float timeAlive;

    private void Awake()
    {
        _transform = transform;
    }

    public void RenderTrap()
    {
        timeAlive = 0;

        for(int i = 0; i < trapPieces.Count; i++)
        {
            trapPieces[i].SetActive(true);
        }

        int ran = Random.Range(5, 9);
        for(int i = 0; i < ran; i++)
        {
            trapPieces[Random.Range(0, trapPieces.Count)].SetActive(false);
        }
    }

    private void Update()
    {
        if(LuonLach_Manager.ins.luonLachState != LuonLachState.playingGame) return;
        timeAlive += Time.deltaTime;

        _transform.Rotate(new Vector3(-180, 0, 0), 180 / LuonLach_Manager.ins.rotationTime  * Time.deltaTime );
        if(chop.transform.position.y < -0.1f && timeAlive > 2)
        {
            // LuonLach_GameManager.ins.currentTrapIndex++;

            // LuonLach_GameManager.ins.OffTut();


            // Destroy(gameObject);
            LuonLach_ObjectPooling.ins.EnQueueObj(Constants.trap, this);  
            // LuonLach_GameManager.ins.PlayTrapSound();
            // if (DataManager.ins.gameSave.isVibrate)//code rung
            // {
            //     Vibration.Vibrate(GameManager.ins.isIOS ? 15 : 50);
            // }
        }
    }
}
