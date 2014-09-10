Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaIJIlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:41:37 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54043 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaIJIlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:41:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Anton Vorontsov <anton@enomsg.org>, Felix Fietkau <nbd@openwrt.org>,
        kernel-build-reports@lists.linaro.org, linux-kernel@vger.kernel.org,
        Build bot for Mark Brown <broonie@kernel.org>,
        Imre Kaloz <kaloz@openwrt.org>
Subject: Re: CNS3xxx maintainer (was Re: master build: 0 failures 28 warnings (v3.17-rc4-158-ge874a5f))
Date: Wed, 10 Sep 2014 10:41:18 +0200
Message-ID: <15299684.3JflHn3FpC@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140910082416.GA31925@d1stkfactory>
References: <E1XRaM1-0006oX-7W@cassiel.sirena.org.uk> <3041301.pUTzAnrqpK@wuerfel> <20140910082416.GA31925@d1stkfactory>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:woiPvPhGwNWQetpF631EQBO0iEjAhAOKcxCkirkfj8C
 M4UZ6UQZz/0ThYpLhGwzNbM7DmEk7xk0BkDcN9RgRY1c9Q6sh4
 nzeZ1i3p1592kBn/ogcDQuTYlioOjq/Pl7Y5+5h5a79KMJj2CY
 IX5DTQauWDAzyjPZQWjEFJ9gOnhVXfARaC5GRf+MnmEOnmghY4
 dyufBjXajJ8k5FwxocpTGxlqfd81pH1hTP638r4osgmfyNUUFN
 7cmXLHYkiLzoDOQe4jrMtqECp7IQMu0sdcE1PaQahubOYRs1nJ
 qyr7R/50xyTgjg2ve652UXqNF9jy7Lwrn0EYwQ5p6y5GvMdbUt
 zFGrEhVs/LsEhu4hsaNE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2014 01:24:16 Anton Vorontsov wrote:
> On Wed, Sep 10, 2014 at 10:01:43AM +0200, Arnd Bergmann wrote:
> [...]
> > > -------------------------------------------------------------------------------
> > > arm-allmodconfig : PASS, 0 errors, 18 warnings, 0 section mismatches
> > > 
> > > Warnings:
> > >     ../arch/arm/mach-cns3xxx/pcie.c:311:1: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> > 
> > I guess we should try to find a new cns3xxx maintainer
> 
> I'd be more than happy to hand it over. As far as I know, OpenWRT is a
> major user of cns3xxx nowadays, so Cc'ing some of the active folks.

I agree that would be best. Also, looking at the code that sits in the
OpenWRT git, most of the cns3xxx patches should just get merged upstream,
I'll take them as soon as someone can write a changelog for them.

The SMP support, in particular the fiq usage is probably the only
thing that will need a few review rounds.


> > and the patch I made for this needs to be tested.
> 
> Fwiw, it looked really good.

Thanks.

	Arnd
