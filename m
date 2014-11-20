Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbaKTMmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:42:13 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:55410 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaKTMmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:42:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: dt for 3.19 #2
Date: Thu, 20 Nov 2014 13:41:29 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1416415953-31966-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1416415953-31966-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201411201341.30112.arnd@arndb.de>
X-Provags-ID: V02:K0:S8+aSj2xCo+8v9q+9nsh56brZ4aRE1vUJ5IaNSrxpCK
 CX2keIzVG4K5KbaabKOf3VqnOq28brQY0Aj7OOXdw0KNUkbK8t
 93IdFQWa131IiOIT9HqQXmvbNMOpd//k9Sl+X21Syvq549Poz4
 tGtjJqNK2dTvZ56qP4BK1Jx4kd/KVHfXmAn/yle/szRd2zJ7Y/
 4AjIenvYdo9aWBRuTUWAUfu1uDOvdLh40quEky3f4NwONVJSF8
 eWlxp01sXcYhVkNaA5RCcxce5Msob9IoZPRiLYyN/jLFEpXaaN
 qlCee/rRMWuaEiry1QDcEDTjFeobXw2q4VdaaXo9ae1LZALZZJ
 Ru7IvOrelDeIUeH6ormXzhwvs7UvdhyO46nwqoeH/
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2014, Nicolas Ferre wrote:
> Another DT pull-request for 3.19. For this one, I had to pull one Vinod's topic
> branch to be able to include the XDMA DT properties. This branch is stable and
> based on 3.18-rc3 (Cf. http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/304041.html).
> Note that my previous DT pull-request for 3.19 was based on 3.18-rc2.
> So, this is what I did:
> - took a v3.18-rc3 tag
> - merged the at91-3.19-dt branch that you already have in at91/dt (you'd taken the at91-dt tag)
> - merged the topic/at_xdmac from Vinod
> - stacked the new material described above on top of this.
> Tell me if it's okay for you or if I have to arrange things differently.
> 
> The content itself is pretty straightforward.
> 

I've pulled it into a new next/dt2 branch, so we don't have to coordinate the merging
with Vinod. If he sends the slave-dma tree first, this will be part of the normal
next/dt submission to Linus, otherwise it will come a few days later.

Thanks,

	Arnd
