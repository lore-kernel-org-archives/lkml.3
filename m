Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3ENLhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:37:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:54450 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab3ENLhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:37:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,670,1363158000"; 
   d="scan'208";a="313315169"
Message-ID: <519221F6.4090009@intel.com>
Date: Tue, 14 May 2013 19:37:26 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [patch v6 8/8] sched: remove blocked_load_avg in tg
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com> <1368199049-2798-9-git-send-email-alex.shi@intel.com> <CAPM31RJFrKm1uqHEEYEPsOsT9F2VVQDjt==yCae_OrwV_t9Nyg@mail.gmail.com>
In-Reply-To: <CAPM31RJFrKm1uqHEEYEPsOsT9F2VVQDjt==yCae_OrwV_t9Nyg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 05:05 PM, Paul Turner wrote:
>> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> > index 91e60ac..75c200c 100644
>> > --- a/kernel/sched/fair.c
>> > +++ b/kernel/sched/fair.c
>> > @@ -1339,7 +1339,7 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
>> >         struct task_group *tg = cfs_rq->tg;
>> >         s64 tg_contrib;
>> >
>> > -       tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
> Nack -- This is necessary for correct shares distribution.

I was going to set this patch as RFC. :)

BTW, did you do some test of this part?

-- 
Thanks
    Alex
