Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab3GZPZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:25:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425Ab3GZPZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:25:50 -0400
Date: Fri, 26 Jul 2013 17:20:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] Teach perf_trace_##call() to check
	hlist_empty(perf_events)
Message-ID: <20130726152010.GA20520@redhat.com>
References: <20130718183018.GA4043@redhat.com> <20130719074339.GA22597@gmail.com> <1374265641.3356.31.camel@gandalf.local.home> <20130720154040.GA1169@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130720154040.GA1169@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20, Oleg Nesterov wrote:
>
> On 07/19, Steven Rostedt wrote:
> >
> > On Fri, 2013-07-19 at 09:43 +0200, Ingo Molnar wrote:
> > >
> > > Peter, Steve, any objections?
> > >
> >
> > Yep, agreed.
> >
> >
> > The whole series...
> >
> > Reviewed-and-Acked-by: Steven Rostedt <rostedt@goodmis.org>
>
> Thanks!
>
> But, to avoid the confusion, please do not forget that this series
> textually depends on cd92bf61 "Move the PERF_MAX_TRACE_SIZE check
> into perf_trace_buf_prepare()" in your tree. So this should be
> routed via rostedt/linux-trace as well.

Update. cd92bf61 is already in Linus's tree.

So, Ingo, if you were going to take these patches - please ;)

It seems that everybody agree with this hack. Please tell me
if I should resend this series once again or make a small branch
for git-pull.

Oleg.

