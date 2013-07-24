Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3GXPQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:16:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:30435 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab3GXPQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:16:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,736,1367996400"; 
   d="scan'208";a="336111894"
Message-ID: <51EFEFD4.4020808@linux.intel.com>
Date: Wed, 24 Jul 2013 08:16:36 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <20130713064909.GW25631@dyad.programming.kicks-ass.net> <20130713102350.GA8067@MacBook-Pro.local> <20130715203922.GD23818@dyad.programming.kicks-ass.net> <20130716124248.GB10036@arm.com> <51E5655C.7050304@linux.intel.com> <20130717141426.GG27948@arm.com> <20130724135011.GE12572@e103034-lin>
In-Reply-To: <20130724135011.GE12572@e103034-lin>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Given that the power topology is taken into account, a sort
> left/right-like mechanism would only help performance insensitive tasks
> on big.LITTLE. Performance sensitive tasks that each can use more than
> a little cpu should move in the opposite direction. Well, directly to a
> big cpu, even if some little cpus are idle.
>
> It can be discussed whether smaller performance sensitive tasks that
> would fit on a little cpu should be put on a little or big cpu. That
> would depend on the nature of the task and if other tasks depend on it.

yeah that makes it fun

just a question for my education; is there overlap between big and little?
meaning, is the "highest speed of little" as fast, or faster than "lowest speed of big"
or are those strictly disjoint?

(if there's overlap that gives some room for the scheduler to experiment)

