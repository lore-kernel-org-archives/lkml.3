Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaIPUJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:09:03 -0400
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:43188 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751691AbaIPUI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:08:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2892:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:6248:7652:7875:7903:8957:9010:9025:10004:10400:10450:10455:10848:11232:11658:11914:12043:12050:12295:12517:12519:12679:12740:13069:13072:13095:13311:13357:13891:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ants17_13e1996bdb423
X-Filterd-Recvd-Size: 2922
Message-ID: <1410898135.16519.14.camel@joe-AO725>
Subject: Re: [PATCH 1/8] arm: Convert pr_warning to pr_warn
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 16 Sep 2014 13:08:55 -0700
In-Reply-To: <20140916195737.GO12361@n2100.arm.linux.org.uk>
References: <cover.1410632834.git.joe@perches.com>
	 <7995478e8c658478cd37dabb996f7269405251ac.1410632835.git.joe@perches.com>
	 <20140915155656.GA29744@arm.com>
	 <20140916160759.GJ12361@n2100.arm.linux.org.uk>
	 <1410884281.16519.2.camel@joe-AO725>
	 <20140916195737.GO12361@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 20:57 +0100, Russell King - ARM Linux wrote:
> On Tue, Sep 16, 2014 at 09:18:01AM -0700, Joe Perches wrote:
> > On Tue, 2014-09-16 at 17:07 +0100, Russell King - ARM Linux wrote:
> > > any chance you could add a KernelVersion: tag somewhere in the
> > > commit message and throw it at patches@arm.linux.org.uk so it doesn't
> > > get lost?
> > 
> > There are no commit logs with a KernelVersion: tag
> > in all of git history.
> 
> Right, that's not it's purpose.
> 
> > What do you think a KernelVersion: tag is and what
> > would it be used for?
> 
> It's for that email address to know which kernel version the patch
> was generated against, which is useful information when I come to
> apply it.  It gets filtered out from the commit message.  It can go
> anywhere, even below the -- line.

> If you don't want to cooperate, you will have to rely on my notoriously
> bad email skills to scan the mailing list for random patches to apply
> some time (maybe days or even weeks) later after you send your message.
> Which just won't happen.  It's why I wrote scripts which are some 20
> years old to solve my bad email patch handling skills.

I received your patchbot's reply about 15 minutes
before you sent this.

I suggest you might move one year to patchwork
(ie: https://patchwork.kernel.org/project/linux-arm-kernel/list/)
and adapt that as necessary, but whatever works
for you.

btw:

patches@arm.linux.org.uk is not documented at all
in the kernel sources.  You could fix that if you
want other people to know what you do.


