Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3CNHNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 03:13:15 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:65083 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3CNHNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 03:13:14 -0400
Date: Thu, 14 Mar 2013 08:13:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH][GIT PULL][3.9] tracing: Fix free of probe entry by
 calling call_rcu_sched()
Message-ID: <20130314071309.GA7869@gmail.com>
References: <1363218811.25967.12.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363218811.25967.12.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> While testing my new code I stumbled upon this bug. This is a real
> bug and has been in the kernel forever. Luckily, it's in a feature
> that is seldom used. But it can cause a crash if the race is hit.
> 
> I based this off of my last pull request of tip/perf/urgent.
> 
> Thanks,
> 
> -- Steve
> 
> 
> Please pull the latest tip/perf/urgent-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent-2
> 
> Head SHA1: 740466bc89ad8bd5afcc8de220f715f62b21e365
> 
> 
> Steven Rostedt (Red Hat) (1):
>       tracing: Fix free of probe entry by calling call_rcu_sched()
> 
> ----
>  kernel/trace/ftrace.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Pulled, thanks Steve!

	Ingo
