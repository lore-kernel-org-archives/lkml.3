Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab3FEVit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:38:49 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:45868 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab3FEVir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:38:47 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 5 Jun 2013 17:38:45 -0400
To: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Subject: Re: getting allwinner SoC support upstream (was Re: Uploading
 linux (3.9.4-1))
Message-ID: <20130605213845.GX11182@csclub.uwaterloo.ca>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
 <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
 <51AFA6DD.3000202@wwwdotorg.org>
 <CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:24:15PM +0100, Luke Kenneth Casson Leighton wrote:
>   https://github.com/linux-sunxi/u-boot-sunxi
> 
>  And Then Some, stephen.  there are two versions of u-boot being used:
> one is the community-assembled [GPL-compliant] one, and the other
> includes a [as-of-a-few-days-ago-but-no-longer, yay!]
> formerly-GPL-violating one from allwinner.
> 
>  the community-based one *doesn't* have fex integration (i don't
> think, but henrik will know for sure), but the allwinner one
> definitely does.
> 
>  .... and then there's the boot0 and boot1 loaders, these *do* have
> fex integration: they're absolutely tiny and they're designed to fit
> into the 1st level cache.  the job of these bootloaders is to set up
> the DDR3 RAM timings (so that you can access DRAM!!) and to then
> decide whether to load from NAND, SD/MMC etc. and many other things.
> 
>  these boot0 and boot1 loaders are themselves configureable so that
> you can specify, through script.fex, what GPIO is to be the "reset
> key" and so on.  that's a much simplified story btw.
> 
>  so the point is: if anyone wishes me to propose to allwinner that
> they convert over to devicetree, or any other proposal which involves
> significant low-level changes to their working practices that could
> potentially have a massive knock-on effect onto their
> multi-million-dollar clients, it had better be a damn good story.

Well certainly anyone interested in being a customer of allwinner should
very much encourage them to get with it.  Having support upstream really
is very helpful when trying to use a chip.  Going off an inventing your
own thing rather than talking to the linux kernel developers first is
just a bad idea as far as long term support is concerned.  Had they asked
they would probably have been told devicetree would be a good idea to use.

Allwinner has some very nice chips, and it certainly would be nice if
they would start doing things "properly".

Texas instruments uses devicetree for their arm devices.  It's very nice.

I haven't checked what freescale is doing yet, although at least for
powerpc, freescale is very used to devicetree, so hopefully they are
doing that for their arm chips too.

Both are certainly pushing their drivers upstream for inclusion and seem
to be listening to feedback on how to best do things.

I haven't personally dealt with any nvidia arm devices, so I have no
idea how those are turning out, nor have I looked much at the marvell
ones yet (even though I have a cubox sitting on my desk I intend to play
around with).

Lots of others like qualcomm, samsung, and who knows who else.  No idea
how they are doing things either.

-- 
Len Sorensen
