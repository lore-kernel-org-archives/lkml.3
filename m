Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaHVQVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:21:12 -0400
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:60723 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932260AbaHVQVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:21:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1434:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:7514:7652:7974:9010:10004:10400:10848:11232:11658:11914:12043:12517:12519:12679:12740:13069:13161:13211:13229:13311:13357:13891:14096:14097:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coil98_440da62894b0f
X-Filterd-Recvd-Size: 2327
Message-ID: <1408724465.13483.17.camel@joe-AO725>
Subject: Re: [PATCH 0/6] Remove various orphaned header files
From: Joe Perches <joe@perches.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 22 Aug 2014 09:21:05 -0700
In-Reply-To: <8761hksfnf.fsf@rasmusvillemoes.dk>
References: <1403630855-29186-1-git-send-email-linux@rasmusvillemoes.dk>
	 <1403631263.29061.17.camel@joe-AO725> <8761hksfnf.fsf@rasmusvillemoes.dk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 17:33 +0200, Rasmus Villemoes wrote:
> Joe Perches <joe@perches.com> writes:
> 
> > On Tue, 2014-06-24 at 19:27 +0200, Rasmus Villemoes wrote:
> >> AFAICT, these headers are not used anywhere, and are just accidental
> >> leftovers from past cleanups.
> >
> > Thanks.
> 
> Did anyone pick these [1] up? All six files still seem to be present.

Doesn't look like it.  There is no guaranteed
mechanism to get these types of patches applied.

I suggest you resend these to a wider audience.

Jiri Kosina <trivial@kernel.org> is the maintainer of
the "trivial" tree, some patches of this type go
through that tree every once in awhile.

Andrew Morton <akpm@linux-foundation.org> sometimes
picks up things like this.

Also, make sure to send the individual deletions to the
original maintainers, authors and signers of each file.

For instance:

$ ./scripts/get_maintainer.pl -f include/linux/platform_data/tegra_emc.h
Stephen Warren <swarren@wwwdotorg.org> (supporter:TEGRA ARCHITECTUR...)
Thierry Reding <thierry.reding@gmail.com> (supporter:TEGRA ARCHITECTUR...)
linux-tegra@vger.kernel.org (open list:TEGRA ARCHITECTUR...)

$ git log --format="Author: %an <%ae>" include/linux/platform_data/tegra_emc.h
Author: Olof Johansson <olof@lixom.net>

Lastly, if none of that works within a couple of
release cycles, send them directly to Linus.


