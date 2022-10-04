using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;

public enum LuonLachState { beforeStart, playingGame, endGame}
public class LuonLach_Manager : MonoBehaviour
{
    public static LuonLach_Manager ins;
    public LuonLachState luonLachState;
    public float rotationTime;

    private void Awake()
    {
        ins = this;
    }
    
    [Header("--------------- values -----------------")]
    public float moveSpeed;

    [Header("--------------- objects -----------------")]
    public Transform mainCamera_transform;
    public LuonLach_ObjectPooling objectPooling;
    public GameObject tutPanel;
    public GameObject endGamePanel;
    public List<Transform> locations;
    public List<LuonLach_Bot> bots;
    public LuonLach_Trap currentTrap;
    public TextMeshProUGUI endgameText;

    private void Start()
    {
        currentTrap.RenderTrap();
    }

    public void StartGame()
    {
        //StartCoroutine(RunGame());
        StartCoroutine(SpawnTraps());
    }

    public IEnumerator RunGame()
    {
        for(int i = 0; i < 30; i++)
        {
            yield return Cache.GetWFS(1);
            if(i == 29)
            {
                luonLachState = LuonLachState.endGame;
                
                // cho end game chỗ này
            }
        }
    }

    public void BotsFindLocation()
    {
        for (int i = 0; i < bots.Count; i++)
        {
            if(bots[i].isDie) continue;
            StartCoroutine(bots[i].FindTatgetLocation());
        }
    }

    private IEnumerator SpawnTraps()
    {
        int i = 0;
        while(luonLachState != LuonLachState.endGame && i < 6)
        {
            if(luonLachState == LuonLachState.endGame) break;
            if(i == 0)
            {
                yield return Cache.GetWFS(rotationTime * 120f / 180f);
            }
            else
            {
                yield return Cache.GetWFS(rotationTime);
            }
            if(luonLachState == LuonLachState.endGame) break;
            // var trap = Instantiate(trapPrefab, new Vector3(0, -0.025f, 5), Quaternion.identity);
            
            currentTrap = objectPooling.SpawnFromPool(Constants.trap);
            currentTrap._transform.localEulerAngles = new Vector3(180, 0, 0);
            currentTrap.RenderTrap();
            i++;
        }

        yield return Cache.GetWFS(rotationTime);
        yield return Cache.GetWFS(0.5f);
        StartCoroutine(EndgameTimeout());

        // cho hết game chỗ này
    }

    private IEnumerator EndgameTimeout()
    {
        luonLachState = LuonLachState.endGame;
        LuonLach_DynamicJoystick.ins.gameObject.SetActive(false);

        for(int i = 0; i < bots.Count; i++)
        {
            if(bots[i].isDie == false)
            {
                StartCoroutine(bots[i].Win());
            }
        }

        yield return Cache.GetWFS(0.5f);
        ShowEndgamePanel(true);
    }

    public IEnumerator EndGamePlayerDie()
    {
        yield return Cache.GetWFS(1);
        ShowEndgamePanel(false);
    }

    private void ShowEndgamePanel(bool isWin)
    {
        if(isWin)
        {
            endgameText.text = "Win";
        }
        else
        {
            endgameText.text = "Lose";
        }

        endGamePanel.SetActive(true);
    }

    public void Btn_Home()
    {
        SceneManager.LoadSceneAsync(Constants.homeScene);
    }

    public void Btn_Restart()
    {
        SceneManager.LoadSceneAsync(GameManager.ins.currentPathScene);
    }
}
