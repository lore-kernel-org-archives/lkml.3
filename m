Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3AVSkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:40:53 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:54611
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754321Ab3AVSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:40:51 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371Ic85fh542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz8275bhz2dh668h839hd25hf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh15d0h162dh1631h1758h18e1h34h1155h)
X-WSS-ID: 0MH1IJW-01-6RG-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: Linux 3.8-rc4
Thread-Topic: Linux 3.8-rc4
Thread-Index: AQHN9cxhktnF6ESNpkuAIBoIzsaQJZhQNCEAgACn4tCABRQtgP//oN5AgAB+F4D//6LmYA==
Date: Tue, 22 Jan 2013 18:40:43 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DF084EA@sausexdag04.amd.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
	<CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
	<CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7@sausexdag04.amd.com>
	<CAKocOONuFvcik229+1B0oeaBnQG7seZPeYf99xqduFa6kBZhOw@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF083DE@sausexdag04.amd.com>
 <CAKocOOMxAYw-XO-6XGteKb8NyHDq4_BdZn2njUNBh+a73wrFGA@mail.gmail.com>
In-Reply-To: <CAKocOOMxAYw-XO-6XGteKb8NyHDq4_BdZn2njUNBh+a73wrFGA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.13.168]
Content-Type: multipart/mixed;
	boundary="_002_A3397C8B8B789E45844E7EC5DEAD89D02DF084EAsausexdag04amdc_"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF084EAsausexdag04amdc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> Sent: Tuesday, January 22, 2013 1:06 PM
> To: Deucher, Alexander
> Cc: Linus Torvalds; Linux Kernel Mailing List
> Subject: Re: Linux 3.8-rc4
>=20
> On Tue, Jan 22, 2013 at 9:36 AM, Deucher, Alexander
> <Alexander.Deucher@amd.com> wrote:
> >> -----Original Message-----
> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> >> Sent: Tuesday, January 22, 2013 11:15 AM
> >> To: Deucher, Alexander
> >> Cc: Linus Torvalds; Linux Kernel Mailing List
> >> Subject: Re: Linux 3.8-rc4
> >>
> >> On Sat, Jan 19, 2013 at 9:44 AM, Deucher, Alexander
> >> <Alexander.Deucher@amd.com> wrote:
> >> >> -----Original Message-----
> >> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> >> >> Sent: Friday, January 18, 2013 7:40 PM
> >> >> To: Linus Torvalds; Deucher, Alexander
> >> >> Cc: Linux Kernel Mailing List
> >> >> Subject: Re: Linux 3.8-rc4
> >> >>
> >> >> On Fri, Jan 18, 2013 at 3:37 PM, Shuah Khan <shuahkhan@gmail.com>
> >> wrote:
> >> >> > On Fri, Jan 18, 2013 at 10:51 AM, Shuah Khan
> <shuahkhan@gmail.com>
> >> >> wrote:
> >> >>
> >> >> >
> >> >> > ok. I bisected the DMAR faults and it points to the following com=
mit:
> >> >> >
> >> >> > 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb
> >> >> >
> >> >> > This commit as I recall, fixed the crash problem I was seeing bac=
k in
> >> >> > 3.8-rc1. Reverting to see if crash problem reappears.
> >> >>
> >> >> Confirming that with this commit reverted crash problem re-appeared=
.
> >> >> With this commit, DMAR faults show up.
> >> >
> >> > I'm not quite sure what's going on with your system.   At this point=
 it's
> >> probably best to just disable the DMA ring on these cards until we sor=
t out
> >> what's going on.  The attached patch disables the use of the DMA ring.
> Let
> >> me know if it fixes the issues you are seeing.
> >> >
> >>
> >> I applied this patch to 3.8-rc4 and didn't fix the DMAR faults.
> >
> > Are you getting continuous DMAR faults or just when while the module is
> being loaded?
> >
> > Alex
>=20
> During module initialization, I think might be actually right after
> RV620 Microcode loading attempt: dmesg excerpts starting from radeoan
> init:

Does the attached patch stop them?  It basically skips all initialization o=
f the DMA ring on your system.  What I don't understand is why you still ge=
t them with the previous patch, but not with 909d9eb67f1e4e39f2ea88e96bde03=
d560cde3eb reverted.  909d9eb67f1e4e39f2ea88e96bde03d560cde3eb only affects=
 the use of the DMA ring for buffer migration and the patch I previously at=
