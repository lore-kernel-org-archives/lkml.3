Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab3FSSY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:24:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16378 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab3FSSY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:24:56 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=zqzIAArZTo8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6_eBa1HtGUEA:10 a=dA54dtIphaX0n7To6xEA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371666293.18733.52.camel@gandalf.local.home>
Subject: Re: [PATCH 3/3] tracing/perf: Avoid perf_trace_buf_*() in
 perf_trace_##call() when possible
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Jun 2013 14:24:53 -0400
In-Reply-To: <20130619181211.GA28363@redhat.com>
References: <20130618192218.GA19476@redhat.com>
	 <1371585773.18733.45.camel@gandalf.local.home>
	 <20130619181211.GA28363@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 20:12 +0200, Oleg Nesterov wrote:

> > Or is this your way to confuse me as much as my code has confused
> > you? ;-)
> 
> Of course! this was the main reason.

I knew it!

> 
> 
> Steven, I convinced myself the patch should be correct. If you agree with
> this hack:
> 
> 	- anything else I should do apart from the change above?
> 
> 	- should I resend the previous "[PATCH 0/3] tracing: more
> 	  list_empty(perf_events) checks" series?
> 
> 	  This series depends on "[PATCH 3/3] tracing/perf: Move the
> 	  PERF_MAX_TRACE_SIZE check into perf_trace_buf_prepare()".
> 
> 	  Or I can drop this patch if you do not like it and rediff.
> 
> 	  Just in case, there are other pending patches in trace_kprobe.c
> 	  which I am going to resend, but they are orthogonal.

I'll pull in the patches and play with them. I'll let you know what I
find.

Thanks,


-- Steve


