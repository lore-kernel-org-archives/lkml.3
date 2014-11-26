Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaKZPka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:40:30 -0500
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:51423 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752579AbaKZPkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:40:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2551:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4384:5007:6261:10004:10400:10848:11232:11658:11914:12043:12050:12296:12517:12519:12679:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shelf76_3d8031472705f
X-Filterd-Recvd-Size: 2584
Message-ID: <1417016421.19695.1.camel@perches.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: ARM Versatile Express platform
From: Joe Perches <joe@perches.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Mike Turquette <mturquette@linaro.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 26 Nov 2014 07:40:21 -0800
In-Reply-To: <1417012855.3972.3.camel@arm.com>
References: <1416939455-1814-1-git-send-email-pawel.moll@arm.com>
	 <1416967146.8358.19.camel@perches.com> <1417003449.3972.1.camel@arm.com>
	 <2667096.evZZoH9ryD@wuerfel> <1417012855.3972.3.camel@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 14:40 +0000, Pawel Moll wrote:
> On Wed, 2014-11-26 at 12:17 +0000, Arnd Bergmann wrote:
> > On Wednesday 26 November 2014 12:04:09 Pawel Moll wrote:
> > > 
> > > Right, of course. Whole directory.
> > > 
> > > > F:    */*/vexpress*
> > > 
> > > Cool, didn't think about multiple wildcards. 
> > 
> > Actually, I think you could even do this as
> > 
> > N:	vexpress
> > 
> > which would be even shorter and match most of the other entries too.
> 
> If you think it's safe, fine with me. It would reduce this section to:
> 
> N:	vexpress
> F:	drivers/clocksource/versatile.c

Yes, that's possible too, but:

from MAINTAINERS:

	   scripts/get_maintainer.pl has different behavior for files that
	   match F: pattern and matches of N: patterns.  By default,
	   get_maintainer will not look at git log history when an F: pattern
	   match occurs.  When an N: match occurs, git log history is used
	   to also notify the people that have git commit signatures.

I think it's better to use F: entries because
there is a get_maintainer difference in behavior
between N: and F: entries.

An N: entry means get_maintainer will also cc
patch submitters for these files.

An F: entry will not.


