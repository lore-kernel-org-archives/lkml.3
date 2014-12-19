Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaLSCIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:08:40 -0500
Received: from smtprelay0133.hostedemail.com ([216.40.44.133]:47734 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751158AbaLSCIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:08:38 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3870:3871:3872:3873:3874:4250:4321:5007:6261:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12740:13069:13161:13229:13311:13357:13894:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tramp89_8535f8aa9ea24
X-Filterd-Recvd-Size: 1714
Message-ID: <1418954914.25129.1.camel@perches.com>
Subject: Re: rfc: remove early_printk from a few arches? (blackfin, m68k,
 mips)
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Steven Miao <realmz6@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips <linux-mips@linux-mips.org>
Date: Thu, 18 Dec 2014 18:08:34 -0800
In-Reply-To: <yw1x388ch0su.fsf@unicorn.mansr.com>
References: <1418849927.28384.1.camel@perches.com>
	 <alpine.DEB.2.11.1412190031530.17382@nanos>
	 <1418951658.28384.20.camel@perches.com>
	 <yw1x388ch0su.fsf@unicorn.mansr.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-19 at 01:43 +0000, Måns Rullgård wrote:
> What exactly are you proposing to remove?

Optionally compile out
kernel/printk/printk.c:early_printk()
even if CONFIG_EARLY_PRINTK is enabled.

> I see no unused code related
> to early printk (in any variant) under arch/mips.

I think there could be yet another CONFIG option
to specifically enable the early_printk function
for the arches that use it.

The kernel/printk/early_printk() function seems
used only by arm/microblaze/tile/x86.


