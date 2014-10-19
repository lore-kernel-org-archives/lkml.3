Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaJSVb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 17:31:28 -0400
Received: from smtprelay0009.hostedemail.com ([216.40.44.9]:54762 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751120AbaJSVb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 17:31:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3870:3871:3872:3874:4321:5007:6119:6226:6261:7903:8700:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13160:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sand97_297b517ebed06
X-Filterd-Recvd-Size: 1674
Message-ID: <1413754284.7076.1.camel@perches.com>
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>
Date: Sun, 19 Oct 2014 14:31:24 -0700
In-Reply-To: <CA+55aFwbq4TtQXC9PTjOF3UPP7u8XH1mSYjvT7pevKcQBfy25A@mail.gmail.com>
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
	 <CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
	 <1413750239.14629.17.camel@perches.com>
	 <CA+55aFwbq4TtQXC9PTjOF3UPP7u8XH1mSYjvT7pevKcQBfy25A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-19 at 13:46 -0700, Linus Torvalds wrote:
> On Oct 19, o2014 1:24 PM, "Joe Perches" <joe@perches.com> wrote:
> >
> > I think it'd be moderately painful.
> >
> > There are ~1000 uses of variables like "<some_type> new" in the kernel.
> 
> So? That's not a C11 violation last I saw. The whole "new" keyword is still
> just a C++ problem AFAIK.
> 
> And if that is some stupid gcc5 thing, maybe just turning off that
> particular gcc  bug is possible?

My mistake, false premise.

Use of the <some_type> new is not an issue with
gcc 4.9 -std=gnu11.


