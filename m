Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaJSUYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 16:24:12 -0400
Received: from smtprelay0060.hostedemail.com ([216.40.44.60]:52467 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751153AbaJSUYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 16:24:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3870:3871:3872:4321:5007:6119:6261:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dime14_23671de8e2925
X-Filterd-Recvd-Size: 1502
Message-ID: <1413750239.14629.17.camel@perches.com>
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 19 Oct 2014 13:23:59 -0700
In-Reply-To: <CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
	 <CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-19 at 13:05 -0700, Linus Torvalds wrote:
> On Sun, Oct 19, 2014 at 9:07 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> > gcc5 changes the default standard to c11, rather than gnu89, which
> > makes kernel build unhappy.
> 
> Hmm. Just how unhappy does it make it? Maybe we can instead try to
> make the build happier with some minimal changes? Or is it really
> painful?

I think it'd be moderately painful.

There are ~1000 uses of variables like "<some_type> new" in the kernel.

