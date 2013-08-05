Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3HES5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:57:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410Ab3HES5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:57:33 -0400
Date: Mon, 5 Aug 2013 20:51:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tracing/perf: Expand
	TRACE_EVENT(sched_stat_runtime)
Message-ID: <20130805185133.GA12101@redhat.com>
References: <20130805165056.GA6366@redhat.com> <1375726091.22073.106.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375726091.22073.106.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05, Steven Rostedt wrote:
>
> On Mon, 2013-08-05 at 18:50 +0200, Oleg Nesterov wrote:
>
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > Tested-by: David Ahern <dsahern@gmail.com>
> > Reviewed-and-Acked-by: Steven Rostedt <rostedt@goodmis.org>
>
> Just so you know. The standard that we now want to live by is only one
> tag per line. I know I gave you that tag in my email, but when adding it
> to a patch it needs to be:
>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>
> I wonder if the Reviewed-by assumes the Acked-by? Anyway, if you add
> both, it needs to be like that.

Sorry... should I resend once again ?

Oleg.

