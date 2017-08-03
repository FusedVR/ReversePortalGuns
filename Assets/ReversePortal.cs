using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReversePortal : MonoBehaviour {

    public Transform output;
    public ReversePortal next;
    public SteamVR_TrackedObject hand;

    private bool tempFireDisable = false;
    private Material portalMat;
    int index = 0;
    int MAX_LENGTH = 10;
    private List<float> hitTimes = new List<float>();

    private void Start() {
        portalMat = GetComponentInChildren<Renderer>().sharedMaterial;
        for (int i = 0; i < MAX_LENGTH; i++)
            hitTimes.Add(-100f); //so that this does not render
    }

    private void Update() {
        transform.position = hand.transform.position;
        transform.rotation = hand.transform.rotation;
    }

    private void OnTriggerEnter(Collider other) {
        if (!tempFireDisable) {
            Rigidbody r = other.GetComponentInParent<Rigidbody>();
            if (r) {
                next.Fire(r);
                AddHitTime(Time.time);
            }

        } else {
            tempFireDisable = false;
        }
    }

    public void AddHitTime(float time) {
        hitTimes[index] = time;
        index = (index + 1) % MAX_LENGTH;
        portalMat.SetFloatArray("_TimeOffsets", hitTimes);
    }

    void Fire(Rigidbody r) {
        if (r != null) {
            tempFireDisable = true;
            r.transform.position = output.position;
            r.transform.rotation *= output.rotation;
            r.velocity = output.forward * r.velocity.magnitude;
        }
    }

}
