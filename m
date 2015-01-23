Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbbAWV5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 16:57:15 -0500
Received: from smtprelay0110.hostedemail.com ([216.40.44.110]:34060 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750956AbbAWV5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 16:57:13 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2911:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3874:4425:4605:5007:6261:7875:7903:10004:10400:10848:10967:11026:11232:11658:11914:12043:12266:12438:12517:12519:12555:12663:12740:13069:13311:13357:14096:14097:21080:21121,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sink05_216aa1e56b203
X-Filterd-Recvd-Size: 2424
Date: Fri, 23 Jan 2015 16:57:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] tracing: Some clean ups that will help tracefs
Message-ID: <20150123165708.50263a80@gandalf.local.home>
In-Reply-To: <20150123215010.626661716@goodmis.org>
References: <20150123215010.626661716@goodmis.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015 16:50:10 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> I added these two patches before applying my tracefs changes.
> I'm still waiting on review from Al or Greg from tracefs, but these
> fixes are just some clean ups that are unrelated. But should go into
> linux-next now anyway.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> for-next

I forgot to add my [for-next] in the subject. But I think it's pretty
obvious (I hope).

-- Steve

> 
> Head SHA1: 14a5ae40f0def33a422a45b2ed09198adb7bf11c
> 
> 
> Steven Rostedt (Red Hat) (2):
>       tracing: Remove unneeded includes of debugfs.h and fs.h
>       tracing: Use IS_ERR() check for return value of tracing_init_dentry()
> 
> ----
>  kernel/trace/ftrace.c                | 2 +-
>  kernel/trace/ring_buffer.c           | 2 --
>  kernel/trace/trace.c                 | 8 ++++----
>  kernel/trace/trace_branch.c          | 1 -
>  kernel/trace/trace_events.c          | 2 +-
>  kernel/trace/trace_export.c          | 2 --
>  kernel/trace/trace_functions_graph.c | 2 +-
>  kernel/trace/trace_irqsoff.c         | 2 --
>  kernel/trace/trace_kprobe.c          | 2 +-
>  kernel/trace/trace_nop.c             | 2 --
>  kernel/trace/trace_printk.c          | 4 +---
>  kernel/trace/trace_sched_switch.c    | 2 --
>  kernel/trace/trace_sched_wakeup.c    | 2 --
>  kernel/trace/trace_stack.c           | 4 +---
>  kernel/trace/trace_stat.c            | 2 +-
>  kernel/trace/trace_uprobe.c          | 2 +-
>  16 files changed, 12 insertions(+), 29 deletions(-)