tached disables the use of the DMA ring for buffer migration.  Does the lat=
est batch of drm-fixes from Dave that Linus just merged help?

Alex

>=20
> [   22.150520] [drm] radeon defaulting to kernel modesetting.
> [   22.150524] [drm] radeon kernel modesetting enabled.
> [   22.150793] [drm] initializing kernel modesetting (RV620 0x1002:0x95C4
> 0x103C
> :0x30DC).
> [   22.150815] [drm] register mmio base: 0x90300000
> [   22.150817] [drm] register mmio size: 65536
> [   22.150918] ATOM BIOS: HP
> [   22.150941] radeon 0000:01:00.0: VRAM: 128M 0x0000000000000000 -
> 0x0000000007
> FFFFFF (128M used)
> [   22.150943] radeon 0000:01:00.0: GTT: 512M 0x0000000008000000 -
> 0x0000000027F
> FFFFF
> [   22.153790] [drm] Detected VRAM RAM=3D128M, BAR=3D128M
> [   22.153793] [drm] RAM width 64bits DDR
> [   22.153850] [TTM] Zone  kernel: Available graphics memory: 989986 kiB
> [   22.153852] [TTM] Initializing pool allocator
> [   22.153857] [TTM] Initializing DMA pool allocator
> [   22.153884] [drm] radeon: 128M of VRAM memory ready
> [   22.153885] [drm] radeon: 512M of GTT memory ready.
> [   22.153902] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010)=
.
> [   22.153903] [drm] Driver supports precise vblank timestamp query.
> [   22.153947] radeon 0000:01:00.0: irq 51 for MSI/MSI-X
> [   22.153958] radeon 0000:01:00.0: radeon: using MSI.
> [   22.153988] [drm] radeon: irq initialized.
> [   22.154034] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [   22.154796] [drm] probing gen 2 caps for device 8086:2a41 =3D 1/0
>=20
> [   22.154969] [drm] Loading RV620 Microcode
>=20
> [   22.218044] dmar: DRHD: handling fault status reg 3
> [   22.218054] dmar: DMAR:[DMA Read] Request device [01:00.0] fault
> addr 80000000
> [   22.218054] DMAR:[fault reason 06] PTE Read access is not set
> [   22.218083] dmar: DRHD: handling fault status reg 3
> [   22.218089] dmar: DMAR:[DMA Read] Request device [01:00.0] fault
> addr 80002000
> [   22.218089] DMAR:[fault reason 06] PTE Read access is not set
> [   22.218123] dmar: DRHD: handling fault status reg 3
> [   22.218128] dmar: DMAR:[DMA Read] Request device [01:00.0] fault
> addr 80004000
> [   22.218128] DMAR:[fault reason 06] PTE Read access is not set
> [   22.218155] dmar: DRHD: handling fault status reg 3
> [   22.218159] dmar: DMAR:[DMA Read] Request device [01:00.0] fault
> addr 80006000
> [   22.218159] DMAR:[fault reason 06] PTE Read access is not set
> [   22.218169] dmar: DRHD: handling fault status reg 3
> [   22.218173] dmar: DMAR:[DMA Read] Request device [01:00.0] fault
> addr 80007000
> [   22.218173] DMAR:[fault reason 06] PTE Read access is not set
> [   22.218191] dmar: DRHD: handling fault status reg 3
>=20
> tons of these and then:
>=20
>=20
> [   22.236419] [drm] PCIE GART of 512M enabled (table at
> 0x0000000000040000).
> [   22.236479] radeon 0000:01:00.0: WB enabled
> [   22.236483] radeon 0000:01:00.0: fence driver on ring 0 use gpu
> addr 0x0000000008
> 000c00 and cpu addr 0xffff88002f436c00
> [   22.236485] radeon 0000:01:00.0: fence driver on ring 3 use gpu
> addr 0x0000000008
> 000c0c and cpu addr 0xffff88002f436c0c
> [   22.270041] [drm] ring test on 0 succeeded in 1 usecs
> [   22.270099] [drm] ring test on 3 succeeded in 1 usecs
> [   22.272156] [drm] ib test on ring 0 succeeded in 0 usecs
> [   22.272170] [drm] ib test on ring 3 succeeded in 0 usecs
> [   22.272705] [drm] radeon atom DIG backlight initialized
> [   22.272707] [drm] Radeon Display Connectors
> [   22.272708] [drm] Connector 0:
> [   22.272710] [drm]   LVDS-1
> [   22.272711] [drm]   Encoders:
> [   22.272712] [drm]     LCD1: INTERNAL_KLDSCP_LVTMA
> [   22.272713] [drm] Connector 1:
> [   22.272714] [drm]   VGA-1
> [   22.272716] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48
> 0x7e4c 0x7e4c
> [   22.272717] [drm]   Encoders:
> [   22.272718] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> [   22.272719] [drm] Connector 2:
> [   22.272720] [drm]   DVI-D-1
> [   22.272721] [drm]   HPD1
> [   22.272723] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68
> 0x7e6c 0x7e6c
> [   22.272724] [drm]   Encoders:
> [   22.272725] [drm]     DFP1: INTERNAL_UNIPHY
> [   22.272758] [drm] radeon: power management initialized
> [   23.232093] fbcon: radeondrmfb (fb0) is primary device
> [   23.496217] Console: switching to colour frame buffer device 180x56
> [   23.499083] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
> [   23.499085] radeon 0000:01:00.0: registered panic notifier
> [   23.499100] [drm] Initialized radeon 2.28.0 20080528 for
> 0000:01:00.0 on minor 0
>=20
>=20
> Attaching entire dmesg as well:
>=20
> -- Shuah

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF084EAsausexdag04amdc_
Content-Type: application/octet-stream;
	name="disable_dma_ring_on_6xx-2.diff"
