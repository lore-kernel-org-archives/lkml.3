Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3A3PyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:54:07 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:27536 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733Ab3A3PyG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:54:06 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI9371I542I1432I1418Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz8275bhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h1155h)
X-WSS-ID: 0MHG45Y-01-3CU-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: Linux 3.8-rc4
Thread-Topic: Linux 3.8-rc4
Thread-Index: AQHN9cxhktnF6ESNpkuAIBoIzsaQJZhQNCEAgACn4tCABRQtgP//oN5AgAB+F4D//6LmYIAAax0AgABUMQCAAH8jgIAAu/gAgAhrfoCAAD7IYIAAyyMA//+iZkAAEN8ZAAAMc2Aw//+/k4CAADBXAP//sg3QgAEm9ICAAF/qMA==
Date: Wed, 30 Jan 2013 15:53:58 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DF0AC95@sausexdag04.amd.com>
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
In-Reply-To: <CAKocOOMSRZysoKh9Lkgj-3_WsRq9Q6Oo0wJneUStjD+g+WgzAQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.15.197]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> Sent: Wednesday, January 30, 2013 10:35 AM
> To: Deucher, Alexander
> Cc: Linus Torvalds; Linux Kernel Mailing List
> Subject: Re: Linux 3.8-rc4
> 
> On Wed, Jan 30, 2013 at 6:31 AM, Deucher, Alexander
> <Alexander.Deucher@amd.com> wrote:
> 
> >>
> >> ok. I did more debugging in rv515_mc_stop() and here is what's
> >> happening. It has two display controllers and one of them is enabled
> >> and the other is in disabled state when AVIVO_D1CRTC_CONTROL is
> >> checked. The current code doesn't blank the disabled crtc. However, it
> >> needs to be blanked to avoid DMAR faults it appears. I think that is
> >> what the original code prior to
> >> 6253e4c75d96006c06b9ac8f417eba873de2497b commit was doing:
> >>
> >> -       WREG32(R_0060E8_D1CRTC_UPDATE_LOCK, 1);
> >> -       WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 1);
> >> -       WREG32(R_006080_D1CRTC_CONTROL, 0);
> >> -       WREG32(R_006880_D2CRTC_CONTROL, 0);
> >> -       WREG32(R_0060E8_D1CRTC_UPDATE_LOCK, 0);
> >> -       WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 0);
> >> -       WREG32(R_000330_D1VGA_CONTROL, 0);
> >> -       WREG32(R_000338_D2VGA_CONTROL, 0);
> >>
> >> Anyways, here is the diff for the change (by no means a patch) I made
> >> that fixed the problem:
> >
> > Unfortunately, that just fixes the problem by causing an additional delay
> since the wait_for_vblank() and get_frame_count() loops will timeout since
> the secondary display is disabled.  The previous code disabled the displays
> completely while the new code just disables the memory request interface
> so that the display timing stays on to avoid additional flicker at startup or GPU
> reset.  For some reason on your system there seems to be a delay in getting
> the memory request interface to stop.
> >
> > Alex
> 
> Right. That makes sense and yes the annoying flicker went away. :) Can
> you think of something that can address systems that would need more
> time to get the memory request interface to stop such as mine?

Does adding an additional radeon_mc_wait_for_idle(rdev) call at the end of rv515_mc_stop() help?  Can you find out what the minimum delay required for your system is?

Alex


