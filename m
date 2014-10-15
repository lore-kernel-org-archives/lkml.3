Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaJOUEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:04:50 -0400
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:44206 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751691AbaJOUDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:03:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3874:4321:5007:6261:7903:10004:10400:10848:11232:11658:11914:12050:12296:12517:12519:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: copy08_3eae6f57fd324
X-Filterd-Recvd-Size: 2140
Message-ID: <1413403429.7484.13.camel@perches.com>
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 13:03:49 -0700
In-Reply-To: <20141015195345.GQ26918@mwanda>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20141015123431.GA23154@mwanda> <20141015125934.GB23154@mwanda>
	 <1413378213.2412.13.camel@jtkirshe-mobl>
	 <1413389496.7484.3.camel@perches.com> <20141015195345.GQ26918@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-15 at 22:53 +0300, Dan Carpenter wrote:
> On Wed, Oct 15, 2014 at 09:11:36AM -0700, Joe Perches wrote:
> > On Wed, 2014-10-15 at 06:03 -0700, Jeff Kirsher wrote:
> > []
> > > I thought I remember Greg saying something about getting rid of this
> > > driver anyway, but I could be wrong.  If Greg decides to keep this
> > > driver around, then I think we should something like your suggestion
> > > above.
> > 
> > Or maybe just make the Kconfig depend on X86_32
> 
> What I like about your patches is that they are pure theoretical work
> and I don't have to think about them like regular proper patches with a
> signed off by etc.  All the fun, none of the responsibility.

I've sent a lot of signed-off patches.
These are simple suggestions.

I think COMPILE_TEST isn't useful here.

I doubt very much beceem has been tested
on anything other than an x86_32 board.

I once spent a few hours fixing up a bunch
of defects in this directory a few years ago.

Now I will not submit any more patches for
cmhost or anything else in that directory.


