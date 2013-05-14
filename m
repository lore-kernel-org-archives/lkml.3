Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3ENLfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:35:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:54910 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3ENLfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:35:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,670,1363158000"; 
   d="scan'208";a="313314160"
Message-ID: <5192217D.5030706@intel.com>
Date: Tue, 14 May 2013 19:35:25 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: Re: [patch v6 8/8] sched: remove blocked_load_avg in tg
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com> <1368199049-2798-9-git-send-email-alex.shi@intel.com> <20130514083148.GD15942@dyad.programming.kicks-ass.net>
In-Reply-To: <20130514083148.GD15942@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 04:31 PM, Peter Zijlstra wrote:
> On Fri, May 10, 2013 at 11:17:29PM +0800, Alex Shi wrote:
>> > blocked_load_avg sometime is too heavy and far bigger than runnable load
>> > avg. that make balance make wrong decision. So better don't consider it.
> Would you happen to have an example around that illustrates this? 

Sorry, No.
> 
> Also, you've just changed the cgroup balancing -- did you run any tests on that?
> 

I tested all benchmarks on cover letter maintained, aim7, kbuild etc.
with autogroup enabled. There is no clear performance change.
But since the machine just run benchmark without anyother load, that
doesn't enough.

-- 
Thanks
    Alex
