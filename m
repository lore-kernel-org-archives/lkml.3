Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaEETvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:51:13 -0400
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:53126 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752019AbaEETvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:51:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3872:3873:3874:4250:4321:5007:7514:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12663:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: iron14_4460636618f10
X-Filterd-Recvd-Size: 2125
Message-ID: <1399319468.26330.2.camel@joe-AO725>
Subject: Re: [PATCH] staging: android: fix missing a blank line after
 declarations
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        Seunghun Lee <waydi1@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 05 May 2014 12:51:08 -0700
In-Reply-To: <20140505095935.GO26890@mwanda>
References: <1398790752-8067-1-git-send-email-waydi1@gmail.com>
	 <20140429173221.GE26890@mwanda> <20140503234326.GA30117@kroah.com>
	 <20140505095935.GO26890@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 12:59 +0300, Dan Carpenter wrote:
> On Sat, May 03, 2014 at 07:43:26PM -0400, Greg KH wrote:
> > On Tue, Apr 29, 2014 at 08:32:21PM +0300, Dan Carpenter wrote:
> > > On Wed, Apr 30, 2014 at 01:59:12AM +0900, Seunghun Lee wrote:
> > > > This patch fixes "Missing a blank line after declarations" warnings.
> > > > 
> > > > Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> > > 
> > > Quite a few of these are false checkpatch.pl false positives.  Just
> > > ignore the false positives.
> > 
> > Really?  It looks good to me, what am I missing?
> > 
> 
> Gar.  You're right.  In my head I remember seeing a bunch of false
> positives but now that I'm looking at it again I'm not sure what I was
> talking about.

I think they were around here:

> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
[]
> @@ -228,8 +230,10 @@ struct binder_node {
>  	int internal_strong_refs;
>  	int local_weak_refs;
>  	int local_strong_refs;
> +
>  	binder_uintptr_t ptr;
>  	binder_uintptr_t cookie;
> +
>  	unsigned has_strong_ref:1;

These 2 new blank lines aren't necessary.

