Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab3FQJ6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:58:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:25858 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373Ab3FQJ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:58:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,880,1363158000"; 
   d="scan'208";a="354636190"
Message-ID: <51BEDD9E.600@intel.com>
Date: Mon, 17 Jun 2013 17:57:50 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
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
Subject: Re: [patch v8 3/9] sched: set initial value of runnable avg for new
 forked task
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-4-git-send-email-alex.shi@intel.com> <CAPM31RJFsh_gBXBHc4E6z=MtORR9D8sWs=86Yqy9onxK9x9fOg@mail.gmail.com> <51BB25BC.9070500@intel.com> <20130617092146.GM3204@twins.programming.kicks-ass.net>
In-Reply-To: <20130617092146.GM3204@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 05:21 PM, Peter Zijlstra wrote:
>> > 
>> > and make forking balancing imbalance since incorrect load_avg_contrib.
>> > 
>> > Further more, Morten Rasmussen notice some tasks were not launched at
>> > once after created. So Paul and Peter suggest giving a start value for
>> > new task runnable avg time same as sched_slice().
>> > 
>> > Signed-off-by: Alex Shi <alex.shi@intel.com>
>> > Signed-off-by: Paul Turner <pjt@google.com>
> Should you all go read: Documentation/SubmittingPatches , or am I
> somehow confused on the SoB rules?

has this should been right, if Paul had handed in the modified patch as
he suggested? :)

Sorry for stupid, I still don't know what's SoB rule?

-- 
Thanks
    Alex
