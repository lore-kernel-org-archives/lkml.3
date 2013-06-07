Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab3FGS42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:56:28 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36306 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab3FGS41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:56:27 -0400
MIME-Version: 1.0
In-Reply-To: <201306062222.53780.arnd@arndb.de>
References: <51AFA6DD.3000202@wwwdotorg.org>
	<CAOesGMgqxhG45NyCfpHc_0uHS+_Gn-hGZm-+CRvK2EEf1AGTow@mail.gmail.com>
	<20130606172810.GE14209@lukather>
	<201306062222.53780.arnd@arndb.de>
Date: Fri, 7 Jun 2013 19:56:26 +0100
Message-ID: <CAPweEDyfrA9z55Yqt8jC8j=e=G_gAH_FA0XrOLxExajwQxN8rQ@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Olof Johansson <olof@lixom.net>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm <debian-arm@lists.debian.org>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-kernel <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 9:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 06 June 2013, Maxime Ripard wrote:
>> So yes, Allwinner has an evil vendor tree (c), with a solution similar yet
>> inferior (because not generic enough) to the device tree, but they show
>> interest on going down the mainline road.
>
> Right, and of course there is nothing special about that, everybody starts
> out with they own even vendor tree (c), and as hardware support gets merged
> upstream, the diff gets smaller, even though the code in the mainline
> kernel is normally very different from what they started out with.

 *sigh* except if that idiot manager [whom we're keenly aware of]
orders them to delete absolutely everything (find . -name '*sunxi*' |
xargs git rm) and overwrite it with their internally-managed tree,
causing absolute mayhem in the process...


> Chances are actually that the Allwinner (A10/A13/A20, not A31) platform may
> end up being the first modern one that is fully supported upstream including
> a GPU driver, since it is one of the obvious targets for the
> reverse-engineering efforts.

 yes. http://libv.livejournal.com/24735.html

> Ironically (given NVIDIA's reputation), the
> Tegra platform is the strongest competitor I see in that race at the moment.

 at $7.50 for a dual-core processor, and i am *not* going to tell you
the quad-core price, i don't believe it can be considered to be a
race, or even a competition.  they're *OUT*, man.   really.

 oh wait - did you mean for "1st to have fully supported upstream GPU
driver"?  that would be veery nice.

> For all I can tell, things are progressing nicely, given that it's currently
> a volunteer effort. If anyone needs things to move faster, I'd recommend
> them to send money to free-electrons.com.

 i'll put that on the list of recommendations, but - again - i need a
list of clear benefits and returns as to why that should happen.

l.
