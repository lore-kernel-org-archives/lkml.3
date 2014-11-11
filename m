Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaKKFtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:49:55 -0500
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:57455 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751482AbaKKFtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:49:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2903:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3873:3874:4321:5007:6261:8957:10004:10400:10848:11026:11232:11658:11914:12517:12519:12679:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: print18_903ab87172510
X-Filterd-Recvd-Size: 2211
Message-ID: <1415684989.16070.2.camel@perches.com>
Subject: Re: [PATCH 1/3] autofs - fix log print messages
From: Joe Perches <joe@perches.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 10 Nov 2014 21:49:49 -0800
In-Reply-To: <1415684245.2486.9.camel@perseus.themaw.net>
References: <20141111012954.25773.4002.stgit@perseus.themaw.net>
	 <1415676341.16070.0.camel@perches.com>
	 <1415684245.2486.9.camel@perseus.themaw.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 13:37 +0800, Ian Kent wrote:
> On Mon, 2014-11-10 at 19:25 -0800, Joe Perches wrote:
> > On Tue, 2014-11-11 at 09:29 +0800, Ian Kent wrote:
> > > Fix some inconsistencies in log print output and ensure that
> > > the module name is included in all log prints.
> > > 
> > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > Cc: Joe Perches <joe@perches.com>
> > > ---
> > >  fs/autofs/autofs_i.h  |    6 +++---
> > >  fs/autofs/dev-ioctl.c |    2 +-
> > >  fs/autofs/inode.c     |   10 +++++-----
> > >  fs/autofs/waitq.c     |    4 ++--
> > >  4 files changed, 11 insertions(+), 11 deletions(-)
> > 
> > What tree are these patches made against?
> 
> They live in an StGit patch queue against the current Linus tree.
> They depend on the prior series to rename autofs4 to autofs.

Hey Ian.

Maybe you could add the git tree location to
the MAINTAINERS entry:

MAINTAINERS-KERNEL AUTOMOUNTER v4 (AUTOFS4)
MAINTAINERS-M:  Ian Kent <raven@themaw.net>
MAINTAINERS-L:  autofs@vger.kernel.org
MAINTAINERS-S:  Maintained
MAINTAINERS:F:  fs/autofs4/

T:	git git://somewhere_or_other...

and maybe you also could get Stephen Rothwell
to add that tree to -next


