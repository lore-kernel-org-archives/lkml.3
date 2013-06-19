Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934661Ab3FSMK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:10:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40452 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934297Ab3FSMKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:10:55 -0400
Date: Wed, 19 Jun 2013 14:10:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing/perf: perf_trace_buf/perf_xxx hacks.
Message-ID: <20130619121039.GA19225@twins.programming.kicks-ass.net>
References: <20130618192147.GA19443@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618192147.GA19443@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 09:21:47PM +0200, Oleg Nesterov wrote:
> Hello.
> 
> On top of "PATCH 0/3] tracing: more list_empty(perf_events) checks"
> series I sent yesterday.
> 
> Compile tested only, not for inclusion yet.
> 
> But I'll appreciate if you can take a look. I'll try to test this
> tomorrow somehow and let you know. Right now I am looking at asm code,
> looks correct...
> 
> I also compiled the kernel with the additional patch below, everything
> compiles except sched/core.o as expected.
> 

I'm probably missing something obviuos, but what are we trying to do?
