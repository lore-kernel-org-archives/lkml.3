Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab3FFNCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:02:43 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:48496 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab3FFNCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:02:41 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: "luke.leighton" <luke.leighton@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        debian-kernel@lists.debian.org
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re: Uploading linux (3.9.4-1))
Date: Thu, 06 Jun 2013 15:02:37 +0200
Message-ID: <1622862.fXQWv0YWGV@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.4-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <CAPweEDxWW4LUeBaHLb+wHuAMq=63p88zsx4tumVb2PdP_+ohAw@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com> <1851164.HnXhGSdttW@flatron> <CAPweEDxWW4LUeBaHLb+wHuAMq=63p88zsx4tumVb2PdP_+ohAw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 of June 2013 13:49:38 luke.leighton wrote:
> On Thu, Jun 6, 2013 at 1:43 PM, Tomasz Figa <tomasz.figa@gmail.com> 
wrote:
> > Luke,
> > 
> > On Thursday 06 of June 2013 13:24:57 luke.leighton wrote:
> >> On Thu, Jun 6, 2013 at 1:01 AM, Tomasz Figa <tomasz.figa@gmail.com>
> > 
> > wrote:
> >> > I don't see any other solution here than moving all the Allwinner
> >> > code
> >> > to DT (as it has been suggested in this thread several times
> >> > already), as this is the only hardware description method supported
> >> > by ARM Linux.
> >>  
> >>  i repeat again: please state, explicitly and unequivocably that you
> >>  -
> >> 
> >> linux kernel developers - are happy that the reach of linux and
> >> gnu/linux OSes is dramatically reduced due to this intransigent
> >> position.
> >> 
> >>  or, tomasz, please state that you, tomasz, represent each and every
> >> 
> >> one of the linux kernel developers so that i do not need to keep
> >> asking.
> > 
> > I do not represent all linux kernel developers by any means. I am just
> > stating current policy of SoC/board support maintained by ARM Linux,
> > which is common for all Linux kernel devlopers, or at least ARM Linux
> > kernel developers.
> > 
> > Personally I am happy with numerous companies backing this policy and
> > not making problems like this with Allwinner and I am really
> > surprised that you are supporting a troublesome company like this.
> 
>  you've not read what i've written tomasz.

I have.

> > There are many other SoC vendors making low cost SoCs, like Rockchip,
> > Boxchip,
> 
>  boxchip *is* allwinner.

Right, sorry. I am not really into this low cost hardware.

There is also AMLogic, though. 

> > Telechips. Maybe they would be better candidates for being
> > promoted as vendors of choice for hardware running free software?
> 
>  no, because they're not selling at a low-enough price with
> high-enough integration.  telechips and rockchip don't have the market
> penetration.

I do not have access to any numbers, so I am left to believe in what you 
say. (Although here in Poland the cheap tablet market is almost evenly 
divided between all those companies, you can find almost same amount of 
tablets based on SoCs from each vendor.)

Best regards,
Tomasz

>  and many other reasons.
> 
> > (Just
> > saying, as I do not know anything about their view on this. There is a
> > lot of cheap tablets built using their products as well.)
> > 
> > Best regards,
> > Tomasz
