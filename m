Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3A2WCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:02:13 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:26833 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217Ab3A2WCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:02:11 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI9371Ic85fh1102I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz8275bhz2dh668h839hd25hf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h34h1155h)
X-WSS-ID: 0MHEQJB-02-D4N-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: Linux 3.8-rc4
Thread-Topic: Linux 3.8-rc4
Thread-Index: AQHN9cxhktnF6ESNpkuAIBoIzsaQJZhQNCEAgACn4tCABRQtgP//oN5AgAB+F4D//6LmYIAAax0AgABUMQCAAH8jgIAAu/gAgAhrfoCAAD7IYIAAyyMA//+iZkAAEN8ZAAAMc2Aw
Date: Tue, 29 Jan 2013 22:02:01 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DF0A3B7@sausexdag04.amd.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
	<CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
	<CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7@sausexdag04.amd.com>
	<CAKocOONuFvcik229+1B0oeaBnQG7seZPeYf99xqduFa6kBZhOw@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF083DE@sausexdag04.amd.com>
	<CAKocOOMxAYw-XO-6XGteKb8NyHDq4_BdZn2njUNBh+a73wrFGA@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF084EA@sausexdag04.amd.com>
	<CAKocOOOYKAZPH1+W3usfRUh68594e8YKqBUORo2c5bCCCYDh0A@mail.gmail.com>
	<CAKocOOOaWSvWZkhLNBx9u6M5nOu39wUgnS-a9Srsbp5BTcdh1A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF086E6@sausexdag04.amd.com>
	<CAKocOOMD9i7TtzoH3c2pDXqSRXV8RB1qmqp_QxftCpfK763CqA@mail.gmail.com>
	<CAKocOONFpPBQH=naKdmrXa1ijpzf=0jonKuUWbw3NhEeumfM=A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF0A266@sausexdag04.amd.com>
	<CAKocOOPsvh=jOXLahe6ukjpyjOOqt9tRdwELxv8i0_Vi1xqQkA@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF0A37D@sausexdag04.amd.com>
 <CAKocOOORwoUAStDmFPhW1--WhAJaEzEmG-=tZ1sgkWKsquq=rQ@mail.gmail.com>
In-Reply-To: <CAKocOOORwoUAStDmFPhW1--WhAJaEzEmG-=tZ1sgkWKsquq=rQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.8.62]
Content-Type: multipart/mixed;
	boundary="_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0A3B7sausexdag04amdc_"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0A3B7sausexdag04amdc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> Sent: Tuesday, January 29, 2013 4:40 PM
