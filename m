Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab3GOWrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:47:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:39194 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752Ab3GOWrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:47:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,672,1367996400"; 
   d="scan'208";a="331828661"
Message-ID: <51E47BE2.3000801@linux.intel.com>
Date: Mon, 15 Jul 2013 15:46:58 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        alex.shi@intel.com, efault@gmx.de, pjt@google.com, len.brown@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <20130713064909.GW25631@dyad.programming.kicks-ass.net> <51E166C8.3000902@linux.intel.com> <20130715195914.GC23818@dyad.programming.kicks-ass.net> <51E45E8B.705@linux.intel.com> <20130715210650.GF23818@dyad.programming.kicks-ass.net>
In-Reply-To: <20130715210650.GF23818@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> so depending of the mix of compute and memory instructions, different tradeoffs
>> might be needed.
>>
>> (for an example of this, AMD exposes a CPU counter for this as of recently and added
>> patches to "ondemand" to use it)
>
> OK, but isn't that part of why the micro controller might not make you go
> faster even if you do program a higher P state?
>
> But yes, I understand this issue in the 'traditional' cpufreq sense. There's no
> point in ramping the speed if all you do is stall more.
>
> But I was under the impression the 'hardware' was doing this. If not then we
> need the whole go-faster and go-slower thing and places to call them and means
> to determine to call them etc.

so the answer is "somewhat" and "on some cpus"
not all generations of Intel cpus are the same in this regard ;-(

