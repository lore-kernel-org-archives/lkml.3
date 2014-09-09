Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaIINhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:37:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:53724 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaIINht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:37:49 -0400
Date: Tue, 9 Sep 2014 10:37:37 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf top -g -U --sort=symbol --children == lalalalala?
Message-ID: <20140909133737.GK2773@kernel.org>
References: <1410263641.15383.8.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410263641.15383.8.camel@marge.simpson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 09, 2014 at 01:54:01PM +0200, Mike Galbraith escreveu:
> Seems the now default on --children thingy doesn't like -U much. 

Namhyung, can you please take a look at this?

- Arnaldo
 
> Samples: 5K of event 'cycles', Event count (approx.): 2268660922
>   Children      Self  Symbol
> +   46.42%     0.04%  [k] system_call_fastpath
> +   27.12%     0.80%  [k] apic_timer_interrupt
> +   26.26%     0.23%  [k] smp_apic_timer_interrupt
> +   20.43%     0.13%  [k] local_apic_timer_interrupt
> +   20.20%     0.74%  [k] hrtimer_interrupt
> +   18.01%     0.39%  [k] __run_hrtimer
> +   14.43%     0.35%  [k] tick_sched_timer
> +   13.60%     0.05%  [k] sys_poll
> +   13.09%     1.16%  [k] do_sys_poll
> +   12.16%     0.08%  [k] tick_sched_handle.isra.16
> +   11.70%     0.32%  [k] update_process_times
> +   11.41%     0.03%  [k] sys_read
> +   11.17%     0.11%  [k] vfs_read
> +   10.85%     0.09%  [k] seq_read
> +    8.27%     0.09%  [k] proc_single_show
> +    7.79%     1.19%  [k] page_fault
> +    7.01%     0.25%  [k] scheduler_tick
> +    6.26%     0.11%  [k] __do_page_fault
> +    5.97%     1.33%  [k] do_task_stat
> +    5.91%     0.23%  [k] handle_mm_fault
> +    5.40%     0.20%  [k] do_sys_open
> +    5.02%     0.09%  [k] ret_from_intr
> +    4.94%     0.05%  [k] do_IRQ
> +    4.70%     0.14%  [k] path_openat
> +    4.69%     0.62%  [k] tty_poll
> +    4.69%     0.16%  [k] irq_exit
> +    4.49%     0.63%  [k] __do_softirq
> +    4.27%     0.12%  [k] __alloc_pages_nodemask
> +    3.95%     0.03%  [k] handle_irq_event_percpu
> +    3.51%     0.71%  [k] __fget_light
> +    3.47%     0.04%  [k] sys_select
> +    3.39%     0.08%  [k] seq_printf
> +    3.37%     0.07%  [k] sys_open
> +    3.34%     0.11%  [k] seq_vprintf
> +    3.22%     0.02%  [k] core_sys_select
> +    3.15%     0.26%  [k] do_select
> +    3.15%     3.15%  [k] _raw_spin_lock
> 
> 
