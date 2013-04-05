Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161328Ab3DEMKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:10:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab3DEMKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:10:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: linux-next: manual merge of the arm-soc tree with the xilinx tree
Date: Fri, 5 Apr 2013 14:09:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        John Linn <John.Linn@xilinx.com>
References: <20130405153335.baf29606a97b1bee415f3546@canb.auug.org.au> <CAHTX3d+NK7b3RVMASZ4BARs1kHeVKGgxNwKTjAeiNB+44TPsFg@mail.gmail.com>
In-Reply-To: <CAHTX3d+NK7b3RVMASZ4BARs1kHeVKGgxNwKTjAeiNB+44TPsFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304051409.37708.arnd@arndb.de>
X-Provags-ID: V02:K0:qBzjC5ypq6R9tvh0ZHK1fQTmk6AHqj1Jv+c9DCEnjuJ
 kNhic4Z2m3NUYMDaRd0ZYUYyy6TuP5wLcI99Oc/2ICFY3FMY5L
 oapkfI2d8O3PMC1QV8FPxQ/tZ6cOiXM0aCzJeYUvyMt0PVhRh6
 hxiZENjuf596BVOjc8P61/PkFU8VpfHL3v76NbkoI9/ZT9bd+Y
 IyiR7zsvjPrJHm9Tm4K+UhES2mjuQ6O8OOd+jNH4QBByyUS/x+
 Af/kbDschDwtzOrUPH7YbVN+KknQhTzWJuyrteEoq03uru2V1w
 OBuY9NuzseXLmxuuneWgGw1S6BywbTlV3CeWTWJhuJIxP2MJ1z
 97GUaHAr8IAxNGBrt+SU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 April 2013, Michal Simek wrote:
> Hi,
> 
> 2013/4/5 Stephen Rothwell <sfr@canb.auug.org.au>
> 
> > Hi all,
> >
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > arch/arm/mach-spear/spear13xx.c between commit c79e33b3e828 ("ARM:
> > smp_twd: convert to use CLKSRC_OF init") from the xilinx tree and commit
> > 2b9c613c4ee1 ("ARM: spear: move generic.h and pl080.h into private dir")
> > from the arm-soc tree.
> >
> > I fixed it up (just used the arm-soc tree version) and can carry the fix
> > as necessary (no action is required).
> >  <sfr@canb.auug.org.au>
> 
> 
> Interesting. I rebased my arm-next branch based on 3.9-rc5
> with some Rob's + one Arnd patch from arm-soc - clksrc/cleanup branch.
> 
> I will fix my arm-next branch.

The for-next branch in arm-soc is not stable, you should never base
/anything/ on it. If you depend on some stable branch, that is in arm-soc,
then use just that branch, not one of the next/* branches or for-next.

	Arnd
