Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbaD1T2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:28:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:42190 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923AbaD1T2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:28:49 -0400
Date: Mon, 28 Apr 2014 19:48:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.02.1404281947300.6261@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu> <20140417094815.GA9348@gmail.com> <20140417114533.GJ11096@twins.programming.kicks-ass.net> <20140417142213.GA29338@gmail.com>
 <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu> <20140417145418.GM11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu> <20140418152314.GY11182@twins.programming.kicks-ass.net>
 <20140418165958.GQ13658@twins.programming.kicks-ass.net> <20140418171516.GR13658@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, Vince Weaver wrote:
 
> I got the bug to trigger again, this time it finally managed to hit a 
> debug_objects WARNING if that's any additional help.
> 
> The bug followed the same pattern, software event 
> (PERF_TYPE_SOFTWARE / PERF_COUNT_SW_TASK_CLOCK) created, fork happens,
> event closes in parent, child killed, rcu grace period expires and kfree
> but event still active.
> 
> here's the kernel message followed by excerpts from the trace, I can 
> provide full trace if anyone cares.

I care :)

Thanks,

	tglx

