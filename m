Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab3ENOfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:35:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:50686 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab3ENOfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:35:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,671,1363158000"; 
   d="scan'208";a="337410397"
Message-ID: <51924BB8.3040907@intel.com>
Date: Tue, 14 May 2013 22:35:36 +0800
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
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [patch 0/8]: use runnable load avg in balance
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com> <CAPM31RLwbrfGT8UUajmuUYVu6VmtQwr6fjAc8MJqvAWE2N_F8Q@mail.gmail.com>
In-Reply-To: <CAPM31RLwbrfGT8UUajmuUYVu6VmtQwr6fjAc8MJqvAWE2N_F8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 05:34 PM, Paul Turner wrote:
>> >
>> > We also tried to include blocked load avg in balance. but find many benchmark
>> > performance dropping. Guess the too bigger cpu load drive task to be waken
>> > on remote CPU, and cause wrong decision in periodic balance.
> Fundamentally, I think we should be exploring this space.

I thought something of this. but can not figure out a direction or stand
by some theories.
> 
> While it's perhaps not surprising that it's not a drop-in, since the
> current code was tuned always considering the instaneous balance, it
> seems the likely path to increased balance stability.
> 
> Although, if the code is yielding substantive benefits in its current
> form we should consider merging it in the interim.

Sorry, I can not follow you here.
> 



-- 
Thanks
    Alex
