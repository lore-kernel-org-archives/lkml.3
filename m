Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3GAM4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:56:24 -0400
Received: from [207.46.163.26] ([207.46.163.26]:17191 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab3GAM4X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:56:23 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MP9D7V-01-3XX-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Brian Gitonga Marete <marete@toshnix.com>
CC: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Jerome Glisse <jglisse@redhat.com>
Subject: RE: [REGRESSION] Radeon (Evergreen) Crash with "pin failed" in
 Kernel 3.10-rc7
Thread-Topic: [REGRESSION] Radeon (Evergreen) Crash with "pin failed" in
 Kernel 3.10-rc7
Thread-Index: AQHOc72pTyDwfFYZnkSCHDaBFdqGDZlLEXVwgACH0gCAAdRLgIACXx7A
Date: Mon, 1 Jul 2013 12:55:06 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02E5005D8@sausexdag04.amd.com>
References: <CAHVUoiQ5LpvCLUpx6SeMHAaHZZO0BmcYE3HfJa8OB_hp6aXHgQ@mail.gmail.com>
 <A3397C8B8B789E45844E7EC5DEAD89D02E5001EF@sausexdag04.amd.com>
 <CAHVUoiRk7a=wViqK=UAGqcgL=OJXEVO=6hC-xV+mHWANWvV91w@mail.gmail.com>
 <CAHVUoiREVfiL6asGLN-r7EMeR83d71bXfqhzbhWxNz7BFEUTNA@mail.gmail.com>
In-Reply-To: <CAHVUoiREVfiL6asGLN-r7EMeR83d71bXfqhzbhWxNz7BFEUTNA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.14.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Brian Gitonga Marete [mailto:marete@toshnix.com]
> Sent: Saturday, June 29, 2013 3:41 PM
> To: Deucher, Alexander
> Cc: LKML; David Airlie; Jerome Glisse
> Subject: Re: [REGRESSION] Radeon (Evergreen) Crash with "pin failed" in
> Kernel 3.10-rc7
> 
> On Fri, Jun 28, 2013 at 6:45 PM, Brian Gitonga Marete
> <marete@toshnix.com> wrote:
> > On Fri, Jun 28, 2013 at 3:55 PM, Deucher, Alexander
> > <Alexander.Deucher@amd.com> wrote:
> >>
> >> Can you bisect?
> >>
> >
> 
> Hello Alexander,
> 
> So, it turns out that it is not so easy to reproduce this issue. I
> have been trying to reproduce it with the exact revision of 3.10-rc7
> where I first encountered the problem but with no luck. This of course
> has hampered my bisection since I cannot be sure which revisions to
> mark good/bad. Do you have any suggestions in this regard?
> 
> I however have a UVD-related lockup that I can always reproduce on
> 3.10-rc7: Trying to use UVD with the command: "mplayer -vo vdpau -vc
> ffh264vdpau test.mp4" _always_locks up the same system (same kernel,
> same DRI stack) hard. I will report this in a separate email, though
> nothing at all shows up in the logs for this latter problem due to the
> hard lockup. Suggestions about how to help debug this are also
> welcome.

Please open a bug (https://bugs.freedesktop.org) and attach your xorg log and dmesg output.

Alex


