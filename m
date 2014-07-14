Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaGNISx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:18:53 -0400
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:39953 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753438AbaGNISb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:18:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: net62_8459b99e30404
X-Filterd-Recvd-Size: 1866
Message-ID: <1405325908.9132.42.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Add for_each tests to indentation and brace
 tests
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 14 Jul 2014 01:18:28 -0700
In-Reply-To: <20140714081352.GE3743@bark>
References: <20140712230828.GA15827@kroah.com>
	 <1405229634.9132.38.camel@joe-AO725> <20140714081352.GE3743@bark>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-14 at 09:13 +0100, Andy Whitcroft wrote:
> On Sat, Jul 12, 2014 at 10:33:54PM -0700, Joe Perches wrote:
> > All the various for_each loop macros were not tested for
> > trailing brace on the following lines and for bad indentation.
> > 
> > Add them.
[]
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> > @@ -2698,7 +2698,7 @@ sub process {
> >  
> >  # if/while/etc brace do not go on next line, unless defining a do while loop,
> >  # or if that brace on the next line is for something else
> > -		if ($line =~ /(.*)\b((?:if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.\s*\#/) {
> > +		if ($line =~ /(.*)\b((?:if|while|for|switch|(?:[a-z_]+|)for_each[a-z_]+)\s*\(|do\b|else\b)/ && $line !~ /^.\s*\#/) {
> 
> They way you end this first addition with |) converts it the (?:[a-z_]*)
> doesn't it?  Were you intending to do (?:[a-z_]+_|) ?

I didn't think about it much.
It's the same thing no?


