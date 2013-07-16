Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869Ab3GPUVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:21:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:18898 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933518Ab3GPUVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:21:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,679,1367996400"; 
   d="scan'208";a="269151977"
Message-ID: <51E5AB2E.90700@linux.intel.com>
Date: Tue, 16 Jul 2013 13:21:02 -0700
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
References: <51E166C8.3000902@linux.intel.com> <20130715195914.GC23818@dyad.programming.kicks-ass.net> <51E45E8B.705@linux.intel.com> <20130715210650.GF23818@dyad.programming.kicks-ass.net> <20130715211230.GG23818@dyad.programming.kicks-ass.net> <51E47D30.5030203@linux.intel.com> <20130716173848.GA22795@dyad.programming.kicks-ass.net> <51E5947F.4090109@linux.intel.com> <20130716192145.GV17211@twins.programming.kicks-ass.net> <51E5A5AE.7010903@linux.intel.com> <20130716201702.GW17211@twins.programming.kicks-ass.net>
In-Reply-To: <20130716201702.GW17211@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/2013 1:17 PM, Peter Zijlstra wrote:
> On Tue, Jul 16, 2013 at 12:57:34PM -0700, Arjan van de Ven wrote:
>> then the question of how much remaining capacity; this is a hard one, and not just
>> for Intel. Almost all mobile devices today are thermally constrained, ARM and Intel
>> alike (at least the higher performance ones)... the curse of wanting very thin and light
>> phones that are made of thermally isolating plastic (so that radio waves can go through)
>> and have a nice and bright screen...
>
> Right, so we might need to track a !idle avg over the thermal domain to
> guestimate the head-room and inter-cpu relations.

mostly the thermal domain will be the cpu half of the SOC if not the whole SOC, in the mobile space.
For big servers, sure.
But why count idle average when most chips have thermal sensors built in?
(needed for the same thermal limiting reasons)




