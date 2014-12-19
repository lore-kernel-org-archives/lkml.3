Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaLSBOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:14:25 -0500
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:59806 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751830AbaLSBOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:14:22 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:4321:5007:6261:7903:10004:10400:10848:11026:11232:11473:11658:11914:12296:12517:12519:12740:13069:13180:13229:13311:13357:14096:14097:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: car45_6014dc6a95041
X-Filterd-Recvd-Size: 1938
Message-ID: <1418951658.28384.20.camel@perches.com>
Subject: Re: rfc: remove early_printk from a few arches? (blackfin, m68k,
 mips)
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Steven Miao <realmz6@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips <linux-mips@linux-mips.org>
Date: Thu, 18 Dec 2014 17:14:18 -0800
In-Reply-To: <alpine.DEB.2.11.1412190031530.17382@nanos>
References: <1418849927.28384.1.camel@perches.com>
	 <alpine.DEB.2.11.1412190031530.17382@nanos>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-19 at 00:33 +0100, Thomas Gleixner wrote:
> On Wed, 17 Dec 2014, Joe Perches wrote:
> > It seems like early_printk can be configured into
> > a few architectures but also appear not to be used.
> > 
> > $ git grep -w "early_printk"
> ...
> > These seem to the only uses:
> ... 
> > So blackfin, m68k, and mips seems to have it possible to enable,
> > but also don't appear at first glance to use it,
> 
> Hint: CONFIG_EARLY_PRINTK covers far more than early_printk()

I know this.

Note also I didn't specify CONFIG_EARLY_PRINTK,
just early_printk.
 
> > Is early_printk really used by these architectures?
> > Should it be removed?
> 
> Sure, if you have a good reason to remove working functionality.

Unused.

Ideally, all direct early_printk() uses would go away.
This would just be a starting point to minimize code.


