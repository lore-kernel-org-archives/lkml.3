Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324AbaGUSL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:11:26 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41316 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaGUSLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:11:24 -0400
Date: Mon, 21 Jul 2014 11:11:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 06/10] nohz: Define meaningful symbol for nohz full
 timekeeper
Message-ID: <20140721181118.GG8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
 <1405730661-9355-7-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405730661-9355-7-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072118-1344-0000-0000-000002F8748C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 02:44:17AM +0200, Frederic Weisbecker wrote:
> The nohz full timekeeper is always CPU 0. Lets add it to the list of
> special tick_do_timer_cpu symbols for more self explanatory code.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/time/tick-internal.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
> index 7ab92b1..6b592a8 100644
> --- a/kernel/time/tick-internal.h
> +++ b/kernel/time/tick-internal.h
> @@ -10,6 +10,7 @@ extern seqlock_t jiffies_lock;
> 
>  #ifdef CONFIG_GENERIC_CLOCKEVENTS_BUILD
> 
> +#define TICK_DO_TIMER_DEFAULT	0
>  #define TICK_DO_TIMER_NONE	-1
>  #define TICK_DO_TIMER_BOOT	-2
> 
> -- 
> 1.8.3.1
> 

