Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaKDCVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:21:10 -0500
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:46068 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751020AbaKDCVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:21:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2692:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3870:3872:3874:4250:4321:5007:6261:7903:10004:10400:10848:11232:11658:11914:12043:12049:12296:12517:12519:12740:13069:13095:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: level19_60958e5d2c74c
X-Filterd-Recvd-Size: 2185
Message-ID: <1415067662.17743.43.camel@perches.com>
Subject: Re: [PATCH V2 2/2] ASoC: staging: ft1000: Logging message neatening
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Belisko <marek.belisko@gmail.com>,
        devel@driverdev.osuosl.org
Date: Mon, 03 Nov 2014 18:21:02 -0800
In-Reply-To: <20141104003613.GA5128@kroah.com>
References: <cover.1415060503.git.joe@perches.com>
	 <a7140e598b199bbc7cb93d0a62d7e6240aa563c2.1415060503.git.joe@perches.com>
	 <20141104003613.GA5128@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 16:36 -0800, Greg Kroah-Hartman wrote:
> On Mon, Nov 03, 2014 at 04:25:44PM -0800, Joe Perches wrote:
> > Use a more common logging style.
> > 
> > o Convert DEBUG macros to pr_debug
> > o Add pr_fmt
> > o Remove embedded function names from pr_debug
> > o Convert printks to pr_<level>
> > o Coalesce formats and align arguments
> > o Add missing terminating newlines
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> ASoC???
> 
> I'll go edit that by hand...

How odd.  It must be some git weirdness I don't understand.

That's just from doing: (after a git pull of your staging-next tree)

$ patch -p1 < ../next/patches/ft1000/0001-staging-ft1000-Whitespace-neatening.patch
$ emacs drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c.rej 
$ git commit -s drivers/staging/ft1000
$ git am ../next/patches/ft1000/0002-staging-ft1000-Logging-message-neatening.patch
$ git format-patch -2 --subject-prefix="PATCH V2" -o patches/ft1000 --cover-letter

I didn't touch either output patch but did edit the cover letter.

and ../next/patches/ft1000/0002-etc... doesn't have ASoC in it.

$ grep -i asoc ../next/patches/ft1000/0002-staging-ft1000-Logging-message-neatening.patch 
$ 