> To: Deucher, Alexander
> Cc: Linus Torvalds; Linux Kernel Mailing List
> Subject: Re: Linux 3.8-rc4
>=20
> On Tue, Jan 29, 2013 at 1:13 PM, Deucher, Alexander
> <Alexander.Deucher@amd.com> wrote:
> >> -----Original Message-----
> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> >> Sent: Tuesday, January 29, 2013 2:11 PM
> >> To: Deucher, Alexander
> >> Cc: Linus Torvalds; Linux Kernel Mailing List
> >> Subject: Re: Linux 3.8-rc4
> >>
> >> On Tue, Jan 29, 2013 at 6:05 AM, Deucher, Alexander
> >> <Alexander.Deucher@amd.com> wrote:
> >> >> -----Original Message-----
> >> >> I was out sick for a few days and finally picked this bisect backup
> >> >> again. I started at 3.7 tag instead of 3.8-rc1 that I did in the pa=
st
> >> >> and also did bisect at drivers/gpu/drm/radeon instead. Here are the
> >> >> results:
> >> >>
> >> >> 6253e4c75d96006c06b9ac8f417eba873de2497b is the first bad commit
> >> >> commit 6253e4c75d96006c06b9ac8f417eba873de2497b
> >> >> Author: Alex Deucher <alexander.deucher@amd.com>
> >> >> Date:   Wed Dec 12 14:30:32 2012 -0500
> >> >>
> >> >>     drm/radeon: improve mc_stop/mc_resume on r5xx-r7xx
> >> >>
> >> >>     Along the same lines of what was done for evergreen+
> >> >>     in the last kernel.
> >> >>
> >> >>     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> >> >>
> >> >> git bisect log attached.
> >> >>
> >> >
> >> > Try the attached patch.  I think it should fix the issue.  I just ap=
plied a
> similar
> >> patch for newer asics.
> >> >
> >> > Alex
> >> >
> >>
> >> I reverted 6253e4c75d96006c06b9ac8f417eba873de2497b and DMAR
> faults
> >> went away. Undid the revert and applied your new patch. DMAR faults
> >> are back again.
> >>
> >>
> >> [   25.158653] [drm] PCIE GART of 512M enabled (table at
> >> 0x0000000000040000).
> >> [   25.158715] radeon 0000:01:00.0: WB enabled
> >> [   25.158719] radeon 0000:01:00.0: fence driver on ring 0 use gpu
> >> addr 0x0000000008000c00 and cpu addr 0xffff88002f143c00
> >> [   25.158721] radeon 0000:01:00.0: fence driver on ring 3 use gpu
> >> addr 0x0000000008000c0c and cpu addr 0xffff88002f143c0c
> >>
> >> A few observations and questions about r600_startup() code sequence:
> >>
> >> I notice DMAR faults right after
> >>
> >> [drm] Loading RV620 Microcode message which is from
> >> r600_init_microcode(). This routine does a series of
> >> request_firmware() calls. btw. don't see release_firmware() calls in
> >> regular code path, only from error legs in r600_init_microcode().
> >>
> >> However, this routine doesn't do any loading yet. When this routine
> >> returns, I am assuming request_firmware() step isn't complete yet
> >> based on my reading request_firmware() interface. At this point
> >> r600_startup() keeps chugging along, and does r600_mc_program() which
> >> in turn calls rv515_mc_stop() which was changed with the
> >> 6253e4c75d96006c06b9ac8f417eba873de2497b commit.
> >>
> >> I am thinking the changes somehow eliminated a wait or delay that used
> >> be there for request_firmware() step to complete (?)
> >>
> >> I can see from dmesg that the faults occur right after:
> >>
> >> r600_init_microcode(rdev);
> >>
> >> and stop before r600_pcie_gart_enable()
> >
> > r600_init_microcode() doesn't actually touch the hardware it just calls
> request_firmware() to fetch the microcode images from disk.  The microcod=
e
> doesn't get loaded onto the hardware until r600_cp_load_microcode() much
> later in the function.  I don't think the microcode has anything to do wi=
th this.
> >
> > rv515_mc_stop() stops GPU memory clients (e.g., the displays) and black=
s
> out the GPU memory controller so that we can change the location of VRAM
> within the GPU's address space.  If one of the display controllers memory
> request stop requests takes too long to go through for some reason, it's
> possible that the display hardware may attempt to read from a GPU memory
> location no-longer backed by vram (since we changed the location of vram =
in
> r600_mc_program()) momentarily until the stop request goes through.  Does
> the attached updated version of the patch help?  Alternatively, you can t=
ry
> adding delays to the end of rv515_mc_stop() and see if that helps.
> >
> > Alex
> >
>=20
> This v2 patch didn't help. I added  mdelay(15); at the end of
> rv515_mc_stop() on top of this v2 patch and that fixed the problem.
> mdelay(15) is a bit much I am sure. Shouldn't rv515_mc_wait_for_idle()
> take care of the delay? It waits for idle usec_timeout?


 It only waits that long if the MC never goes idle.  If the MC happens to b=
e idle at the time, it will return immediately.  Does the attached patch fi=
x the issue?  It waits for the update pending bit to clear in addition to w=
aiting for the next frame.

Alex


--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0A3B7sausexdag04amdc_
Content-Type: application/octet-stream;
	name="0001-drm-radeon-fix-MC-blackout-on-r5xx-r7xx-v3.patch"
Content-Description: 0001-drm-radeon-fix-MC-blackout-on-r5xx-r7xx-v3.patch
Content-Disposition: attachment;
	filename="0001-drm-radeon-fix-MC-blackout-on-r5xx-r7xx-v3.patch"; size=2444;
	creation-date="Tue, 29 Jan 2013 21:59:04 GMT";
	modification-date="Tue, 29 Jan 2013 21:58:53 GMT"
Content-Transfer-Encoding: base64

