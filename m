Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3A2NFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:05:52 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:29073
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457Ab3A2NFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:05:49 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz98dI9371I15bfKc85fh542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz17326ah8275dh8275bhz2dh668h839hd25hf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh15d0h162dh1631h1758h18e1h34h1155h)
X-WSS-ID: 0MHE1PG-02-CI8-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: Linux 3.8-rc4
Thread-Topic: Linux 3.8-rc4
Thread-Index: AQHN9cxhktnF6ESNpkuAIBoIzsaQJZhQNCEAgACn4tCABRQtgP//oN5AgAB+F4D//6LmYIAAax0AgABUMQCAAH8jgIAAu/gAgAhrfoCAAD7IYA==
Date: Tue, 29 Jan 2013 13:05:40 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DF0A266@sausexdag04.amd.com>
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
In-Reply-To: <CAKocOONFpPBQH=naKdmrXa1ijpzf=0jonKuUWbw3NhEeumfM=A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.8.62]
Content-Type: multipart/mixed;
	boundary="_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0A266sausexdag04amdc_"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0A266sausexdag04amdc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> Sent: Monday, January 28, 2013 10:20 PM
> To: Deucher, Alexander
> Cc: Linus Torvalds; Linux Kernel Mailing List
> Subject: Re: Linux 3.8-rc4
>=20
> On Wed, Jan 23, 2013 at 11:44 AM, Shuah Khan <shuahkhan@gmail.com>
> wrote:
> > On Wed, Jan 23, 2013 at 6:40 AM, Deucher, Alexander
> > <Alexander.Deucher@amd.com> wrote:
> >>> -----Original Message-----
> >>> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> >>> Sent: Tuesday, January 22, 2013 6:57 PM
> >>> To: Deucher, Alexander
> >>> Cc: Linus Torvalds; Linux Kernel Mailing List
> >>> Subject: Re: Linux 3.8-rc4
> >>>
> >>> On Tue, Jan 22, 2013 at 11:55 AM, Shuah Khan <shuahkhan@gmail.com>
> >>> wrote:
> >>>
> >>> >>> init:
> >>> >>
> >>> >> Does the attached patch stop them?  It basically skips all initial=
ization
> of
> >>> the DMA ring on your system.  What I don't understand is why you stil=
l
> get
> >>> them with the previous patch, but not with
> >>> 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb reverted.
> >>> 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb only affects the use of
> the
> >>> DMA ring for buffer migration and the patch I previously attached
> disables
> >>> the use of the DMA ring for buffer migration.  Does the latest batch =
of
> drm-
> >>> fixes from Dave that Linus just merged help?
> >>> >>
> >>> >> Alex
> >>> >
> >>> > Will try your latest patch. Will also try the latest git - I am
> >>> > currently on Jan 17th. However, in the meantime, I found that these
> >>> > messages might not be new and getting printed now with the
> >>> > eaaa6983ab2ccdf826c90838eb584211e0cadb76 [PATCH] drm/radeon:
> print
> >>> dma
> >>> > status reg on lockup (v2) commit that introduced debug messages in
> >>> > r600_gpu_soft_reset(). I couldn't revert this commit, but doing a
> >>> > compile with these messages commented out. Will update you on the
> >>> > results and then test the new git
> >>> >
> >>> > -- Shuah
> >>>
> >>> Here is what I tried:
> >>>
> >>> 1. Applied your latest disable_dma_ring_on_6xx-2.diff and still see
> >>> messages.
> >>
> >> If that is the case, I'm beginning to think the bug is elsewhere.  Sup=
port
> for the DMA ring was the only major feature we added in this cycle.  If y=
ou
> are still getting errors even with the ring completely disabled, it's pro=
bably
> not the DMA ring.
> >>
> >> Make sure your kernel has this patch:
> >>
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommit=
diff;h=3D2
> 0707874fd4fd37e09513f508e642fa8bd06365a
> >> That's the only thing I can think of that may cause the DMAR errors if=
 the
