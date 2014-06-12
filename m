Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbaFLQGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:06:09 -0400
Received: from smtprelay0006.hostedemail.com ([216.40.44.6]:49457 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753049AbaFLQGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:06:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6119:7652:7903:8700:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13071:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netch
X-HE-Tag: snow27_1792b86e1a526
X-Filterd-Recvd-Size: 2484
Message-ID: <1402589159.12385.4.camel@joe-AO725>
Subject: Re: [PATCH V2 08/19] irqchip: crossbar: fix checkpatch warning
From: Joe Perches <joe@perches.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sricharan R <r.sricharan@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com,
        santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Date: Thu, 12 Jun 2014 09:05:59 -0700
In-Reply-To: <20140612153226.GE8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
	 <1402574007-13987-9-git-send-email-r.sricharan@ti.com>
	 <20140612131042.GU8664@titan.lakedaemon.net> <5399AC9C.4080602@ti.com>
	 <1402582711.9947.17.camel@joe-AO725>
	 <20140612153226.GE8664@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 11:32 -0400, Jason Cooper wrote:

Hi Jason.

> > But bugfix backports haven't been much of an issue in
> > other subsystems with fairly active whitespace/style
> > changes.
> 
> Most of the mvebu fixes we've had that failed to apply were generally
> due to a large whitespace change (dts node shuffling, admittedly not
> checkpatch-related).

So not due to this.

>   I've also frequently been stymied by code cleanups
> when using git blame to find the commit introducing a regression.

git blame -w can frequently help there.

> So, my general rule is: If you're submitting a patch to make checkpatch
> be quiet, re-assess the need.  If you're making changes and you can fix
> some checkpatch items while you're there, then do so.

Decent rule.

> There are certainly legitimate checkpatch-only patches, I just don't
> think this is one qualifies.

Of course it's the maintainer's choice (and last I saw,
that's you) to ignore whatever doesn't fit the appropriate
vision for the code.

$ ./scripts/get_maintainer.pl -f drivers/irqchip/irq-crossbar.c
Thomas Gleixner <tglx@linutronix.de> (maintainer:IRQCHIP DRIVERS)
Jason Cooper <jason@lakedaemon.net> (maintainer:IRQCHIP DRIVERS)
...

cheers, Joe