Content-Description: disable_dma_ring_on_6xx-2.diff
Content-Disposition: attachment; filename="disable_dma_ring_on_6xx-2.diff";
	size=3841; creation-date="Tue, 22 Jan 2013 18:39:01 GMT";
	modification-date="Tue, 22 Jan 2013 18:38:44 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjYwMC5jIGIvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9yNjAwLmMKaW5kZXggMDRmMzc0NS4uNzU2MjVmNiAxMDA2NDQKLS0tIGEvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9yNjAwLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9y
NjAwLmMKQEAgLTI5MDAsMTEgKzI5MDAsMTMgQEAgc3RhdGljIGludCByNjAwX3N0YXJ0dXAoc3Ry
dWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpCiAJCXJldHVybiByOwogCX0KIAorI2lmIDAKIAlyID0g
cmFkZW9uX2ZlbmNlX2RyaXZlcl9zdGFydF9yaW5nKHJkZXYsIFI2MDBfUklOR19UWVBFX0RNQV9J
TkRFWCk7CiAJaWYgKHIpIHsKIAkJZGV2X2VycihyZGV2LT5kZXYsICJmYWlsZWQgaW5pdGlhbGl6
aW5nIERNQSBmZW5jZXMgKCVkKS5cbiIsIHIpOwogCQlyZXR1cm4gcjsKIAl9CisjZW5kaWYKIAog
CS8qIEVuYWJsZSBJUlEgKi8KIAlyID0gcjYwMF9pcnFfaW5pdChyZGV2KTsKQEAgLTI5MjIsMTIg
KzI5MjQsMTQgQEAgc3RhdGljIGludCByNjAwX3N0YXJ0dXAoc3RydWN0IHJhZGVvbl9kZXZpY2Ug
KnJkZXYpCiAJaWYgKHIpCiAJCXJldHVybiByOwogCisjaWYgMAogCXJpbmcgPSAmcmRldi0+cmlu
Z1tSNjAwX1JJTkdfVFlQRV9ETUFfSU5ERVhdOwogCXIgPSByYWRlb25fcmluZ19pbml0KHJkZXYs
IHJpbmcsIHJpbmctPnJpbmdfc2l6ZSwgUjYwMF9XQl9ETUFfUlBUUl9PRkZTRVQsCiAJCQkgICAg
IERNQV9SQl9SUFRSLCBETUFfUkJfV1BUUiwKIAkJCSAgICAgMiwgMHgzZmZmYywgRE1BX1BBQ0tF
VChETUFfUEFDS0VUX05PUCwgMCwgMCwgMCkpOwogCWlmIChyKQogCQlyZXR1cm4gcjsKKyNlbmRp
ZgogCiAJciA9IHI2MDBfY3BfbG9hZF9taWNyb2NvZGUocmRldik7CiAJaWYgKHIpCkBAIC0yOTM2
LDkgKzI5NDAsMTEgQEAgc3RhdGljIGludCByNjAwX3N0YXJ0dXAoc3RydWN0IHJhZGVvbl9kZXZp
Y2UgKnJkZXYpCiAJaWYgKHIpCiAJCXJldHVybiByOwogCisjaWYgMAogCXIgPSByNjAwX2RtYV9y
ZXN1bWUocmRldik7CiAJaWYgKHIpCiAJCXJldHVybiByOworI2VuZGlmCiAKIAlyID0gcmFkZW9u
X2liX3Bvb2xfaW5pdChyZGV2KTsKIAlpZiAocikgewpAQCAtMjk5NSw3ICszMDAxLDkgQEAgaW50
IHI2MDBfc3VzcGVuZChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikKIHsKIAlyNjAwX2F1ZGlv
X2ZpbmkocmRldik7CiAJcjYwMF9jcF9zdG9wKHJkZXYpOworI2lmIDAKIAlyNjAwX2RtYV9zdG9w
KHJkZXYpOworI2VuZGlmCiAJcjYwMF9pcnFfc3VzcGVuZChyZGV2KTsKIAlyYWRlb25fd2JfZGlz
YWJsZShyZGV2KTsKIAlyNjAwX3BjaWVfZ2FydF9kaXNhYmxlKHJkZXYpOwpAQCAtMzA2OCw4ICsz
MDc2LDEwIEBAIGludCByNjAwX2luaXQoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpCiAJcmRl
di0+cmluZ1tSQURFT05fUklOR19UWVBFX0dGWF9JTkRFWF0ucmluZ19vYmogPSBOVUxMOwogCXI2
MDBfcmluZ19pbml0KHJkZXYsICZyZGV2LT5yaW5nW1JBREVPTl9SSU5HX1RZUEVfR0ZYX0lOREVY
XSwgMTAyNCAqIDEwMjQpOwogCisjaWYgMAogCXJkZXYtPnJpbmdbUjYwMF9SSU5HX1RZUEVfRE1B
X0lOREVYXS5yaW5nX29iaiA9IE5VTEw7CiAJcjYwMF9yaW5nX2luaXQocmRldiwgJnJkZXYtPnJp
bmdbUjYwMF9SSU5HX1RZUEVfRE1BX0lOREVYXSwgNjQgKiAxMDI0KTsKKyNlbmRpZgogCiAJcmRl
di0+aWgucmluZ19vYmogPSBOVUxMOwogCXI2MDBfaWhfcmluZ19pbml0KHJkZXYsIDY0ICogMTAy
NCk7CkBAIC0zMDgzLDcgKzMwOTMsOSBAQCBpbnQgcjYwMF9pbml0KHN0cnVjdCByYWRlb25fZGV2
aWNlICpyZGV2KQogCWlmIChyKSB7CiAJCWRldl9lcnIocmRldi0+ZGV2LCAiZGlzYWJsaW5nIEdQ
VSBhY2NlbGVyYXRpb25cbiIpOwogCQlyNjAwX2NwX2ZpbmkocmRldik7CisjaWYgMAogCQlyNjAw
X2RtYV9maW5pKHJkZXYpOworI2VuZGlmCiAJCXI2MDBfaXJxX2ZpbmkocmRldik7CiAJCXJhZGVv
bl93Yl9maW5pKHJkZXYpOwogCQlyYWRlb25faWJfcG9vbF9maW5pKHJkZXYpOwpAQCAtMzEwMCw3
ICszMTEyLDkgQEAgdm9pZCByNjAwX2Zpbmkoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpCiAJ
cjYwMF9hdWRpb19maW5pKHJkZXYpOwogCXI2MDBfYmxpdF9maW5pKHJkZXYpOwogCXI2MDBfY3Bf
ZmluaShyZGV2KTsKKyNpZiAwCiAJcjYwMF9kbWFfZmluaShyZGV2KTsKKyNlbmRpZgogCXI2MDBf
aXJxX2ZpbmkocmRldik7CiAJcmFkZW9uX3diX2ZpbmkocmRldik7CiAJcmFkZW9uX2liX3Bvb2xf
ZmluaShyZGV2KTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2Fz
aWMuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2FzaWMuYwppbmRleCA5MDU2ZmFm
Li5iMGNjNDZkIDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9hc2lj
LmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fYXNpYy5jCkBAIC05NzQsOCAr
OTc0LDggQEAgc3RhdGljIHN0cnVjdCByYWRlb25fYXNpYyByNjAwX2FzaWMgPSB7CiAJCS5ibGl0
X3JpbmdfaW5kZXggPSBSQURFT05fUklOR19UWVBFX0dGWF9JTkRFWCwKIAkJLmRtYSA9ICZyNjAw
X2NvcHlfZG1hLAogCQkuZG1hX3JpbmdfaW5kZXggPSBSNjAwX1JJTkdfVFlQRV9ETUFfSU5ERVgs
Ci0JCS5jb3B5ID0gJnI2MDBfY29weV9kbWEsCi0JCS5jb3B5X3JpbmdfaW5kZXggPSBSNjAwX1JJ
TkdfVFlQRV9ETUFfSU5ERVgsCisJCS5jb3B5ID0gJnI2MDBfY29weV9ibGl0LAorCQkuY29weV9y
aW5nX2luZGV4ID0gUkFERU9OX1JJTkdfVFlQRV9HRlhfSU5ERVgsCiAJfSwKIAkuc3VyZmFjZSA9
IHsKIAkJLnNldF9yZWcgPSByNjAwX3NldF9zdXJmYWNlX3JlZywKQEAgLTEwNTgsOCArMTA1OCw4
IEBAIHN0YXRpYyBzdHJ1Y3QgcmFkZW9uX2FzaWMgcnM3ODBfYXNpYyA9IHsKIAkJLmJsaXRfcmlu
Z19pbmRleCA9IFJBREVPTl9SSU5HX1RZUEVfR0ZYX0lOREVYLAogCQkuZG1hID0gJnI2MDBfY29w
eV9kbWEsCiAJCS5kbWFfcmluZ19pbmRleCA9IFI2MDBfUklOR19UWVBFX0RNQV9JTkRFWCwKLQkJ
LmNvcHkgPSAmcjYwMF9jb3B5X2RtYSwKLQkJLmNvcHlfcmluZ19pbmRleCA9IFI2MDBfUklOR19U
WVBFX0RNQV9JTkRFWCwKKwkJLmNvcHkgPSAmcjYwMF9jb3B5X2JsaXQsCisJCS5jb3B5X3Jpbmdf
aW5kZXggPSBSQURFT05fUklOR19UWVBFX0dGWF9JTkRFWCwKIAl9LAogCS5zdXJmYWNlID0gewog
CQkuc2V0X3JlZyA9IHI2MDBfc2V0X3N1cmZhY2VfcmVnLApkaWZmIC0tZ2l0IGEvZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9yYWRlb25fY3MuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9u
X2NzLmMKaW5kZXggMzEyY2Q5MS4uYTQzNjRlNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJt
L3JhZGVvbi9yYWRlb25fY3MuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9j
cy5jCkBAIC0xMTUsNyArMTE1LDcgQEAgc3RhdGljIGludCByYWRlb25fY3NfZ2V0X3Jpbmcoc3Ry
dWN0IHJhZGVvbl9jc19wYXJzZXIgKnAsIHUzMiByaW5nLCBzMzIgcHJpb3JpdHkKIAkJCQlwLT5y
aW5nID0gUjYwMF9SSU5HX1RZUEVfRE1BX0lOREVYOwogCQkJZWxzZQogCQkJCXAtPnJpbmcgPSBD
QVlNQU5fUklOR19UWVBFX0RNQTFfSU5ERVg7Ci0JCX0gZWxzZSBpZiAocC0+cmRldi0+ZmFtaWx5
ID49IENISVBfUjYwMCkgeworCQl9IGVsc2UgaWYgKHAtPnJkZXYtPmZhbWlseSA+PSBDSElQX1JW
NzcwKSB7CiAJCQlwLT5yaW5nID0gUjYwMF9SSU5HX1RZUEVfRE1BX0lOREVYOwogCQl9IGVsc2Ug
ewogCQkJcmV0dXJuIC1FSU5WQUw7Cg==

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF084EAsausexdag04amdc_--
