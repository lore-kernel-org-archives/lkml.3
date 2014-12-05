Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaLEH5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 02:57:43 -0500
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:42705 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750891AbaLEH5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 02:57:40 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2734:2828:2895:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6119:6261:7901:7903:9036:10004:10400:10848:11232:11658:11914:12219:12517:12519:12740:13069:13161:13229:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fall15_258ad6eac4b02
X-Filterd-Recvd-Size: 3321
Message-ID: <1417766255.2721.43.camel@perches.com>
Subject: Re: [PATCH v2 1/6] net-PPP: Replacement of a printk() call by
 pr_warn() in mppe_rekey()
From: Joe Perches <joe@perches.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Date: Thu, 04 Dec 2014 23:57:35 -0800
In-Reply-To: <54815C5F.8090702@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	 <530B5FB6.6010207@users.sourceforge.net>
	 <alpine.DEB.2.10.1402241710370.2074@hadrien>
	 <530C5E18.1020800@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251014170.2080@hadrien>
	 <530CD2C4.4050903@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251840450.7035@hadrien>
	 <530CF8FF.8080600@users.sourceforge.net>
	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	 <530DD06F.4090703@users.sourceforge.net>
	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	 <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net>
	 <547B496E.604@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com>
	 <547C82A6.2030808@users.sourceforge.net>
	 <547CA157.1080401@cogentembedded.com>
	 <5480DA32.8000201@users.sourceforge.net>
	 <5480DBDE.7040604@users.sourceforge.net>
	 <1417731809.2721.17.camel@perches.com>
	 <5480DFB5.4090708@users.sourceforge.net>
	 <1417733101.2721.20.camel@perches.com>
	 <54815C5F.8090702@users.sourceforge.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 08:18 +0100, SF Markus Elfring wrote:
> >>> It's generally nicer to replace embedded function names
> >>> with "%s: ", __func__
> >>>
> >>> 			pr_warn("%s: cipher_encrypt failed\n", __func__);
> >>
> >> Do you want that I send a third patch series for the fine-tuning of these parameters?
> > 
> > If you want.
> 
> Would "a committer" fix such a small source code adjustment also without a resend of
> a patch series?

Depends on the committer.  Some might, most wouldn't.

drivers/net/ppp doesn't have a specific maintainer.

The networking maintainer generally asks for resends
of patches that don't suit his taste, but lots of
non-perfect patches still get applied there.

It's a process, and it's not immediate.  Wait to see
if these get applied as-is.  If the embedded function
name use, which is trivial, bothers you, send another
patch later on that changes it.

> Does it make sense to express such implementation details in the Linux coding
> style documentation more explicitly (besides the fact that this update suggestion
> was also triggered by a warning from the script "checkpatch.pl").

Probably not.

Overly formalized coding style rules are perhaps
more of a barrier to entry than most want.


