Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaGMDGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 23:06:50 -0400
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:58782 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751786AbaGMDGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 23:06:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2890:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:4042:4250:4321:5007:6691:7652:8531:10004:10400:10848:11232:11658:11914:12114:12517:12519:12740:13069:13161:13227:13229:13311:13357:14096:14097:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: edge73_74473d8aa9363
X-Filterd-Recvd-Size: 2095
Message-ID: <1405220796.9132.31.camel@joe-AO725>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, kernelnewbies@kernelnewbies.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Sat, 12 Jul 2014 20:06:36 -0700
In-Reply-To: <20140712192846.GB25649@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
	 <20140712013444.GA30368@kroah.com> <1405129216.6751.18.camel@joe-AO725>
	 <20140712093043.GG25880@mwanda> <20140712175526.GA17077@kroah.com>
	 <1405189777.9132.27.camel@joe-AO725> <20140712192846.GB25649@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-12 at 12:28 -0700, Greg KH wrote:
> On Sat, Jul 12, 2014 at 11:29:37AM -0700, Joe Perches wrote:
> > On Sat, 2014-07-12 at 10:55 -0700, Greg KH wrote:
> > > Yes, the warnings are all due to line-length, but Joe, you shouldn't add
> > > a patch that causes more checkpatch warnings than before :)
> > 
> > Yeah, that was intentional though.
> > 
> > This script does a series of relatively discrete changes.
> > 
> > Lindent would more or less work, but it's _horrible_ at
> > wrapping overlong lines and merges all types of changes
> > together.
> 
> Oh I agree, I don't want to see Lindent, but maybe, if the patch adds
> checkpatch warnings, it should be at least "flagged" as maybe a problem?

The script I submitted does run checkpatch
before any commit is done.

> Would you want to be on the receiving end of this patch script?

You might have noticed I don't have a kernel.org
account.


