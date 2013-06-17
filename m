Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab3FQP1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:27:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:19487 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab3FQP1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:27:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="354947190"
Message-ID: <51BF2AC3.6080009@intel.com>
Date: Mon, 17 Jun 2013 23:26:59 +0800
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
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>
Subject: Re: [RFC patch 2/4] sched/tg: use 'unsigned long' for load variable
 in task group
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com> <1370590169-24804-3-git-send-email-alex.shi@intel.com> <CAPM31R+Rmmn471ZE97q3DhAgZiu3s2fEoqf7unO6sB6=H8w37A@mail.gmail.com>
In-Reply-To: <CAPM31R+Rmmn471ZE97q3DhAgZiu3s2fEoqf7unO6sB6=H8w37A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 08:25 PM, Paul Turner wrote:
> On Fri, Jun 7, 2013 at 12:29 AM, Alex Shi <alex.shi@intel.com> wrote:
>> > Since tg->load_avg is smaller than tg->load_weight, we don't need a
>> > atomic64_t variable for load_avg in 32 bit machine.
>> > The same reason for cfs_rq->tg_load_contrib.
> This description is incorrect, another patch removes tg->load_weight
> for being unused.

You can say this, but tg->load_weight was designed for the same meaning
as load_avg before. :)
> 
> Rest seems fine.

thanks for review.

-- 
Thanks
    Alex
