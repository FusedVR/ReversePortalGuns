using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shooter : MonoBehaviour {

    public AudioSource soundclip;
    public Rigidbody items;

    private IEnumerator Start() {
        while (true) {
            Rigidbody r = Instantiate(items, transform.position, transform.rotation);
            r.velocity = transform.forward * 30f;
            soundclip.pitch = Random.Range(.9f, 1.1f);
            soundclip.Play();
            yield return new WaitForSeconds(Random.Range(.4f, .8f));
        }
    }
}
