Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3FGI6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:58:10 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:63123 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab3FGI6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:58:02 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: "luke.leighton" <luke.leighton@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        debian-kernel@lists.debian.org, Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re: Uploading linux (3.9.4-1))
Date: Fri, 07 Jun 2013 10:57:57 +0200
Message-ID: <4466665.6pIGCIdISn@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.4-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <CAPweEDx_1fvAv9sROtPreoyyj_yDAuYb040fM2zPc+tf22d=YA@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com> <1622862.fXQWv0YWGV@flatron> <CAPweEDx_1fvAv9sROtPreoyyj_yDAuYb040fM2zPc+tf22d=YA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 of June 2013 08:52:43 luke.leighton wrote:
> On Thu, Jun 6, 2013 at 2:02 PM, Tomasz Figa <tomasz.figa@gmail.com> 
wrote:
> > On Thursday 06 of June 2013 13:49:38 luke.leighton wrote:
> >> On Thu, Jun 6, 2013 at 1:43 PM, Tomasz Figa <tomasz.figa@gmail.com>
> > 
> > wrote:
> >> > Luke,
> >> > 
> >> > On Thursday 06 of June 2013 13:24:57 luke.leighton wrote:
> >> >> On Thu, Jun 6, 2013 at 1:01 AM, Tomasz Figa
> >> >> <tomasz.figa@gmail.com>
> >> > 
> >> > wrote:
> >> >> > I don't see any other solution here than moving all the
> >> >> > Allwinner
> >> >> > code
> >> >> > to DT (as it has been suggested in this thread several times
> >> >> > already), as this is the only hardware description method
> >> >> > supported
> >> >> > by ARM Linux.
> >> >>  
> >> >>  i repeat again: please state, explicitly and unequivocably that
> >> >>  you
> >> >>  -
> >> >> 
> >> >> linux kernel developers - are happy that the reach of linux and
> >> >> gnu/linux OSes is dramatically reduced due to this intransigent
> >> >> position.
> >> >> 
> >> >>  or, tomasz, please state that you, tomasz, represent each and
> >> >>  every
> >> >> 
> >> >> one of the linux kernel developers so that i do not need to keep
> >> >> asking.
> >> > 
> >> > I do not represent all linux kernel developers by any means. I am
> >> > just
> >> > stating current policy of SoC/board support maintained by ARM
> >> > Linux,
> >> > which is common for all Linux kernel devlopers, or at least ARM
> >> > Linux
> >> > kernel developers.
> >> > 
> >> > Personally I am happy with numerous companies backing this policy
> >> > and
> >> > not making problems like this with Allwinner and I am really
> >> > surprised that you are supporting a troublesome company like this.
> >>  
> >>  you've not read what i've written tomasz.
> > 
> > I have.
> > 
> >> > There are many other SoC vendors making low cost SoCs, like
> >> > Rockchip,
> >> > Boxchip,
> >>  
> >>  boxchip *is* allwinner.
> > 
> > Right, sorry. I am not really into this low cost hardware.
> 
>  i've been tracking it for several years.
> 
> > There is also AMLogic, though.
> 
>  they're *definitely* GPL-violators.
> 
> >> > Telechips. Maybe they would be better candidates for being
> >> > promoted as vendors of choice for hardware running free software?
> >>  
> >>  no, because they're not selling at a low-enough price with
> >> 
> >> high-enough integration.  telechips and rockchip don't have the
> >> market
> >> penetration.
> > 
> > I do not have access to any numbers, so I am left to believe in what
> > you say.
> 
>  well... none of us do :)  that report (was it from IDC? it was in
> earlier messages) is a good analysis.
> 
> > (Although here in Poland the cheap tablet market is almost evenly
> > divided between all those companies, you can find almost same amount
> > of
> > tablets based on SoCs from each vendor.)
> 
>  most likely.
> 
>  allwinner is the one that's actually expressed an interest, at
> Director (Board) Level, of being GPL-compliant.  the software
> engineers understand that; their immediate Manager does not [and is
> causing considerable disruption].
> 
>  AMLogic stone-walled and cost us money and a large client due to
> their GPL violations. which they till have not resolved [in over 2
> years].  i will not work with them, ever again.
> 
>  Telechips are korean-based: they haven't responded to communications.
> 
>  Nufront got themselves in a muddle [late on silicon] so we ruled them
> out - we'll come back to them later.
> 
>  there's a number of others, but allwinner's the only one that is
> actively communicating.
> 
>  so.
> 
>  coming back to what you said earlier: i'm formulating what to say to
> allwinner [and need to pre-send something by monday so that they can
> consider it before the meeting].  so far, it consists of:
> 
> * device-tree is what the linux kernel community has come up with, it
> is equivalent to FEX.

...before FEX ever existed...

> * the linux kernel community would like to apologise for not
> consulting with you (allwinner) on the decision to only accept device
> tree
> 
> [bear in mind that if this kind of thing isn't said, they risk just
> continuing to make the sunxi community's life absolute hell by
> continuing to work in isolation and continuing to duplicate drivers
> etc. etc. ]

So basically you are making sure that they think they decision to reinvent 
the wheel by using proprietary FEX was correct and our decision to use 
generic, extensive and standard-based DeviceTree was self-oriented.

In addition you are telling them something completely opposite from how 
the Linux kernel community (and probably any other open source community 
works). This is _THEIR_ responsibility to consult things they do with us, 
_NOT_ the other way around, if they want to work with upstream.

> * work is being done by the free software community, they are
> beginning to integrate allwinner's work into the upstream kernel, and
> you (allwinner) will begin to see this when you get round to doing
> linux kernel 3.9

>From what I could read from other posts in this thread they already know 
this.

> * allwinner and the linux and sunxi community therefore need to work
> closer together, we propose:

 - joining the mailing lists by Allwinner people to remove any messengers 
from the way (don't say here that they don't speak English, as several 
people clearly confirmed that they do...)

 - adjusting their workflow to comply with rules of Linux kernel open 
source community (i.e. sending RFCs, getting code reviewed, addressing 
comments)

 - reworking existing code to use widely-accepted, standard solutions 
available in upstream Linux kernel (although this is already mostly done 
by sunxi community)

> 3 days left on the clock.

By the way, I haven't seen any explanation from you who (and by what 
means) gave you any authorization to speak on behalf of Allwinner or to 
represent Linux kernel community for them.

Seeing from your posts you don't have any knowledge on how Linux kernel 
development works and even on how Allwinner's cooperation with our 
community looks (and seem to be completely closed to our effort of showing 
you the reality), so I'm not sure if you are the right person to take any 
of those roles...

I'd suggest Maxime Ripard or someone else from Free Electrons to be 
responsible for communication with Allwinner instead.

Best regards,
Tomasz

