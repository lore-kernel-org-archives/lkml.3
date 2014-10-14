Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaJNSBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 14:01:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbaJNSBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 14:01:17 -0400
Date: Tue, 14 Oct 2014 19:57:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] sched: make finish_task_switch() return struct rq *
Message-ID: <20141014175745.GA32617@redhat.com>
References: <20141007195046.GA28002@redhat.com> <20141009193207.GA5408@redhat.com> <20141009193232.GB5408@redhat.com> <20141010100643.GI10832@worktop.programming.kicks-ass.net> <20141010170641.GB14401@redhat.com> <20141010203220.GC3343@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010203220.GC3343@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10, Peter Zijlstra wrote:
>
> On Fri, Oct 10, 2014 at 07:06:42PM +0200, Oleg Nesterov wrote:
> >
> > I am travelling till next Wednesday, will resend everything once I return.
>
> Not towards DUS by any chance?

No, Moscow ;)

> I fixed up the patches, they should be in
> here:
>   https://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git/log/?h=sched/core

Thanks! In particular thanks for taking the preempt_schedule_context() fix.

Oleg.

