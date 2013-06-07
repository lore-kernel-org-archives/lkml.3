Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3FGHwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:52:45 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:49890 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3FGHwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:52:44 -0400
MIME-Version: 1.0
In-Reply-To: <1622862.fXQWv0YWGV@flatron>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<1851164.HnXhGSdttW@flatron>
	<CAPweEDxWW4LUeBaHLb+wHuAMq=63p88zsx4tumVb2PdP_+ohAw@mail.gmail.com>
	<1622862.fXQWv0YWGV@flatron>
Date: Fri, 7 Jun 2013 08:52:43 +0100
Message-ID: <CAPweEDx_1fvAv9sROtPreoyyj_yDAuYb040fM2zPc+tf22d=YA@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        debian-kernel@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 2:02 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On Thursday 06 of June 2013 13:49:38 luke.leighton wrote:
>> On Thu, Jun 6, 2013 at 1:43 PM, Tomasz Figa <tomasz.figa@gmail.com>
> wrote:
>> > Luke,
>> >
>> > On Thursday 06 of June 2013 13:24:57 luke.leighton wrote:
>> >> On Thu, Jun 6, 2013 at 1:01 AM, Tomasz Figa <tomasz.figa@gmail.com>
>> >
>> > wrote:
>> >> > I don't see any other solution here than moving all the Allwinner
>> >> > code
>> >> > to DT (as it has been suggested in this thread several times
>> >> > already), as this is the only hardware description method supported
>> >> > by ARM Linux.
>> >>
>> >>  i repeat again: please state, explicitly and unequivocably that you
>> >>  -
>> >>
>> >> linux kernel developers - are happy that the reach of linux and
>> >> gnu/linux OSes is dramatically reduced due to this intransigent
>> >> position.
>> >>
>> >>  or, tomasz, please state that you, tomasz, represent each and every
>> >>
>> >> one of the linux kernel developers so that i do not need to keep
>> >> asking.
>> >
>> > I do not represent all linux kernel developers by any means. I am just
>> > stating current policy of SoC/board support maintained by ARM Linux,
>> > which is common for all Linux kernel devlopers, or at least ARM Linux
>> > kernel developers.
>> >
>> > Personally I am happy with numerous companies backing this policy and
>> > not making problems like this with Allwinner and I am really
>> > surprised that you are supporting a troublesome company like this.
>>
>>  you've not read what i've written tomasz.
>
> I have.
>
>> > There are many other SoC vendors making low cost SoCs, like Rockchip,
>> > Boxchip,
>>
>>  boxchip *is* allwinner.
>
> Right, sorry. I am not really into this low cost hardware.

 i've been tracking it for several years.

> There is also AMLogic, though.

 they're *definitely* GPL-violators.

>> > Telechips. Maybe they would be better candidates for being
>> > promoted as vendors of choice for hardware running free software?
>>
>>  no, because they're not selling at a low-enough price with
>> high-enough integration.  telechips and rockchip don't have the market
>> penetration.
>
> I do not have access to any numbers, so I am left to believe in what you
> say.

 well... none of us do :)  that report (was it from IDC? it was in
earlier messages) is a good analysis.

> (Although here in Poland the cheap tablet market is almost evenly
> divided between all those companies, you can find almost same amount of
> tablets based on SoCs from each vendor.)

 most likely.

 allwinner is the one that's actually expressed an interest, at
Director (Board) Level, of being GPL-compliant.  the software
engineers understand that; their immediate Manager does not [and is
causing considerable disruption].

 AMLogic stone-walled and cost us money and a large client due to
their GPL violations. which they till have not resolved [in over 2
years].  i will not work with them, ever again.

 Telechips are korean-based: they haven't responded to communications.

 Nufront got themselves in a muddle [late on silicon] so we ruled them
out - we'll come back to them later.

 there's a number of others, but allwinner's the only one that is
actively communicating.

 so.

 coming back to what you said earlier: i'm formulating what to say to
allwinner [and need to pre-send something by monday so that they can
consider it before the meeting].  so far, it consists of:

* device-tree is what the linux kernel community has come up with, it
is equivalent to FEX.

* the linux kernel community would like to apologise for not
consulting with you (allwinner) on the decision to only accept device
tree

[bear in mind that if this kind of thing isn't said, they risk just
continuing to make the sunxi community's life absolute hell by
continuing to work in isolation and continuing to duplicate drivers
etc. etc. ]

* work is being done by the free software community, they are
beginning to integrate allwinner's work into the upstream kernel, and
you (allwinner) will begin to see this when you get round to doing
linux kernel 3.9

* allwinner and the linux and sunxi community therefore need to work
closer together, we propose:

* {insert proposals here}

3 days left on the clock.

l.
