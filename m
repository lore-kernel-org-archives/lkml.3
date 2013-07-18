Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145Ab3GRQQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:16:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757635Ab3GRQQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:16:50 -0400
Date: Thu, 18 Jul 2013 18:11:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing: more list_empty(perf_events) checks
Message-ID: <20130718161122.GA9953@redhat.com>
References: <20130617170142.GA19780@redhat.com> <1374116446.6458.203.camel@gandalf.local.home> <20130718094237.GI27075@twins.programming.kicks-ass.net> <1374158349.6458.237.camel@gandalf.local.home> <20130718154403.GA8416@redhat.com> <1374162806.6458.238.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374162806.6458.238.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18, Steven Rostedt wrote:
>
> On Thu, 2013-07-18 at 17:44 +0200, Oleg Nesterov wrote:
>
> > Steven, I am starting to think that it would be better to resend this
> > series (3-6 in mbox I sent) so that Peter and Frederic can take another
> > look. And I'll try to update the changelogs. Will do a bit later today.
>
> Or do you mean 4-6?

Yeeess, sorry 4-6.

Oleg.

