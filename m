Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3BCKPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 05:15:35 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:45605 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3BCKPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 05:15:33 -0500
Date: Sun, 3 Feb 2013 11:15:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/11] [GIT PULL] tracing: Various tracing fixes and
 enhancements
Message-ID: <20130203101528.GA9330@gmail.com>
References: <20130202141842.189550803@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130202141842.189550803@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: d840f718d28715a9833c1a8f46c2493ff3fd219b
> 
> 
> Hiraku Toyooka (3):
>       tracing: Replace static old_tracer check of tracer name
>       tracing: Make a snapshot feature available from userspace
>       tracing: Add documentation of snapshot utility
> 
> Josh Triplett (1):
>       tracing: Mark tracing_dentry_percpu() static
> 
> Jovi Zhang (1):
>       tracing: Remove second iterator initializer
> 
> Namhyung Kim (1):
>       tracing: Use sched_clock_cpu for trace_clock_global
> 
> Shan Wei (1):
>       tracing: Use __this_cpu_inc/dec operation instead of __get_cpu_var
> 
> Steven Rostedt (1):
>       tracing: Remove tracepoint sample code
> 
> Steven Rostedt (Red Hat) (3):
>       tracing/fgraph: Adjust fgraph depth before calling trace return callback
>       ring-buffer: Add stats field for amount read from trace ring buffer
>       tracing: Init current_trace to nop_trace and remove NULL checks
> 
> ----
>  Documentation/trace/ftrace.txt                 |   83 +++++++++
>  include/linux/ftrace_event.h                   |    3 +
>  include/linux/ring_buffer.h                    |    1 +
>  kernel/trace/Kconfig                           |   10 ++
>  kernel/trace/ring_buffer.c                     |   18 ++
>  kernel/trace/trace.c                           |  222 +++++++++++++++++-------
>  kernel/trace/trace.h                           |    1 +
>  kernel/trace/trace_clock.c                     |    2 +-
>  kernel/trace/trace_functions_graph.c           |    8 +-
>  samples/Kconfig                                |    6 -
>  samples/Makefile                               |    2 +-
>  samples/tracepoints/Makefile                   |    6 -
>  samples/tracepoints/tp-samples-trace.h         |   11 --
>  samples/tracepoints/tracepoint-probe-sample.c  |   57 ------
>  samples/tracepoints/tracepoint-probe-sample2.c |   44 -----
>  samples/tracepoints/tracepoint-sample.c        |   57 ------
>  16 files changed, 288 insertions(+), 243 deletions(-)

Pulled, thanks Steve!

	Ingo
