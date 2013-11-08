Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab3KHBsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 20:48:38 -0500
Received: from smtprelay0188.hostedemail.com ([216.40.44.188]:36062 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752964Ab3KHBsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 20:48:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2828:2917:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6248:7652:7875:7903:10004:10394:10400:10848:11026:11232:11658:11914:12219:12295:12517:12519:12663:12740:13069:13071:13095:13137:13150:13230:13231:13311:13357:14039,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jail74_2dcfb478ba429
X-Filterd-Recvd-Size: 2911
Message-ID: <1383875323.9263.52.camel@joe-AO722>
Subject: Re: [trivial PATCH] module.h: Remove unnecessary semicolon
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 07 Nov 2013 17:48:43 -0800
In-Reply-To: <87bo1v4rbf.fsf@rustcorp.com.au>
References: <1383685095.4387.45.camel@joe-AO722>
	 <87zjph55px.fsf@rustcorp.com.au> <1383800991.7940.51.camel@joe-AO722>
	 <877gcj6c3v.fsf@rustcorp.com.au> <1383868777.9263.39.camel@joe-AO722>
	 <87bo1v4rbf.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-08 at 11:56 +1030, Rusty Russell wrote:
> Joe Perches <joe@perches.com> writes:
> > On Fri, 2013-11-08 at 09:41 +1030, Rusty Russell wrote:
> >> Joe Perches <joe@perches.com> writes:
> >> > That's a trust issue.
> >> > I've done it.  It isn't necessary.
> >> 
> >> WTF?  Now you just said it's not necessary, I *know* I can't trust you.
> >
> > "It" in this case is the grep that I did
> > prior to sending the patch.
> 
> Hi Joe,

Hi Rusty.

> Apologies for my off tone.  But I think we got tangled somewhere?
> You said "It isn't necessary".
> 
> You maintain that grepping the source to find out if you'd broken
> something "isn't necessary"?
> 
> git history shows me you've done lots of these cleanups.  I'm pretty
> sure that's not what you meant.

Yeah, I think we did get a little crossed up there.

No, grep and compiling changes are fundamentals
before submitting trivial patches.

What I meant was I had done the grep (and compile
allyesconfig/allmodconfig of the files that use
module_put_and_exit) before sending the patch.

I don't think those are important details for a
commit message.

Dunno if you noticed that I attached the grep results
in my 1st reply.

Sometimes I do put details below the separator
--- line after the signed-off-by.

(I'll also admit I've sent patches without doing
 the appropriate checks and screwed them up.
 Lessons semi-learned)

> But as maintainer, it's annoying that I had to check myself.  I don't
> have personal experience in how diligent you are.  If you'd just
> mentioned it, it would have saved me a few minutes and streamlined my
> workflow immensely. 
> 
> Providing assurance makes me a happy maintainer.  So I modified it
> because it sets a clear example for others.
> 
> I hope that clarifies,
> Rusty.

No worries.  Unfamiliarity also does have its own
set of issues.   No problems on my side.  Hope you
don't any any this way either.

cheers, Joe

