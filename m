Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3GWCkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:40:12 -0400
Received: from mx11.netapp.com ([216.240.18.76]:20332 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab3GWCkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:40:10 -0400
X-IronPort-AV: E=Sophos;i="4.89,723,1367996400"; 
   d="scan'208";a="35702967"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Thread-Topic: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Thread-Index: AQHOgZF64KBTv4md/0uNlNK9ZDV2fJlyDhiA
Date: Tue, 23 Jul 2013 02:40:09 +0000
Message-ID: <1374547207.2413.7.camel@leira.trondhjem.org>
References: <1373916476.2748.69.camel@dabdike>
In-Reply-To: <1373916476.2748.69.camel@dabdike>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7872ED80076C9341A8B8D7A9825888E6@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6N2eIY0015393

On Mon, 2013-07-15 at 23:27 +0400, James Bottomley wrote:
> Before the "3.10.1-stable review" thread degenerated into a disagreement
> about habits of politeness, there were some solid points being made
> which, I think, bear consideration and which may now be lost.
> 
> The problem, as JiÅ™Ã­ Kosina put is succinctly is that the distributions
> are finding stable less useful because it contains to much stuff they'd
> classify as not stable material.
> 
> The question that arises from this is who is stable aiming at ...
> because if it's the distributions (and that's what people seem to be
> using it for) then we need to take this feedback seriously.
> 
> The next question is how should we, the maintainers, be policing commits
> to stable.  As I think has been demonstrated in the discussion the
> "stable rules" are more sort of guidelines (apologies for the pirates
> reference).  In many ways, this is as it should be, because people
> should have enough taste to know what constitutes a stable fix.  The
> real root cause of the problem is that the cc: stable tag can't be
> stripped once it's in the tree, so maintainers only get to police things
> they put in the tree.  Stuff they pull from others is already tagged and
> that tag can't be changed.  This effectively pushes the problem out to
> the lowest (and possibly more inexperienced) leaves of the Maintainer
> tree.  In theory we have a review stage for stable, but the review
> patches don't automatically get routed to the right mailing list and the
> first round usually comes out in the merge window when Maintainers'
> attention is elsewhere.
> 
> The solution, to me, looks simple:  Let's co-opt a process we already
> know how to do: mailing list review and tree handling.  So the proposal
> is simple:
> 
>      1. Drop the cc: stable@ tag: it makes it way too easy to add an ill
>         reviewed patch to stable
>      2. All patches to stable should follow current review rules: They
>         should go to the mailing list the original patch was sent to
>         once the original is upstream as a request for stable.
>      3. Following debate on the list, the original maintainer would be
>         responsible for collecting the patches (including the upstream
>         commit) adjudicating on them and passing them on to stable after
>         list review (either by git tree pull or email to stable@).
> 
> I contend this raises the bar for adding patches to stable much higher,
> which seems to be needed, and adds a review stage which involves all the
> original reviewers.

Could we keep the Cc: stable tag itself, since the dependency
information ("Cc: <stable@vger.kernel.org> # 3.3.x: a1f84a3: sched:
Check for idle") is actually very useful? If we discard that, then we
really should revise the whole stable system, since it would mean that
we are in effect discarding the 'upstream first' rule.
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
