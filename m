Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750864Ab3HSPoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:44:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:26872 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3HSPoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:44:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,913,1367996400"; 
   d="scan'208";a="364959593"
Message-ID: <52123D57.40704@linux.intel.com>
Date: Mon, 19 Aug 2013 08:44:23 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com> <1376667753-29014-3-git-send-email-fweisbec@gmail.com> <20130816160201.GA31682@redhat.com> <20130816162056.GE24210@somewhere> <20130816162654.GA453@redhat.com> <20130816164626.GH24210@somewhere> <20130816164922.GA1573@redhat.com> <20130816171208.GJ24210@somewhere> <20130819105817.GD24092@twins.programming.kicks-ass.net>
In-Reply-To: <20130819105817.GD24092@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/2013 3:58 AM, Peter Zijlstra wrote:
> I'm also not entirely clear on the 'desired' semantics here. Do we count
> iowait time as idle or not?

cpufreq only looks at this because it does not want to count this as idle...
other than that it could not care less.

