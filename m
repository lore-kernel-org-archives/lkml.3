Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3KGX7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:59:38 -0500
Received: from smtprelay0126.hostedemail.com ([216.40.44.126]:57902 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753652Ab3KGX7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:59:31 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3867:3868:3870:3871:3872:3873:3874:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12295:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shop74_6feff24c60d0e
X-Filterd-Recvd-Size: 2521
Message-ID: <1383868777.9263.39.camel@joe-AO722>
Subject: Re: [trivial PATCH] module.h: Remove unnecessary semicolon
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 07 Nov 2013 15:59:37 -0800
In-Reply-To: <877gcj6c3v.fsf@rustcorp.com.au>
References: <1383685095.4387.45.camel@joe-AO722>
	 <87zjph55px.fsf@rustcorp.com.au> <1383800991.7940.51.camel@joe-AO722>
	 <877gcj6c3v.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-08 at 09:41 +1030, Rusty Russell wrote:
> Joe Perches <joe@perches.com> writes:
> > On Thu, 2013-11-07 at 12:32 +1030, Rusty Russell wrote:
> >> Joe Perches <joe@perches.com> writes:
> >> > This semicolon isn't necessary, remove it.
> >> >
> >> > Signed-off-by: Joe Perches <joe@perches.com>
> >> 
> >> This is a terrible description.  Really bad.
> >
> > I'd've preferred no description.
> 
> Me too.
> 
> >> First, it just repeats the subject, with more words.
> >
> > Which others have demanded.
> 
> They're wrong.

shrug.  Can't please everyone.

> >> Second, it gives me no indication that you've done a grep to make sure
> >> noone is abusing the macro, so I can't apply it without doing that check
> >> myself.
> >
> > That's a trust issue.
> > I've done it.  It isn't necessary.
> 
> WTF?  Now you just said it's not necessary, I *know* I can't trust you.

"It" in this case is the grep that I did
prior to sending the patch.

> > The other #define module_put_and_exit in a
> > different #if #else already doesn't have one.
> 
> You didn't mention this, and even if you did, it's not sufficient.  Some
> code only ever gets compiled as a module, so it'd never hit the
> !CONFIG_MODULES case.

Which would only show there was a latent bug.

> > Trust it or not, apply it or not.
> 
> Now I know when I receive a patch from you I have to check it carefully,
> because you can't be bothered.

Sure.  If you think so.
Nonetheless, I told you I'd checked it.

> I've fixed your patch, you can find it below.

No, not really fixed.  You modified the commit log to
suit your taste.

cheers, Joe


