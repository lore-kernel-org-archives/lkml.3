Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142Ab3DNFKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 01:10:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:24348 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab3DNFKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 01:10:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,470,1363158000"; 
   d="scan'208";a="318812501"
Message-ID: <516A3A3A.2030205@intel.com>
Date: Sun, 14 Apr 2013 13:10:18 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Len Brown <lenb@kernel.org>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com> <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com> <20130412162348.GE2368@pd.tnic> <516A0652.8040505@intel.com>
In-Reply-To: <516A0652.8040505@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2013 09:28 AM, Alex Shi wrote:
>>>> >> > These numbers suggest that this patch series simultaneously
>>>> >> > has a negative impact on performance and energy required
>>>> >> > to retire the workload.  Why do it?
> Even some scenario the total energy cost more, at least the avg watts
> dropped in that scenarios. Len said he has low p-state which can work
> there. but that's is different. I had sent some data in another email
> list to show the difference:
> 
> The following is 2 times kbuild testing result for 3 kinds condiation on
> SNB EP box, the middle column is the lowest p-state testing result, we
> can see, it has the lowest power consumption, also has the lowest
> performance/watts value.
> At least for kbuild benchmark, powersaving policy has the best
> compromise on powersaving and power efficient. Further more, due to cpu
> boost feature, it has better performance in some scenarios.

BTW, another benefit on powersaving is that powersaving policy is very
flexible on system load. when task number in sched domain is beyond LCPU
number, it will take performance oriented balance. That conduct the
similar performance when system is busy.

-- 
Thanks
    Alex
