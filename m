Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaEEPNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:13:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:7529 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753207AbaEEPNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:13:07 -0400
Date: Mon, 5 May 2014 11:13:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] tracing: Remove myself as a tracing maintainer
Message-ID: <20140505111301.65497e33@gandalf.local.home>
In-Reply-To: <1399131991-13216-1-git-send-email-fweisbec@gmail.com>
References: <1399131991-13216-1-git-send-email-fweisbec@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  3 May 2014 17:46:31 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> It has been a while since I last sent a tracing patch. I always keep an
> eye on tracing evolutions and contributions in general but given
> how busy I am with nohz, isolation and more generally core cleanups stuff,
> I seldom have time left to provide deep reviews of tracing patches nor
> simply for reviews to begin with.
> 
> I've been very lucky to start kernel development on a very young subsystem
> with tons of low hanging fruits back in 2008. Given that it deals with
> a lot of tricky stuffs all around (sched, timers, irq, preemption, NMIs,
> SMP, RCU, ....) I basically learned everything there.
> 
> Steve has been doing most of the incredible work these last years.
> Thanks a lot!
> 
> Of course consider me always available to help on tracing if any hard
> days happen.

I will reluctantly apply this to my 3.16 queue.

Thanks for all the tracing work! Although, I believe Peter Zijlstra has
some frozen sharks heading your way. ;-)

-- Steve

> 
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dc67b1..b69be85 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9041,7 +9041,6 @@ F:	drivers/char/tpm/
>  
>  TRACING
>  M:	Steven Rostedt <rostedt@goodmis.org>
> -M:	Frederic Weisbecker <fweisbec@gmail.com>
>  M:	Ingo Molnar <mingo@redhat.com>
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
>  S:	Maintained

