Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab3CTHeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 03:34:37 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62346 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3CTHeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 03:34:36 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-e9-5149668a9fd5
Date: Wed, 20 Mar 2013 16:35:00 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] sched: rename load_balance_tmpmask to
 load_balance_cpu_active
Message-ID: <20130320073500.GD11672@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1360820921-2513-7-git-send-email-iamjoonsoo.kim@lge.com>
 <1363705261.22553.57.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363705261.22553.57.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 04:01:01PM +0100, Peter Zijlstra wrote:
> On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> > This name doesn't represent specific meaning.
> > So rename it to imply it's purpose.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 26058d0..e6f8783 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -6814,7 +6814,7 @@ struct task_group root_task_group;
> >  LIST_HEAD(task_groups);
> >  #endif
> >  
> > -DECLARE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
> > +DECLARE_PER_CPU(cpumask_var_t, load_balance_cpu_active);
> 
> That's not much better; how about we call it: load_balance_mask.

Okay, in next spin, I will call it as load_balance_mask.

Thanks.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
