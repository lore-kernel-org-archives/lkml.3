Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3FZPXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:23:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:35628 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab3FZPXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:23:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,945,1363158000"; 
   d="scan'208";a="360880001"
Message-ID: <51CB0761.1020103@intel.com>
Date: Wed, 26 Jun 2013 23:23:13 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [Resend patch v8 0/13] use runnable load in schedule balance
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com> <20130626142759.GM28407@twins.programming.kicks-ass.net>
In-Reply-To: <20130626142759.GM28407@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> > 
>> > [Resend patch v8 01/13] Revert "sched: Introduce temporary
>> > [Resend patch v8 02/13] sched: move few runnable tg variables into
>> > [Resend patch v8 03/13] sched: set initial value of runnable avg for
>> > [Resend patch v8 04/13] sched: fix slept time double counting in
>> > [Resend patch v8 05/13] sched: update cpu load after task_tick.
>> > [Resend patch v8 06/13] sched: compute runnable load avg in cpu_load
>> > [Resend patch v8 07/13] sched: consider runnable load average in
>> > [Resend patch v8 08/13] sched/tg: remove blocked_load_avg in balance
>> > [Resend patch v8 09/13] sched: change cfs_rq load avg to unsigned
>> > [Resend patch v8 10/13] sched/tg: use 'unsigned long' for load
>> > [Resend patch v8 11/13] sched/cfs_rq: change atomic64_t removed_load
>> > [Resend patch v8 12/13] sched/tg: remove tg.load_weight
>> > [Resend patch v8 13/13] sched: get_rq_runnable_load() can be static
> I applied all except patch 8.

Uh, I will reconsider the patch 8th later. And millions thanks for
picking up others! :)

-- 
Thanks
    Alex
