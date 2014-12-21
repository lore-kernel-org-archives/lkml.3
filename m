Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaLUTD2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 14:03:28 -0500
Received: from smtprelay0036.hostedemail.com ([216.40.44.36]:40370 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752368AbaLUTD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 14:03:27 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:4321:5007:6261:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:13894:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grip65_582c76c459720
X-Filterd-Recvd-Size: 1475
Message-ID: <1419188604.4200.8.camel@perches.com>
Subject: Re: [PATCH] printk: add per console loglevel
From: Joe Perches <joe@perches.com>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: dwalker@fifo99.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Sun, 21 Dec 2014 11:03:24 -0800
In-Reply-To: <20141221194753.49c12693@neptune.home>
References: <20141220224908.GB4466@fifo99.com>
	 <20141221194753.49c12693@neptune.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-21 at 19:47 +0100, Bruno Prémont wrote:
> On Sat, 20 December 2014 dwalker@fifo99.com wrote:
> > This adds to to the console= command line options allowing the
> > addition of a per console log level setting.
> > 
> > examples,
> > 
> > 	console=ttyS0,ll4
> > 	console=tty0,ll6
> > 
> > This can be used on systems which have multiple serial consoles, but
> > it's desired for logging to be light on one and heavy on another.
> 
> Looks useful to me.

I think this is reasonable to, but for consistency
with other loglevel uses, I suggest using
loglevel=<level> instead of ll<d>


