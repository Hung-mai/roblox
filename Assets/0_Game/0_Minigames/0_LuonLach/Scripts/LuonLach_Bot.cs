using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class LuonLach_Bot : MonoBehaviour
{
    private Transform _transform;
    [SerializeField] private NavMeshAgent agent;
    public bool isDie = false;
    public Animator botAnimator;
    private Vector3 targetLocation;

    private List<Transform> locations;
    private Transform tempGO;
    [SerializeField] private PlayerSkinManager pSkin;
    private LuonLachAnim currentAnim;
    public GameObject dieEffect;

    private void Awake()
    {
        _transform = transform;
        pSkin.ReloadSkin();
        pSkin.charSkin.animator.runtimeAnimatorController = botAnimator.runtimeAnimatorController;
        botAnimator = pSkin.charSkin.animator;
    }

    private void Start()
    {
        agent.speed = LuonLach_Manager.ins.moveSpeed;
    }

    void Update()
    {
        if(isDie) return;
        if(LuonLach_Manager.ins.luonLachState != LuonLachState.playingGame) return;
        if((_transform.position - targetLocation).sqrMagnitude > 0.6f)
        {
            ChangeAnim(LuonLachAnim.run);
        }
        else
        {
            ChangeAnim(LuonLachAnim.idle);
        }
    }

    public IEnumerator FindTatgetLocation()
    {
        locations = new List<Transform>();

        for(int i = 0; i < 20; i++)
        {
            if(LuonLach_Manager.ins.currentTrap != null && LuonLach_Manager.ins.currentTrap.trapPieces[i].activeSelf == false ) // ko có bẫy
            {
                // nếu là khôn
                if((_transform.position - LuonLach_Manager.ins.locations[i].transform.position).sqrMagnitude < 7) // khôn
                {
                    locations.Add(LuonLach_Manager.ins.locations[i]);
                }
            }
            else
            {
                // đoạn này có thể thêm vào để làm cho bot ngu hơn
            }
        }

        if(locations.Count > 0 && LuonLach_Manager.ins.currentTrap != null)
        {
            ShuffleLocations();
            targetLocation = locations[0].transform.position;
            targetLocation = new Vector3(targetLocation.x, 0, targetLocation.z + Random.Range(0.1f, 0.6f));
            // yield return Cachee.GetWFS(Random.Range(0.0f, 1.0f));
            yield return Cache.GetWFS(0.1f);
            if(agent.enabled == true)
            {
                agent.SetDestination(targetLocation);
            }
        }
    }

    public void ShuffleLocations()
    {
        for (int i = 0; i < locations.Count; i++) {
            int rnd = Random.Range(0, locations.Count);
            tempGO = locations[rnd];
            locations[rnd] = locations[i];
            locations[i] = tempGO;
        }
    }

    private void ChangeAnim(LuonLachAnim luonLachAnim)
    {
        if(currentAnim != luonLachAnim)
        {
            currentAnim = luonLachAnim;
            botAnimator.SetTrigger(luonLachAnim.ToString());
        }
    }

    public IEnumerator Win()
    {
        if(agent != null)
        {
            agent.enabled = false;
        }
        yield return Cache.GetWFS(Random.Range(0.0f, 0.7f));
        ChangeAnim(LuonLachAnim.win);
    }

    private void OnTriggerEnter(Collider other)
    {
        if(isDie) return;
        if(other.transform.CompareTag(Constants.LL_trap))
        {
            botAnimator.enabled = false;
            isDie = true;
            StartCoroutine(Die());
        }
    }

    private IEnumerator Die()
    {
        var de = Instantiate(dieEffect, pSkin.charSkin.hipTransform.position, Quaternion.identity);
        Destroy(de, 1);
        yield return Cache.GetWFS(0.1f);
        gameObject.SetActive(false);
    }
}
