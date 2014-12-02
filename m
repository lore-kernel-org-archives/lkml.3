Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbaLBD53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 22:57:29 -0500
Received: from smtprelay0091.hostedemail.com ([216.40.44.91]:35386 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932758AbaLBD52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 22:57:28 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3350:3622:3866:3867:3871:3872:3874:5007:6261:7875:10004:10400:10848:10967:11232:11658:11914:12050:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: heat56_5e295a0f36c52
X-Filterd-Recvd-Size: 1455
Date: Mon, 1 Dec 2014 22:57:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Checking to see if a bit is _not_ set in a ftrace event filter
Message-ID: <20141201225725.1e94aa66@gandalf.local.home>
In-Reply-To: <CAMEtUuzEg39N9ZALuq-u4X+oaNJGqL6G05UABSHYpejQ78Cp3Q@mail.gmail.com>
References: <20141202021912.GA29096@thunk.org>
	<20141201214104.32d3f10d@gandalf.local.home>
	<CAMEtUuzEg39N9ZALuq-u4X+oaNJGqL6G05UABSHYpejQ78Cp3Q@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 19:52:11 -0800
Alexei Starovoitov <ast@plumgrid.com> wrote:

> yeah. teaching tree walk to do (state & 2048) == 0 is not trivial,
> since it doesn't have a concept of value of expression.
> Doing !(state & 2048) is probably a bit easier, since there
> are hacks for 'not' already.

That's exactly what I was looking at doing. If I can get something
working without spending more than an hour or two, I may even push it
for this release cycle.

-- Steve

