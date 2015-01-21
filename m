Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbbAURc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:32:56 -0500
Received: from smtprelay0117.hostedemail.com ([216.40.44.117]:41087 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751546AbbAURct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:32:49 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:1801:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3351:3622:3870:3872:3876:4605:5007:6261:7875:7903:10004:10400:10848:10967:11026:11232:11658:11914:12043:12291:12438:12517:12519:12683:12740:13069:13311:13357:14096:14097:14110:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plane50_52334cfd21c33
X-Filterd-Recvd-Size: 1835
Date: Wed, 21 Jan 2015 12:32:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150121123243.26c4846c@gandalf.local.home>
In-Reply-To: <20150121171953.823177070@goodmis.org>
References: <20150121171953.823177070@goodmis.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 12:19:53 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:


> ----
>  fs/Makefile                          |   1 +
>  fs/tracefs/Makefile                  |   4 +
>  fs/tracefs/inode.c                   | 649 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/magic.h           |   2 +
>  kernel/trace/ftrace.c                |  22 +-
>  kernel/trace/trace.c                 | 178 +++++-----
>  kernel/trace/trace.h                 |   2 +-
>  kernel/trace/trace_events.c          |  32 +-
>  kernel/trace/trace_functions_graph.c |   7 +-
>  kernel/trace/trace_kprobe.c          |  10 +-
>  kernel/trace/trace_probe.h           |   2 +-
>  kernel/trace/trace_stat.c            |  10 +-


>  scripts/tags.sh                      |   2 +-

Ignore this file. It was added by mistake (will remove in next version).

-- Steve

>  13 files changed, 789 insertions(+), 132 deletions(-)

