Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab3JEIE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 04:04:26 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:58775 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3JEIEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 04:04:23 -0400
Date: Sat, 5 Oct 2013 10:04:16 +0200
From: Ingo Molnar <mingo.kernel.org@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] sched/wait: Collapse __wait_event macros -v5
Message-ID: <20131005080416.GA25193@gmail.com>
References: <20131002092217.784439754@infradead.org>
 <20131004204405.GU3081@twins.programming.kicks-ass.net>
 <20131004204438.GR26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004204438.GR26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Oct 04, 2013 at 10:44:05PM +0200, Peter Zijlstra wrote:
> > 
> > slightly related; do we want to do something like the following two
> > patches?
> 
> and

Yeah, both look good to me - but I'd move them into 
kernel/sched/completion.c and kernel/sched/wait.c if no-one objects.

> --- /dev/null
> +++ b/kernel/completion.c
> @@ -0,0 +1,287 @@
> +
> +#include <linux/sched.h>
> +#include <linux/completion.h>

Also, mind adding a small blurb at the top explaining what it's all about? 
Just one sentence or two.

Thanks,

	Ingo
