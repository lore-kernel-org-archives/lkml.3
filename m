Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3FQPcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:32:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:42096 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab3FQPcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:32:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="354787507"
Message-ID: <51BF2BFD.1090704@intel.com>
Date: Mon, 17 Jun 2013 23:32:13 +0800
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
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [patch v8 2/9] sched: move few runnable tg variables into CONFIG_SMP
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-3-git-send-email-alex.shi@intel.com> <CAPM31RLzTyi5vsW-3Fx-CA4i6oneoh588VRBBhvzkKSeDJjP0g@mail.gmail.com>
In-Reply-To: <CAPM31RLzTyi5vsW-3Fx-CA4i6oneoh588VRBBhvzkKSeDJjP0g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 08:26 PM, Paul Turner wrote:
> On Fri, Jun 7, 2013 at 12:20 AM, Alex Shi <alex.shi@intel.com> wrote:
>> The following 2 variables only used under CONFIG_SMP, so better to move
>> their definiation into CONFIG_SMP too.
>>
>>         atomic64_t load_avg;
>>         atomic_t runnable_avg;
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
> 
> Looks fine; the manipulations to the structs could perhaps be
> collapsed to one patch.
> 

thanks for review!

-- 
Thanks
    Alex
