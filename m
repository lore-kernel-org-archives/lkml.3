Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab3KLEId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 23:08:33 -0500
Received: from smtprelay0074.hostedemail.com ([216.40.44.74]:54379 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750991Ab3KLEIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 23:08:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3871:3873:3874:4321:5007:6119:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13200:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wrist37_2bf74a8862120
X-Filterd-Recvd-Size: 1780
Message-ID: <1384229308.4771.35.camel@joe-AO722>
Subject: Re: [tip:x86/asm] x86, bitops: Change bitops to be native operand
 size
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, james.t.kukunas@intel.com,
        David Miller <davem@davemloft.net>
Date: Mon, 11 Nov 2013 20:08:28 -0800
In-Reply-To: <CA+55aFxsNB0BVg-fdzsu_jkPLpiba1rgTcrUOe7W2tN-mHTnBg@mail.gmail.com>
References: <tip-z61ofiwe90xeyb461o72h8ya@git.kernel.org>
	 <1384117768.3081.10.camel@joe-AO722>
	 <5ac67859-a0b2-47f5-bdc2-c2a52b8d6885@email.android.com>
	 <1384123457.3081.33.camel@joe-AO722> <52803BA2.2080908@zytor.com>
	 <1384136570.4771.5.camel@joe-AO722> <5281698F.9080808@linux.intel.com>
	 <1384224883.4771.28.camel@joe-AO722>
	 <CA+55aFxsNB0BVg-fdzsu_jkPLpiba1rgTcrUOe7W2tN-mHTnBg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 12:15 +0900, Linus Torvalds wrote:
> Talking about "ideal implementation" is also singularly stupid.

I just want the various arch implementations to match
the docs.  I know that's stupid.

Maybe if you really don't want to discuss things, you
should fix the documentation.

Documentation/atomic_ops.txt


