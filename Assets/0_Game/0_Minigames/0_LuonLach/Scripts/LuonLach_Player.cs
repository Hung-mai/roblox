using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LuonLach_Player : MonoBehaviour
{
    [HideInInspector] public Transform _transform;
    public PlayerSkinManager pSkin;
    public Animator playerAnimator;
    public LuonLach_Joystick joystick;
    public bool isDie = false;
    private LuonLachAnim currentAnim = LuonLachAnim.none;
    private float moveSpeed;
    public GameObject dieEffect;

    private void Awake()
    {
        _transform = transform;
        pSkin.ReloadSkin();
        pSkin.charSkin.animator.runtimeAnimatorController = playerAnimator.runtimeAnimatorController;
        playerAnimator = pSkin.charSkin.animator;
    }

    private void Start()
    {
        moveSpeed = LuonLach_Manager.ins.moveSpeed;
    }

    private void FixedUpdate() 
	{
        if(LuonLach_Manager.ins.luonLachState == LuonLachState.endGame) return;
        if(isDie) return;

        Vector3 moveVector = (_transform.right * joystick.Horizontal + _transform.forward * joystick.Vertical).normalized;

        if(moveVector != Vector3.zero)
        {
            if(LuonLach_Manager.ins.luonLachState == LuonLachState.beforeStart)
            {
                LuonLach_Manager.ins.luonLachState = LuonLachState.playingGame;
                LuonLach_Manager.ins.tutPanel.SetActive(false);
                LuonLach_Manager.ins.StartGame();
            }

            float x = moveVector.x;
            float z = moveVector.z;

            if((_transform.position.z < -6.5f && z < 0) || (_transform.position.z > 3.4f && z > 0))
            {
                z = 0;
            }

            if((_transform.position.x < -4.8f && x < 0) || (_transform.position.x > 4.8f && x > 0))
            {
                x = 0;
            }

            _transform.Translate(moveVector * moveSpeed * Time.deltaTime);
            //_transform.position = Vector3.Lerp(_transform.position, _transform.position + new Vector3(x, 0, z), moveSpeed * Time.deltaTime);
            // chuyển anim chạy
            ChangeAnim(LuonLachAnim.run);
            pSkin.charSkin._transform.rotation = Quaternion.LookRotation(moveVector);
        }
        else
        {
            ChangeAnim(LuonLachAnim.idle);
        }

        // pSkin.charSkin._transform.LookAt(moveVector);
	}

    private void ChangeAnim(LuonLachAnim luonLachAnim)
    {
        if(currentAnim != luonLachAnim)
        {
            currentAnim = luonLachAnim;
            playerAnimator.SetTrigger(luonLachAnim.ToString());
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if(isDie == true) return;
        if(other.transform.CompareTag(Constants.LL_trap))
        {
            LuonLach_Manager.ins.mainCamera_transform.parent = null;
            isDie = true;
            playerAnimator.enabled = false;
            
            // cho game manager show ra endgame
            StartCoroutine(Die());
            //sfx
            // int ranS = Random.Range(0, 3);
            // sfxChar.PlaySound(ranS);
        }
    }

    private IEnumerator Die()
    {
        var de = Instantiate(dieEffect, pSkin.charSkin.hipTransform.position, Quaternion.identity);
        Destroy(de, 1);
        yield return Cache.GetWFS(0.1f);
        gameObject.SetActive(false);

        yield return Cache.GetWFS(1f);
        StartCoroutine(LuonLach_Manager.ins.EndGamePlayerDie());
    }
}

public enum LuonLachAnim {none, idle, run, win, die}
