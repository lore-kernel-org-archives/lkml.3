Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3KLCys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:54:48 -0500
Received: from smtprelay0057.hostedemail.com ([216.40.44.57]:37685 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751385Ab3KLCyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:54:40 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: vase39_7fb77eaebc153
X-Filterd-Recvd-Size: 2053
Message-ID: <1384224883.4771.28.camel@joe-AO722>
Subject: Re: [tip:x86/asm] x86, bitops:  Change bitops to be native operand
 size
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-arch <linux-arch@vger.kernel.org>,
        mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        james.t.kukunas@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>
Date: Mon, 11 Nov 2013 18:54:43 -0800
In-Reply-To: <5281698F.9080808@linux.intel.com>
References: <tip-z61ofiwe90xeyb461o72h8ya@git.kernel.org>
	 <1384117768.3081.10.camel@joe-AO722>
	 <5ac67859-a0b2-47f5-bdc2-c2a52b8d6885@email.android.com>
	 <1384123457.3081.33.camel@joe-AO722> <52803BA2.2080908@zytor.com>
	 <1384136570.4771.5.camel@joe-AO722> <5281698F.9080808@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-11 at 15:34 -0800, H. Peter Anvin wrote:
> On 11/10/2013 06:22 PM, Joe Perches wrote:
> > 
> > Perhaps the current x86 bitops asm code is being conflated
> > with the ideal implementation?
> > 
> Yes, by you.

Really?  I don't think so.

How does the use of signed long for an index where
no negative values are possible or the use of a
negative int for BIT_MASK make sense?

> x86 has instructions that operate on signed bitindicies.

indices.

> It doesn't
> have instructions that operate on unsigned bitindicies.  Unless someone
> is willing to do the work to prove that shift and mask is actually
> faster than using the hardware instructions (which I doubt, but it is
> always a possibility), that's what we have.

That doesn't mean x86 is the ideal implementation.


