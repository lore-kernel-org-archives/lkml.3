Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab3CSPBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:01:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42334 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3CSPBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:01:12 -0400
Message-ID: <1363705261.22553.57.camel@laptop>
Subject: Re: [PATCH 6/8] sched: rename load_balance_tmpmask to
 load_balance_cpu_active
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 16:01:01 +0100
In-Reply-To: <1360820921-2513-7-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1360820921-2513-7-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> This name doesn't represent specific meaning.
> So rename it to imply it's purpose.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 26058d0..e6f8783 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6814,7 +6814,7 @@ struct task_group root_task_group;
>  LIST_HEAD(task_groups);
>  #endif
>  
> -DECLARE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
> +DECLARE_PER_CPU(cpumask_var_t, load_balance_cpu_active);

That's not much better; how about we call it: load_balance_mask.

