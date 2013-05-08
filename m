Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3EHBeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 21:34:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:16977 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab3EHBeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 21:34:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,631,1363158000"; 
   d="scan'208";a="299164207"
Message-ID: <5189AB83.6060503@intel.com>
Date: Wed, 08 May 2013 09:33:55 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Paul Turner <pjt@google.com>, Michael Wang <wangyun@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v5 7/7] sched: consider runnable load average in effective_load
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-8-git-send-email-alex.shi@intel.com> <518724D1.9040006@linux.vnet.ibm.com> <51874229.8050202@intel.com> <5187609C.5050209@linux.vnet.ibm.com> <518763B0.30200@intel.com> <51876AFE.80906@linux.vnet.ibm.com> <CAPM31RK-N=Cnt3cBo1f6er6TewQJKY+fgdj9QHvKziHe+TxTxw@mail.gmail.com> <51877970.8010303@intel.com> <51877EF8.20504@linux.vnet.ibm.com> <51889498.8090409@intel.com>
In-Reply-To: <51889498.8090409@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 01:43 PM, Alex Shi wrote:
>> > This also brings forth another question,should we modify wake_affine()
>> > to pass the runnable load average of the waking up task to effective_load().
>> > 
>> > What do you think?
> I am not Paul. :)
> 
> The acceptable patch of pgbench attached. In fact, since effective_load is mixed 
> with direct load and tg's runnable load. the patch looks no much sense.
> So, I am going to agree to drop it if there is no performance benefit on my benchmarks.

This has a bad results on hackbench on 4 socket NHM/SNB machine, and has
bad result oltp on NHM EX. machine. So, drop it.

-- 
Thanks
    Alex
