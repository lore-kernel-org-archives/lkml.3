Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab3FQN76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:59:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:34211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab3FQN75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:59:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="256138912"
Message-ID: <51BF1654.7010909@intel.com>
Date: Mon, 17 Jun 2013 21:59:48 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
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
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [patch v8 6/9] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-7-git-send-email-alex.shi@intel.com> <CAPM31RKwNUh+nNcsEftD4pyP+gdwXhRK7wCRNWa8Y0sE0hf-DQ@mail.gmail.com> <CAPM31R+DBFt1wr10GCGEHDW_J_-79imdTCYEBF7YiKdFc1V7iQ@mail.gmail.com> <20130617133934.GX3204@twins.programming.kicks-ass.net>
In-Reply-To: <20130617133934.GX3204@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 09:39 PM, Peter Zijlstra wrote:
>>> > >
>>> > > This looks fine.
>>> > >
>>> > > Did you try including blocked_load_avg in only get_rq_runnable_load()
>>> > > [ and not weighted_cpuload() which is called by new-idle ]?
>> > 
>> > Looking at this more this feels less correct since you're taking
>> > averages of averages.
>> > 
>> > This was previously discussed at:
>> >   https://lkml.org/lkml/2013/5/6/109
>> > 
>> > And  you later replied suggesting this didn't seem to hurt; what's the
>> > current status there?
> Wasn't there a follow up series (currently as RFC or so) that proposes
> to removes the entire *_idx stuff?

Yes, it is in my plan. just currently I am kicked ass to do other
internal Intel tasks.

-- 
Thanks
    Alex
