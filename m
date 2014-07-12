Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaGLS3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 14:29:44 -0400
Received: from smtprelay0117.hostedemail.com ([216.40.44.117]:47376 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751862AbaGLS3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 14:29:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:6691:7652:7903:7904:8531:10004:10400:10848:11232:11658:11914:12114:12517:12519:12663:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pigs71_7160fde1bb216
X-Filterd-Recvd-Size: 2234
Message-ID: <1405189777.9132.27.camel@joe-AO725>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 12 Jul 2014 11:29:37 -0700
In-Reply-To: <20140712175526.GA17077@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
	 <20140712013444.GA30368@kroah.com> <1405129216.6751.18.camel@joe-AO725>
	 <20140712093043.GG25880@mwanda> <20140712175526.GA17077@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-12 at 10:55 -0700, Greg KH wrote:
> Yes, the warnings are all due to line-length, but Joe, you shouldn't add
> a patch that causes more checkpatch warnings than before :)

Yeah, that was intentional though.

This script does a series of relatively discrete changes.

Lindent would more or less work, but it's _horrible_ at
wrapping overlong lines and merges all types of changes
together.

For now, people are probably better at line wrapping in
an acceptable way.

> While I always want to see more developers get involved with kernel
> development, there should be a minimum barrier to entry.  And that
> barrier is the knowledge of the C language, and knowledge of how to edit
> a text file, and use git.  This script takes that barrier away, for
> whitespace cleanups, with not much real use overall.
> 
> So, I'll keep my local copy of this script now, just to have fun with at
> times when I'm bored.  But I don't think it should be merged, as-is.

Dunno, I still think it's useful.

Maybe when you get new code, you might run it through a
script like this before committing it.


