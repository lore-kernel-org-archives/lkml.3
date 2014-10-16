Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaJPOqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:46:09 -0400
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:53296 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750947AbaJPOqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:46:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3873:4321:5007:6261:8700:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: skate97_6f48724228209
X-Filterd-Recvd-Size: 1670
Message-ID: <1413470763.6702.3.camel@perches.com>
Subject: Re: [PATCH] kernel:module Fix coding style errors and warnings.
From: Joe Perches <joe@perches.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Ionut Alexa <ionut.m.alexa@gmail.com>, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Date: Thu, 16 Oct 2014 07:46:03 -0700
In-Reply-To: <20141016125724.GA5244@sudip-PC>
References: <1413452213-27450-1-git-send-email-ionut.m.alexa@gmail.com>
	 <1413452333.6702.1.camel@perches.com> <20141016125724.GA5244@sudip-PC>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 18:27 +0530, Sudip Mukherjee wrote:
> On Thu, Oct 16, 2014 at 02:38:53AM -0700, Joe Perches wrote:
> > On Thu, 2014-10-16 at 12:36 +0300, Ionut Alexa wrote:
> > > Fixed codin style errors and warnings. Changes printk with
> > > print_debug/warn. Changed seq_printf to seq_puts.
> > If you are going to do style cleanups, please make
> > sure you check your patches with scripts/checkpatch.pl
> > before sending them.
[]
> should we be doing style cleanups in the kernel files ?

Generally, no.

> previously i saw comments discouraging it as it pollutes the git blame.

Also generally, style only patches are discouraged
but can be done as part of a series when enhancements,
bug-fixes or optimizations are done.



