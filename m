Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935518Ab3FTBrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 21:47:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:36747 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935237Ab3FTBrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 21:47:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,901,1363158000"; 
   d="scan'208";a="257506980"
Message-ID: <51C25EE9.5050501@intel.com>
Date: Thu, 20 Jun 2013 09:46:17 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lei Wen <adrian.wenl@gmail.com>
CC: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [patch v8 4/9] sched: fix slept time double counting in enqueue
 entity
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-5-git-send-email-alex.shi@intel.com> <CAPM31RLB6nN+qN8UNq0RXiRYKaFZ6GYVP-=kZMR8-rkP9831Bw@mail.gmail.com> <51BF2E37.5040400@intel.com> <CALZhoSSweOzTgjykRMxv_kha9TH-8EAKvuhinf8ADFyFDzDTuQ@mail.gmail.com>
In-Reply-To: <CALZhoSSweOzTgjykRMxv_kha9TH-8EAKvuhinf8ADFyFDzDTuQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 09:43 AM, Lei Wen wrote:
>> > From 24d9b43e7a269e6ffee5b874d39812b83812a809 Mon Sep 17 00:00:00 2001
>> > From: Alex Shi <alex.shi@intel.com>
>> > Date: Thu, 9 May 2013 10:54:13 +0800
>> > Subject: [PATCH] sched: fix slept time double counting in enqueue entity
>> >
>> > The wakeuped migrated task will __synchronize_entity_decay(se); in
>> > migrate_task_fair, then it needs to set
> Should be migrate_task_rq_fair, right? :)
> 

yes, thanks!

-- 
Thanks
    Alex
