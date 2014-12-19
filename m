Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaLSWtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:49:12 -0500
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:46260 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752438AbaLSWtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:49:09 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3873:3874:4321:5007:6119:6261:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:13894:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rail00_327c312fb645a
X-Filterd-Recvd-Size: 1686
Message-ID: <1419029345.25129.16.camel@perches.com>
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
Date: Fri, 19 Dec 2014 14:49:05 -0800
In-Reply-To: <yw1xy4q4exo9.fsf@unicorn.mansr.com>
References: <1418849927.28384.1.camel@perches.com>
	 <alpine.DEB.2.11.1412190031530.17382@nanos>
	 <1418951658.28384.20.camel@perches.com>
	 <yw1x388ch0su.fsf@unicorn.mansr.com> <1418954914.25129.1.camel@perches.com>
	 <yw1xy4q4exo9.fsf@unicorn.mansr.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-19 at 10:33 +0000, Måns Rullgård wrote:
> Joe Perches <joe@perches.com> writes:
> > The kernel/printk/early_printk() function seems
> > used only by arm/microblaze/tile/x86.
> 
> Rather than introduce more config complexity, you could try to remove
> the 7 remaining uses of early_printk().

That's the general idea actually.
Dunno if that's possible at one go though.

cheers, Joe

