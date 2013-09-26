Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab3IZArf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:47:35 -0400
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:48006 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752757Ab3IZArd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:47:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:421:541:599:877:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2551:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3673:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:7652:7903:8527:8957:10004:10400:10848:11232:11658:11914:12050:12219:12517:12519:12555:12740:13069:13071:13149:13161:13229:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tub27_41845eac10c4f
X-Filterd-Recvd-Size: 1719
Message-ID: <1380156448.17366.44.camel@joe-AO722>
Subject: Re: linux-next: Tree for Sep 25
From: Joe Perches <joe@perches.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Date: Wed, 25 Sep 2013 17:47:28 -0700
In-Reply-To: <20130925144329.7d240a6fa2b5782dc8726340@canb.auug.org.au>
References: <20130925144329.7d240a6fa2b5782dc8726340@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 14:43 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Heads up: I will be having a 3 week break leading up to the kernel
> summit.  This means that next-20130927 (next Friday) will be the last
> linux-next release until next-20131028 (or maybe 29).  I presume that
> Linus will be up to v3.12-rc7 by then and -rc7 is often the last before
> a release ... Please plan accordingly.

Hi Stephen.

Maybe this is a good time for an experiment.

Perhaps it would be interesting if you still had a script
running every workday and pushed out the result tree without
trying to do any patch conflict resolution yourself.

Maybe notify the owners of the trees that conflict and let
them work out whatever resolutions that are necessary.

I think FengGuang's robot can supply most all the details
necessary and maybe you can do a lot less work in the future.


