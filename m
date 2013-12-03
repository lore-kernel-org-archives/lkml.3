Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3LCPCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:02:18 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52747 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753464Ab3LCPCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:02:06 -0500
Date: Tue, 3 Dec 2013 15:00:38 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "pjt@google.com" <pjt@google.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "jason.low2@hp.com" <jason.low2@hp.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] nohz_full: fix code sytle issue of
 tick_nohz_full_stop_tick
Message-ID: <20131203150038.GE10134@e103034-lin>
References: <1386074112-30754-1-git-send-email-alex.shi@linaro.org>
 <1386074112-30754-2-git-send-email-alex.shi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386074112-30754-2-git-send-email-alex.shi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In subject: s/sytle/style/

On Tue, Dec 03, 2013 at 12:35:10PM +0000, Alex Shi wrote:
> Code usually starts with 'tab' instead of 7 'space'es in kernel
> 
> Signed-off-by: Alex Shi <alex.shi@linaro.org>
> ---
>  kernel/time/tick-sched.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 3612fc7..b55d1c0 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -681,18 +681,18 @@ out:
>  static void tick_nohz_full_stop_tick(struct tick_sched *ts)
>  {
>  #ifdef CONFIG_NO_HZ_FULL
> -       int cpu = smp_processor_id();
> +	int cpu = smp_processor_id();
>  
> -       if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
> -               return;
> +	if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
> +		return;
>  
> -       if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
> -	       return;
> +	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
> +		return;
>  
> -       if (!can_stop_full_tick())
> -               return;
> +	if (!can_stop_full_tick())
> +		return;
>  
> -       tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
> +	tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
>  #endif
>  }
>  
> -- 
> 1.8.1.2
> 
> 
