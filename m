Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbaHYN4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:56:09 -0400
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:58735 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755669AbaHYN4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:56:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2692:2828:2911:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4425:4605:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12517:12519:12663:12740:13069:13141:13149:13230:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lunch78_8c8594b75ea0a
X-Filterd-Recvd-Size: 2220
Message-ID: <1408974964.20683.50.camel@joe-AO725>
Subject: Re: [PATCH] drivers: staging: rtl8821ae: Fix spaces required around
 that '?' errors
From: Joe Perches <joe@perches.com>
To: Greg Donald <gdonald@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Aug 2014 06:56:04 -0700
In-Reply-To: <CAO+WgCY8Ugv17WMEe0TEn0ruf9HAF=uNZ12OKjZmehsO6kvZ1Q@mail.gmail.com>
References: <1408966502-22350-1-git-send-email-gdonald@gmail.com>
	 <1408972519.20683.41.camel@joe-AO725>
	 <CAO+WgCY8Ugv17WMEe0TEn0ruf9HAF=uNZ12OKjZmehsO6kvZ1Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-25 at 08:51 -0500, Greg Donald wrote:
> On Mon, Aug 25, 2014 at 8:15 AM, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2014-08-25 at 06:35 -0500, Greg Donald wrote:
> >> Fix checkpatch.pl spaces required around that '?' errors
> >
> > It'd be better to convert all parts of the
> > ternary at the same time.
> 
> Wouldn't "at the same time" be in direct conflict with the "only do
> one thing per patch" rule?

No because these are both whitespace changes
around a ternary.

As far as I'm concerned, a single patch to do
all horizontal whitespace corrections at the
same time is just fine.

Just make sure to check your changes don't modify
anything with git diff -w and scripts/objdiff.

> > A subsequent change might be to remove the unnecessary
> > parentheses like:
> >
> >                     force_exec ? "force to" : "", dec_bt_pwr ? "ON" : "OFF");
> 
> I understand.  It's very likely I'll submit such a patch in the future.
> 
> I'm currently attempting to keep my cleanups to a single error/warning
> type so I get as much done as possible per patch while also keeping
> the patch easy to review.  Is this wrong?

No, it's the appropriate thing to do.

