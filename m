Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaGLBup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 21:50:45 -0400
Received: from smtprelay0113.hostedemail.com ([216.40.44.113]:33533 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752029AbaGLBuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 21:50:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:4250:4321:5007:7652:7974:10011:10400:10848:11232:11658:11914:12043:12114:12517:12519:12663:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: copy27_7a7cc7800b610
X-Filterd-Recvd-Size: 1830
Message-ID: <1405129840.6751.28.camel@joe-AO725>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 11 Jul 2014 18:50:40 -0700
In-Reply-To: <20140712014325.GB30781@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
	 <20140712014325.GB30781@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 18:43 -0700, Greg KH wrote:
> On Fri, Jul 11, 2014 at 06:21:27PM -0700, Joe Perches wrote:
> > A simple script to run checkpatch --fix for various types of
> > of cleanups.
[]
> If I pick drivers/staging/lustre/include/linux/lnet/types.h, then I get:
> 
> 	staging: lnet: checkpatch cleanup: whitespace neatening
> 
> and no 'types.h' here, is that intentional?  If so, why?

Yes, it's how it's written.
It uses just the directory name, not any basename($file)

It can be changed if that's what's desired.

> And this is fun, I'm going to let this rip on the lustre code...

It doesn't autocommit, it does show the various changes
it makes and asks you to accept them.

I suppose that could be automated with something better
than "yes", but I didn't want it to be completely automatic.

