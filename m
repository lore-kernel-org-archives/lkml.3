Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab3AaQG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:06:56 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:15512 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921Ab3AaQGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:06:54 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI9371Ic85fh542I1432I1418Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz8275bhz2dh668h839hd25hf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h34h1155h)
X-WSS-ID: 0MHHZDP-01-6B0-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: Linux 3.8-rc4
Thread-Topic: Linux 3.8-rc4
Thread-Index: AQHN9cxhktnF6ESNpkuAIBoIzsaQJZhQNCEAgACn4tCABRQtgP//oN5AgAB+F4D//6LmYIAAax0AgABUMQCAAH8jgIAAu/gAgAhrfoCAAD7IYIAAyyMA//+iZkAAEN8ZAAAMc2Aw//+/k4CAADBXAP//sg3QgAEm9ICAAF/qMP///jmAgABY5vCAAOKXAIAAZEpw
Date: Thu, 31 Jan 2013 16:05:23 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DF0AF4E@sausexdag04.amd.com>
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
	<A3397C8B8B789E45844E7EC5DEAD89D02DF0A3B7@sausexdag04.amd.com>
	<CAKocOOMxbZXjL_qxQQD+-Z7ocJ1tR7UDEDr+2uSSfjhihik6VA@mail.gmail.com>
	<CAKocOOOHcaYoUQ6Z1yC9T0o9=qaMas3mVzrD8iEnycLJd3nxVQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF0ABD0@sausexdag04.amd.com>
	<CAKocOOMSRZysoKh9Lkgj-3_WsRq9Q6Oo0wJneUStjD+g+WgzAQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF0AC95@sausexdag04.amd.com>
	<CAKocOOPoZ2HqxSz=PB68wpZxd6z8Byv1Yfj3nArt1z+3ViuNNQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF0AF15@sausexdag04.amd.com>
 <CAKocOOMivziOF3ntKiwgH8Pc-d8h5sdykeJS7mKQ6vPe6Y=guA@mail.gmail.com>
In-Reply-To: <CAKocOOMivziOF3ntKiwgH8Pc-d8h5sdykeJS7mKQ6vPe6Y=guA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.15.178]
Content-Type: multipart/mixed;
	boundary="_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0AF4Esausexdag04amdc_"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0AF4Esausexdag04amdc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> Sent: Thursday, January 31, 2013 11:01 AM
> To: Deucher, Alexander
> Cc: Linus Torvalds; Linux Kernel Mailing List
> Subject: Re: Linux 3.8-rc4
>=20
> On Thu, Jan 31, 2013 at 7:56 AM, Deucher, Alexander
> <Alexander.Deucher@amd.com> wrote:
> >> -----Original Message-----
> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> >> Sent: Wednesday, January 30, 2013 4:12 PM
> >> To: Deucher, Alexander
> >> Cc: Linus Torvalds; Linux Kernel Mailing List
> >> Subject: Re: Linux 3.8-rc4
> >>
> >> On Wed, Jan 30, 2013 at 8:53 AM, Deucher, Alexander
> >> <Alexander.Deucher@amd.com> wrote:
> >> >> -----Original Message-----
> >> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> >> >> Sent: Wednesday, January 30, 2013 10:35 AM
> >> >> To: Deucher, Alexander
> >> >> Cc: Linus Torvalds; Linux Kernel Mailing List
> >> >> Subject: Re: Linux 3.8-rc4
> >> >>
> >> >> On Wed, Jan 30, 2013 at 6:31 AM, Deucher, Alexander
> >> >> <Alexander.Deucher@amd.com> wrote:
> >> >>
> >> >> >>
> >> >> >> ok. I did more debugging in rv515_mc_stop() and here is what's
> >> >> >> happening. It has two display controllers and one of them is
> enabled
> >> >> >> and the other is in disabled state when AVIVO_D1CRTC_CONTROL
> is
> >> >> >> checked. The current code doesn't blank the disabled crtc.
> However, it
> >> >> >> needs to be blanked to avoid DMAR faults it appears. I think tha=
t is
> >> >> >> what the original code prior to
> >> >> >> 6253e4c75d96006c06b9ac8f417eba873de2497b commit was doing:
> >> >> >>
> >> >> >> -       WREG32(R_0060E8_D1CRTC_UPDATE_LOCK, 1);
> >> >> >> -       WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 1);
> >> >> >> -       WREG32(R_006080_D1CRTC_CONTROL, 0);
> >> >> >> -       WREG32(R_006880_D2CRTC_CONTROL, 0);
> >> >> >> -       WREG32(R_0060E8_D1CRTC_UPDATE_LOCK, 0);
> >> >> >> -       WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 0);
> >> >> >> -       WREG32(R_000330_D1VGA_CONTROL, 0);
> >> >> >> -       WREG32(R_000338_D2VGA_CONTROL, 0);
> >> >> >>
> >> >> >> Anyways, here is the diff for the change (by no means a patch) I
> made
> >> >> >> that fixed the problem:
> >> >> >
> >> >> > Unfortunately, that just fixes the problem by causing an addition=
al
> delay
> >> >> since the wait_for_vblank() and get_frame_count() loops will timeou=
t
> >> since
> >> >> the secondary display is disabled.  The previous code disabled the
> displays
> >> >> completely while the new code just disables the memory request
> >> interface
> >> >> so that the display timing stays on to avoid additional flicker at =
startup
> or
> >> GPU
> >> >> reset.  For some reason on your system there seems to be a delay in
> >> getting
> >> >> the memory request interface to stop.
> >> >> >
> >> >> > Alex
> >> >>
> >> >> Right. That makes sense and yes the annoying flicker went away. :) =
Can
> >> >> you think of something that can address systems that would need
> more
> >> >> time to get the memory request interface to stop such as mine?
> >> >
> >> > Does adding an additional radeon_mc_wait_for_idle(rdev) call at the
> end
> >> of rv515_mc_stop() help?  Can you find out what the minimum delay
> >> required for your system is?
> >> >
> >> > Alex
> >>
> >> Adding radeon_mc_wait_for_idle(rdev) call at the end of
> >> rv515_mc_stop() - didn't help.
> >>
> >> I tried with adding udelay() with delay values of 1,10, and 50, and
> >> 100 at the end of rv515_mc_stop(). 100 is the minimum that fixed the
> >> DMAR faults.
> >
> > I guess we can just add the delay.  I've tried all the ways I know of t=
o get
> proper feedback from the hardware.
> >
> > Alex
> >
>=20
> Do you want me to send a patch with delay()? Would you like to see the
> delay specific to this chipset which is RV620? That said if you think
> of other ideas to try instead of delay, I can continue the debug and
> testing effort.

