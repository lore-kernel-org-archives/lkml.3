Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3HFQO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:14:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab3HFQO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:14:27 -0400
Date: Tue, 6 Aug 2013 18:08:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Teach perf_trace_##call() to check
	hlist_empty(perf_events)
Message-ID: <20130806160826.GA2717@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05, Steven Rostedt wrote:
>
> > Sorry... should I resend once again ?
>
> Sure, why not. It's only 3 patches :-)

OK. Added "v2" to avoid the confusion.

The only change is

	- Reviewed-and-Acked-by: Steven Rostedt <rostedt@goodmis.org>
	+ Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
	+ Acked-by: Steven Rostedt <rostedt@goodmis.org>
	
> I wonder if the Reviewed-by assumes the Acked-by?

I dunno. But since you gave me both, I'd better preserve them all.

Oleg.

 include/trace/events/sched.h |   22 ++++++++--------------
 include/trace/ftrace.h       |   33 ++++++++++++++++++++-------------
 2 files changed, 28 insertions(+), 27 deletions(-)

