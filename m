Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613Ab3HOIB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 04:01:57 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:45359 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab3HOIBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 04:01:51 -0400
Date: Thu, 15 Aug 2013 10:01:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH tip/perf/core 0/3] [GIT PULL][3.12] tracing/perf:
 Optimization for perf tracing
Message-ID: <20130815080147.GA29469@gmail.com>
References: <20130815020104.813498803@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815020104.813498803@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> These three patches from Oleg are more perf related, but they
> are based on some of the updates that Oleg did that are in 3.11-rc5.
> 
> I based this work off of v3.11-rc5 as it seems that tip/perf/core is
> still based on 3.11-rc1. You may want to merge Linus's 3.11-rc5 before
> pulling this.
> 
> All the patches have been acked by Peter Zijlstra.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: d027e6a9c83440bf1ca9e5503539d58d8e0914f1
> 
> 
> Oleg Nesterov (3):
>       tracing/perf: Expand TRACE_EVENT(sched_stat_runtime)
>       tracing/perf: Reimplement TP_perf_assign() logic
>       tracing/perf: Avoid perf_trace_buf_*() in perf_trace_##call() when possible
> 
> ----
>  include/trace/events/sched.h |   22 ++++++++--------------
>  include/trace/ftrace.h       |   33 ++++++++++++++++++++-------------
>  2 files changed, 28 insertions(+), 27 deletions(-)

Pulled, thanks guys!

	Ingo
