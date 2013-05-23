Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3EWIT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:19:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:22753 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024Ab3EWITz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:19:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,726,1363158000"; 
   d="scan'208";a="306692992"
Message-ID: <519DD110.3070002@intel.com>
Date: Thu, 23 May 2013 16:19:28 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Changlong Xie <xiechanglong87@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        tglx@linutronix.de, akpm@linux-foundation.org, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mgorman@suse.de, riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Changlong Xie <changlongx.xie@intel.com>
Subject: Re: [patch v6 8/8] sched: remove blocked_load_avg in tg
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com> <1368199049-2798-9-git-send-email-alex.shi@intel.com> <20130514083148.GD15942@dyad.programming.kicks-ass.net> <5192217D.5030706@intel.com> <20130516092308.GH19669@dyad.programming.kicks-ass.net> <CAJWCg7PKpGgHKqhm6Xq8DfVEWGoDsgS8s99r3JS7Wce7WS=B_Q@mail.gmail.com>
In-Reply-To: <CAJWCg7PKpGgHKqhm6Xq8DfVEWGoDsgS8s99r3JS7Wce7WS=B_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 03:32 PM, Changlong Xie wrote:
> 2013/5/16 Peter Zijlstra <peterz@infradead.org>:
>> On Tue, May 14, 2013 at 07:35:25PM +0800, Alex Shi wrote:
>>
>>> I tested all benchmarks on cover letter maintained, aim7, kbuild etc.
>>> with autogroup enabled. There is no clear performance change.
>>> But since the machine just run benchmark without anyother load, that
>>> doesn't enough.
>>
>> Back when we started with smp-fair cgroup muck someone wrote a test for it. I
>> _think_ it ended up in the LTP test-suite.
>>
> 
> Hi Peter
> 

> my test results:
> 3.10-rc1          patch1-7         patch1-8
> duration=764   duration=754   duration=750
> duration=764   duration=754   duration=751
> duration=763   duration=755   duration=751
> 
> duration means the seconds of testing cost.
> 
> Tested-by: Changlong Xie <changlongx.xie@intel.com>

Seems the 8th patch is helpful on cgroup. Thanks Changlong!

-- 
Thanks
    Alex