> DMA ring is disabled.
> >>
> >
> > I verified I have this commit. ok maybe the bug is elsewhere. So far
> > all my bisects are on drivers/gpu/drm/radeon - I am going go one more
> > level up and start at drivers/gpu/drm and see what I can isolate it
> > that way. I do know that I don't see this problem on 3.7.4
> >
> > -- Shuah
>=20
> Alex,
>=20
> I was out sick for a few days and finally picked this bisect backup
> again. I started at 3.7 tag instead of 3.8-rc1 that I did in the past
> and also did bisect at drivers/gpu/drm/radeon instead. Here are the
> results:
>=20
> 6253e4c75d96006c06b9ac8f417eba873de2497b is the first bad commit
> commit 6253e4c75d96006c06b9ac8f417eba873de2497b
> Author: Alex Deucher <alexander.deucher@amd.com>
> Date:   Wed Dec 12 14:30:32 2012 -0500
>=20
>     drm/radeon: improve mc_stop/mc_resume on r5xx-r7xx
>=20
>     Along the same lines of what was done for evergreen+
>     in the last kernel.
>=20
>     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>=20
> git bisect log attached.
>=20

Try the attached patch.  I think it should fix the issue.  I just applied a=
 similar patch for newer asics.

Alex


--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0A266sausexdag04amdc_
Content-Type: application/octet-stream;
	name="0001-drm-radeon-fix-MC-blackout-on-r5xx-r7xx.patch"
Content-Description: 0001-drm-radeon-fix-MC-blackout-on-r5xx-r7xx.patch
Content-Disposition: attachment;
	filename="0001-drm-radeon-fix-MC-blackout-on-r5xx-r7xx.patch"; size=2469;
	creation-date="Tue, 29 Jan 2013 13:04:19 GMT";
	modification-date="Tue, 29 Jan 2013 13:02:27 GMT"
Content-Transfer-Encoding: base64

