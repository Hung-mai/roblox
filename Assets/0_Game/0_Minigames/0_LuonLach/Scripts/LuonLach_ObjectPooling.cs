using System.Collections.Generic;
using UnityEngine;

public class LuonLach_ObjectPooling : MonoBehaviour
{
    #region Singleton
    public static LuonLach_ObjectPooling ins;
    public void Awake()
    {
        ins = this;
    }
    #endregion

    [System.Serializable]
    public class Pool
    {
        public string tag;
        public LuonLach_Trap prefab;
        public int size;
    }

    public List<Pool> pools;
    public Dictionary<string, Queue<LuonLach_Trap>> poolDictionary;

    void Start()
    {
        poolDictionary = new Dictionary<string, Queue<LuonLach_Trap>>();

        foreach (Pool p in pools)
        {
            Queue<LuonLach_Trap> objectPool = new Queue<LuonLach_Trap>();

            for (int i = 0; i < p.size; i++)
            {
                LuonLach_Trap obj = Instantiate(p.prefab, transform);
                obj.gameObject.SetActive(false);
                objectPool.Enqueue(obj);
            }

            poolDictionary.Add(p.tag, objectPool);
        }
    }

    LuonLach_Trap preb;
    public LuonLach_Trap SpawnFromPool (string tag)
    {
        LuonLach_Trap objToSpawn;
        try
        {
            objToSpawn = poolDictionary[tag].Dequeue();
        }
        catch
        {
            
            foreach (Pool p in pools)
            {
                if(p.tag.Equals(tag))
                {
                    preb = p.prefab;
                }
            }

            LuonLach_Trap obj = Instantiate(preb, transform);
            obj.gameObject.SetActive(false);
            poolDictionary[tag].Enqueue(obj);

            objToSpawn = poolDictionary[tag].Dequeue();
        }

        objToSpawn.gameObject.SetActive(true);
        return objToSpawn;
    }

    public void EnQueueObj(string tag, LuonLach_Trap objToEnqueue)
    {
        poolDictionary[tag].Enqueue(objToEnqueue);
        objToEnqueue.gameObject.SetActive(false);
    }
}