RnJvbSBjMzA0NzFjN2ViNDlkOThmNGMyMjRhMWIzMDYwZjdjYjc3M2U0OTAwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFR1ZSwgMjkgSmFuIDIwMTMgMTY6NTY6MTYgLTA1MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uOiBmaXggTUMgYmxhY2tvdXQgb24gcjV4eC1yN3h4ICh2MykKClNlZW1zIHdl
IG1pc3MgdGhlIHVwZGF0ZSBpbiBjZXJ0YWluIGNvbmRpdGlvbnMuICBXYWl0CmZvciB0aGUgdXBk
YXRlIHBlbmRpbmcgYml0IHRvIGNsZWFyIGluIGFkZGl0aW9uIHRvIHdhaXRpbmcKZm9yIHRoZSBu
ZXh0IGZyYW1lLgoKdjM6IHdhaXQgZm9yIHBlbmRpbmcgYml0IHRvIGNsZWFyIGluIGFkZGl0aW9u
IHRvIHdhaXRpbmcKZm9yIHRoZSBuZXh0IGZyYW1lLgoKUmVwb3J0ZWQtYnk6IFNodWFoIEtoYW4g
PHNodWFoa2hhbkBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IEFsZXggRGV1Y2hlciA8YWxleGFu
ZGVyLmRldWNoZXJAYW1kLmNvbT4KQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKLS0tCiBkcml2
ZXJzL2dwdS9kcm0vcmFkZW9uL3I1MDBfcmVnLmggfCAgICAyICsrCiBkcml2ZXJzL2dwdS9kcm0v
cmFkZW9uL3J2NTE1LmMgICAgfCAgICA2ICsrKystLQogMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3Jh
ZGVvbi9yNTAwX3JlZy5oIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yNTAwX3JlZy5oCmluZGV4
IGVjNTc2YWEuLjRmYmFiZGUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjUw
MF9yZWcuaAorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I1MDBfcmVnLmgKQEAgLTM1OCw2
ICszNTgsOCBAQAogI2RlZmluZSBBVklWT19EMUNSVENfU1RFUkVPX0NPTlRST0wgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIDB4NjBjNAogCiAjZGVmaW5lIEFWSVZPX0QxTU9ERV9NQVNURVJf
VVBEQVRFX01PREUgICAgICAgICAgICAgICAgICAgICAgICAgMHg2MGU0CisjZGVmaW5lIEFWSVZP
X0QxQ1JUQ19VUERBVEVfTE9DSyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMHg2MGU4
CisjZGVmaW5lIEFWSVZPX0QxQ1JUQ19ET1VCTEVfQlVGRkVSX0NPTlRST0wgICAgICAgICAgICAg
ICAgICAgICAgMHg2MGVjCiAKIC8qIG1hc3RlciBjb250cm9scyAqLwogI2RlZmluZSBBVklWT19E
Q19DUlRDX01BU1RFUl9FTiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDB4NjBmOApk
aWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ydjUxNS5jIGIvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9ydjUxNS5jCmluZGV4IDJiYjZkMGUuLjdhMGNlNTMgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvZ3B1L2RybS9yYWRlb24vcnY1MTUuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L3J2NTE1LmMKQEAgLTMwOSw3ICszMDksOCBAQCB2b2lkIHJ2NTE1X21jX3N0b3Aoc3RydWN0IHJh
ZGVvbl9kZXZpY2UgKnJkZXYsIHN0cnVjdCBydjUxNV9tY19zYXZlICpzYXZlKQogCQkJLyogd2Fp
dCBmb3IgdGhlIG5leHQgZnJhbWUgKi8KIAkJCWZyYW1lX2NvdW50ID0gcmFkZW9uX2dldF92Ymxh
bmtfY291bnRlcihyZGV2LCBpKTsKIAkJCWZvciAoaiA9IDA7IGogPCByZGV2LT51c2VjX3RpbWVv
dXQ7IGorKykgewotCQkJCWlmIChyYWRlb25fZ2V0X3ZibGFua19jb3VudGVyKHJkZXYsIGkpICE9
IGZyYW1lX2NvdW50KQorCQkJCWlmICgocmFkZW9uX2dldF92YmxhbmtfY291bnRlcihyZGV2LCBp
KSAhPSBmcmFtZV9jb3VudCkgJiYKKwkJCQkgICAgKCEoUlJFRzMyKEFWSVZPX0QxQ1JUQ19ET1VC
TEVfQlVGRkVSX0NPTlRST0wgKyBjcnRjX29mZnNldHNbaV0pICYgMSkpKQogCQkJCQlicmVhazsK
IAkJCQl1ZGVsYXkoMSk7CiAJCQl9CkBAIC0zODgsNyArMzg5LDggQEAgdm9pZCBydjUxNV9tY19y
ZXN1bWUoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYsIHN0cnVjdCBydjUxNV9tY19zYXZlICpz
YXZlKQogCQkJLyogd2FpdCBmb3IgdGhlIG5leHQgZnJhbWUgKi8KIAkJCWZyYW1lX2NvdW50ID0g
cmFkZW9uX2dldF92YmxhbmtfY291bnRlcihyZGV2LCBpKTsKIAkJCWZvciAoaiA9IDA7IGogPCBy
ZGV2LT51c2VjX3RpbWVvdXQ7IGorKykgewotCQkJCWlmIChyYWRlb25fZ2V0X3ZibGFua19jb3Vu
dGVyKHJkZXYsIGkpICE9IGZyYW1lX2NvdW50KQorCQkJCWlmICgocmFkZW9uX2dldF92Ymxhbmtf
Y291bnRlcihyZGV2LCBpKSAhPSBmcmFtZV9jb3VudCkgJiYKKwkJCQkgICAgKCEoUlJFRzMyKEFW
SVZPX0QxQ1JUQ19ET1VCTEVfQlVGRkVSX0NPTlRST0wgKyBjcnRjX29mZnNldHNbaV0pICYgMSkp
KQogCQkJCQlicmVhazsKIAkJCQl1ZGVsYXkoMSk7CiAJCQl9Ci0tIAoxLjcuNy41Cgo=

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0A3B7sausexdag04amdc_--
