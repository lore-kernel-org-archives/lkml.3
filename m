Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3GTPqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 11:46:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab3GTPqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 11:46:18 -0400
Date: Sat, 20 Jul 2013 17:40:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] Teach perf_trace_##call() to check
	hlist_empty(perf_events)
Message-ID: <20130720154040.GA1169@redhat.com>
References: <20130718183018.GA4043@redhat.com> <20130719074339.GA22597@gmail.com> <1374265641.3356.31.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374265641.3356.31.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19, Steven Rostedt wrote:
>
> On Fri, 2013-07-19 at 09:43 +0200, Ingo Molnar wrote:
> >
> > Peter, Steve, any objections?
> >
>
> Yep, agreed.
>
>
> The whole series...
>
> Reviewed-and-Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thanks!

But, to avoid the confusion, please do not forget that this series
textually depends on cd92bf61 "Move the PERF_MAX_TRACE_SIZE check
into perf_trace_buf_prepare()" in your tree. So this should be
routed via rostedt/linux-trace as well.

Oleg.

