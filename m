Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaJ3EjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:39:14 -0400
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:41384 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750724AbaJ3EjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:39:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3871:3874:4321:5007:6261:7903:10004:10400:10848:10967:11026:11232:11658:11914:12114:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nose93_89afa6a817863
X-Filterd-Recvd-Size: 1540
Message-ID: <1414643944.16109.1.camel@perches.com>
Subject: Re: [RFA][PATCH 1/8] seq_file: Rename seq_overflow() to
 seq_has_overflowed() and make public
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Wed, 29 Oct 2014 21:39:04 -0700
In-Reply-To: <20141029202756.70cb1f27@gandalf.local.home>
References: <20141029215602.535533597@goodmis.org>
	 <20141029220107.333126455@goodmis.org>
	 <1414620516.2542.3.camel@perches.com>
	 <20141029202045.1988662c@gandalf.local.home>
	 <20141029202756.70cb1f27@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 20:27 -0400, Steven Rostedt wrote:
> On Wed, 29 Oct 2014 20:20:45 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> > I'll change the comment about that.
> 
> How's this?

Fine, but I think whether a function is inlined or
not is largely irrelevant to functionality.

cheers, Joe

> Move the seq_overflow() to a global inlined function called
> seq_has_overflowed() that can be used by the users of
> seq_file() calls.