RnJvbSA5MDg1Zjc4ZDI4OWJjNzVkNjkxNjJiNDAyZDcxNWQzMmRhNDAzMDgwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFR1ZSwgMjkgSmFuIDIwMTMgMDc6NTk6MDcgLTA1MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uOiBmaXggTUMgYmxhY2tvdXQgb24gcjV4eC1yN3h4CgpGb3JjZSB0aGUgY3J0
YyBtZW0gcmVxdWVzdHMgb24vb2ZmIGltbWVkaWF0ZWx5IHJhdGhlcgp0aGFuIHdhaXRpbmcgZm9y
IHRoZSBkb3VibGUgYnVmZmVyZWQgdXBkYXRlcyB0byBraWNrIGluLgpTZWVtcyB3ZSBtaXNzIHRo
ZSB1cGRhdGUgaW4gY2VydGFpbiBjb25kaXRpb25zLiBCYXNlZCBvbgphIHNpbWlsYXIgZml4IGZv
ciBldmVyZ3JlZW4uCgpSZXBvcnRlZC1ieTogU2h1YWggS2hhbiA8c2h1YWhraGFuQGdtYWlsLmNv
bT4KU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4YW5kZXIuZGV1Y2hlckBhbWQuY29t
PgpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwotLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24v
cjUwMF9yZWcuaCB8ICAgIDEgKwogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ydjUxNS5jICAgIHwg
ICAgNCArKysrCiAyIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I1MDBfcmVnLmggYi9kcml2
ZXJzL2dwdS9kcm0vcmFkZW9uL3I1MDBfcmVnLmgKaW5kZXggZWM1NzZhYS4uNTE1OWYwZCAxMDA2
NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yNTAwX3JlZy5oCisrKyBiL2RyaXZlcnMv
Z3B1L2RybS9yYWRlb24vcjUwMF9yZWcuaApAQCAtMzU4LDYgKzM1OCw3IEBACiAjZGVmaW5lIEFW
SVZPX0QxQ1JUQ19TVEVSRU9fQ09OVFJPTCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMHg2
MGM0CiAKICNkZWZpbmUgQVZJVk9fRDFNT0RFX01BU1RFUl9VUERBVEVfTU9ERSAgICAgICAgICAg
ICAgICAgICAgICAgICAweDYwZTQKKyNkZWZpbmUgQVZJVk9fRDFDUlRDX1VQREFURV9MT0NLICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAweDYwZTgKIAogLyogbWFzdGVyIGNvbnRyb2xz
ICovCiAjZGVmaW5lIEFWSVZPX0RDX0NSVENfTUFTVEVSX0VOICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgMHg2MGY4CmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3J2
NTE1LmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3J2NTE1LmMKaW5kZXggMmJiNmQwZS4uYTUy
OTBiMiAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ydjUxNS5jCisrKyBiL2Ry
aXZlcnMvZ3B1L2RybS9yYWRlb24vcnY1MTUuYwpAQCAtMzA0LDcgKzMwNCw5IEBAIHZvaWQgcnY1
MTVfbWNfc3RvcChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldiwgc3RydWN0IHJ2NTE1X21jX3Nh
dmUgKnNhdmUpCiAJCQlpZiAoISh0bXAgJiBBVklWT19DUlRDX0RJU1BfUkVBRF9SRVFVRVNUX0RJ
U0FCTEUpKSB7CiAJCQkJcmFkZW9uX3dhaXRfZm9yX3ZibGFuayhyZGV2LCBpKTsKIAkJCQl0bXAg
fD0gQVZJVk9fQ1JUQ19ESVNQX1JFQURfUkVRVUVTVF9ESVNBQkxFOworCQkJCVdSRUczMihBVklW
T19EMUNSVENfVVBEQVRFX0xPQ0sgKyBjcnRjX29mZnNldHNbaV0sIDEpOwogCQkJCVdSRUczMihB
VklWT19EMUNSVENfQ09OVFJPTCArIGNydGNfb2Zmc2V0c1tpXSwgdG1wKTsKKwkJCQlXUkVHMzIo
QVZJVk9fRDFDUlRDX1VQREFURV9MT0NLICsgY3J0Y19vZmZzZXRzW2ldLCAwKTsKIAkJCX0KIAkJ
CS8qIHdhaXQgZm9yIHRoZSBuZXh0IGZyYW1lICovCiAJCQlmcmFtZV9jb3VudCA9IHJhZGVvbl9n
ZXRfdmJsYW5rX2NvdW50ZXIocmRldiwgaSk7CkBAIC0zODQsNyArMzg2LDkgQEAgdm9pZCBydjUx
NV9tY19yZXN1bWUoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYsIHN0cnVjdCBydjUxNV9tY19z
YXZlICpzYXZlKQogCQlpZiAoc2F2ZS0+Y3J0Y19lbmFibGVkW2ldKSB7CiAJCQl0bXAgPSBSUkVH
MzIoQVZJVk9fRDFDUlRDX0NPTlRST0wgKyBjcnRjX29mZnNldHNbaV0pOwogCQkJdG1wICY9IH5B
VklWT19DUlRDX0RJU1BfUkVBRF9SRVFVRVNUX0RJU0FCTEU7CisJCQlXUkVHMzIoQVZJVk9fRDFD
UlRDX1VQREFURV9MT0NLICsgY3J0Y19vZmZzZXRzW2ldLCAxKTsKIAkJCVdSRUczMihBVklWT19E
MUNSVENfQ09OVFJPTCArIGNydGNfb2Zmc2V0c1tpXSwgdG1wKTsKKwkJCVdSRUczMihBVklWT19E
MUNSVENfVVBEQVRFX0xPQ0sgKyBjcnRjX29mZnNldHNbaV0sIDApOwogCQkJLyogd2FpdCBmb3Ig
dGhlIG5leHQgZnJhbWUgKi8KIAkJCWZyYW1lX2NvdW50ID0gcmFkZW9uX2dldF92YmxhbmtfY291
bnRlcihyZGV2LCBpKTsKIAkJCWZvciAoaiA9IDA7IGogPCByZGV2LT51c2VjX3RpbWVvdXQ7IGor
KykgewotLSAKMS43LjcuNQoK

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0A266sausexdag04amdc_--
