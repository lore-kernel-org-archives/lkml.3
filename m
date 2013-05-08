Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3EHBjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 21:39:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:14042 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab3EHBjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 21:39:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,631,1363158000"; 
   d="scan'208";a="333487148"
Message-ID: <5189ACD2.1080105@intel.com>
Date: Wed, 08 May 2013 09:39:30 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [PATCH v5 6/7] sched: consider runnable load average in move_tasks
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-7-git-send-email-alex.shi@intel.com> <CAPM31RK71tBPdnXzLmr1o6nmFhbhU9+b_DqX9zNSbDc4EhC8FQ@mail.gmail.com> <20130506150428.GD15446@dyad.programming.kicks-ass.net> <CAPM31RKqMGAvFh1JmUjCjBo4EJWqA39i8=YPiUw8GUkG9dj7Fw@mail.gmail.com> <51888E87.2090506@intel.com>
In-Reply-To: <51888E87.2090506@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 01:17 PM, Alex Shi wrote:
>> > Sorry, what I meant to say here is:
>> > If we're going to be using a runnable average based load here the
>> > fraction we take (currently instantaneous) in tg_load_down should be
>> > consistent.
> yes. I think so.
> 
> So, here is the patch, could you like take a look?

The new patchset till to this patch has a bad results on kbuild. So,
will do testing and drop some of them or all.

-- 
Thanks
    Alex
