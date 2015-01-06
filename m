Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbbAFS5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:57:47 -0500
Received: from smtprelay0176.hostedemail.com ([216.40.44.176]:40073 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751159AbbAFS5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:57:46 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2737:2828:2911:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3873:3874:4321:4425:5007:6117:6119:6261:7903:7974:10004:10400:10848:11232:11658:11914:12050:12517:12519:12663:12740:13069:13137:13150:13230:13231:13311:13357:13618:13868:14039:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pin03_6097c08b9d84b
X-Filterd-Recvd-Size: 2114
Message-ID: <1420570662.2652.36.camel@perches.com>
Subject: Re: kgdb-next not pushed to Linus for 3.19
From: Joe Perches <joe@perches.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 06 Jan 2015 10:57:42 -0800
In-Reply-To: <54AC2F5D.9050405@linaro.org>
References: <54AC2F5D.9050405@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-06 at 18:54 +0000, Daniel Thompson wrote:
> Hi Jason
> 
> I'm trying to figure out what to do with my long-outstanding kgdb/kdb
> patches in preparation for the 3.20 merge window.
> 
> As of now I have five pending patch sets some of which are well over six
> months old (and none have nay outstanding review comments).
> 
> When I raised this with you a couple of months ago, two of the patch
> sets did land in your kgdb-next tree. However nothing seems to have
> happened since then and I couldn't find any messages from you during the
> 3.19 merge window.
> 
> I'm afraid I don't know what else I need to do to progress things.
> 
> I do plan to do routine rebasing and resending of my patchsets but,
> based on the past experience, that seems unlikely to be enough to get
> the code delivered in 3.20.
> 
> Do you think I would be better sending these patches via someone else?
> In any case, advice would be very welcome.

Andrew?

I think Daniel's kgdb patches are bug fixes.

Can you please pick them up?