I'm planning to merge the attached patch.  I'll let you know if I found out=
 any other things to try.

Alex


--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0AF4Esausexdag04amdc_
Content-Type: application/octet-stream;
	name="0001-drm-radeon-r5xx-r7xx-wait-for-the-MC-to-settle-after.patch"
Content-Description: 0001-drm-radeon-r5xx-r7xx-wait-for-the-MC-to-settle-after.patch
Content-Disposition: attachment;
	filename="0001-drm-radeon-r5xx-r7xx-wait-for-the-MC-to-settle-after.patch";
	size=1010; creation-date="Thu, 31 Jan 2013 16:05:00 GMT";
	modification-date="Thu, 31 Jan 2013 16:04:19 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwMWQwZWM0MWNkZDMwZDljZTA4ZjIyOGY5NTBhNWU5ZGI4Y2YzODZmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFRodSwgMzEgSmFuIDIwMTMgMDk6MDE6NTkgLTA1MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uL3I1eHgtcjd4eDogd2FpdCBmb3IgdGhlIE1DIHRvIHNldHRsZSBhZnRlciBN
QwogYmxhY2tvdXQKClNvbWUgY2hpcHMgc2VlbSB0byBuZWVkIGEgbGl0dGxlIGRlbGF5IGFmdGVy
IGJsYWNraW5nIG91dAp0aGUgTUMgYmVmb3JlIHRoZSByZXF1ZXN0cyBhY3R1YWxseSBzdG9wLgoK
UmVwb3J0ZWQtYnk6IFNodWFoIEtoYW4gPHNodWFoa2hhbkBnbWFpbC5jb20+ClNpZ25lZC1vZmYt
Ynk6IEFsZXggRGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4KLS0tCiBkcml2ZXJz
L2dwdS9kcm0vcmFkZW9uL3J2NTE1LmMgfCAgICAyICsrCiAxIGZpbGVzIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0v
cmFkZW9uL3J2NTE1LmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3J2NTE1LmMKaW5kZXggMmJi
NmQwZS4uNDM1ZWQzNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ydjUxNS5j
CisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnY1MTUuYwpAQCAtMzM2LDYgKzMzNiw4IEBA
IHZvaWQgcnY1MTVfbWNfc3RvcChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldiwgc3RydWN0IHJ2
NTE1X21jX3NhdmUgKnNhdmUpCiAJCQkJV1JFRzMyKFI2MDBfQ0lURl9DTlRMLCBibGFja291dCk7
CiAJCX0KIAl9CisJLyogd2FpdCBmb3IgdGhlIE1DIHRvIHNldHRsZSAqLworCXVkZWxheSgxMDAp
OwogfQogCiB2b2lkIHJ2NTE1X21jX3Jlc3VtZShzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldiwg
c3RydWN0IHJ2NTE1X21jX3NhdmUgKnNhdmUpCi0tIAoxLjcuNy41Cgo=

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0AF4Esausexdag04amdc_--
