Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3AVQgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:36:48 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:14832 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539Ab3AVQgq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:36:46 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz8275bhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1155h)
X-WSS-ID: 0MH1CT0-01-6KE-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: Linux 3.8-rc4
Thread-Topic: Linux 3.8-rc4
Thread-Index: AQHN9cxhktnF6ESNpkuAIBoIzsaQJZhQNCEAgACn4tCABRQtgP//oN5A
Date: Tue, 22 Jan 2013 16:36:35 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DF083DE@sausexdag04.amd.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
	<CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
	<CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7@sausexdag04.amd.com>
 <CAKocOONuFvcik229+1B0oeaBnQG7seZPeYf99xqduFa6kBZhOw@mail.gmail.com>
In-Reply-To: <CAKocOONuFvcik229+1B0oeaBnQG7seZPeYf99xqduFa6kBZhOw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.13.168]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> Sent: Tuesday, January 22, 2013 11:15 AM
> To: Deucher, Alexander
> Cc: Linus Torvalds; Linux Kernel Mailing List
> Subject: Re: Linux 3.8-rc4
> 
> On Sat, Jan 19, 2013 at 9:44 AM, Deucher, Alexander
> <Alexander.Deucher@amd.com> wrote:
> >> -----Original Message-----
> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> >> Sent: Friday, January 18, 2013 7:40 PM
> >> To: Linus Torvalds; Deucher, Alexander
> >> Cc: Linux Kernel Mailing List
> >> Subject: Re: Linux 3.8-rc4
> >>
> >> On Fri, Jan 18, 2013 at 3:37 PM, Shuah Khan <shuahkhan@gmail.com>
> wrote:
> >> > On Fri, Jan 18, 2013 at 10:51 AM, Shuah Khan <shuahkhan@gmail.com>
> >> wrote:
> >>
> >> >
> >> > ok. I bisected the DMAR faults and it points to the following commit:
> >> >
> >> > 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb
> >> >
> >> > This commit as I recall, fixed the crash problem I was seeing back in
> >> > 3.8-rc1. Reverting to see if crash problem reappears.
> >>
> >> Confirming that with this commit reverted crash problem re-appeared.
> >> With this commit, DMAR faults show up.
> >
> > I'm not quite sure what's going on with your system.   At this point it's
> probably best to just disable the DMA ring on these cards until we sort out
> what's going on.  The attached patch disables the use of the DMA ring.  Let
> me know if it fixes the issues you are seeing.
> >
> 
> I applied this patch to 3.8-rc4 and didn't fix the DMAR faults.

Are you getting continuous DMAR faults or just when while the module is being loaded?

Alex



