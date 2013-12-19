Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab3LSXFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:05:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39264 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab3LSXFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:05:20 -0500
Message-ID: <52B37BAA.60200@infradead.org>
Date: Thu, 19 Dec 2013 15:05:14 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v4 3/4] futex: Document ordering guarantees
References: <1387485950-7320-1-git-send-email-davidlohr@hp.com>	 <1387485950-7320-4-git-send-email-davidlohr@hp.com>	 <52B35C64.3050504@infradead.org>	 <1387486823.5494.5.camel@buesod1.americas.hpqcorp.net> <1387487274.3510.18.camel@dvhart-mobl4.amr.corp.intel.com>
In-Reply-To: <1387487274.3510.18.camel@dvhart-mobl4.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/13 13:07, Darren Hart wrote:
> On Thu, 2013-12-19 at 13:00 -0800, Davidlohr Bueso wrote:
>> On Thu, 2013-12-19 at 12:51 -0800, Randy Dunlap wrote:
>>> On 12/19/13 12:45, Davidlohr Bueso wrote:
>>>> From: Thomas Gleixner <tglx@linutronix.de>
>>>>
>>>> That's essential, if you want to hack on futexes.
>>>>
>>>> Cc: Ingo Molnar <mingo@kernel.org>
>>>> Cc: Darren Hart <dvhart@linux.intel.com>
>>>> Acked-by: Peter Zijlstra <peterz@infradead.org>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>>> Cc: Mike Galbraith <efault@gmx.de>
>>>> Cc: Jeff Mahoney <jeffm@suse.com>
>>>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>>>> Cc: Scott Norton <scott.norton@hp.com>
>>>> Cc: Tom Vaden <tom.vaden@hp.com>
>>>> Cc: Aswin Chandramouleeswaran <aswin@hp.com>
>>>> Cc: Waiman Long <Waiman.Long@hp.com>
>>>> Cc: Jason Low <jason.low2@hp.com>
>>>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>>> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
>>>> ---
>>>>  kernel/futex.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 57 insertions(+)
>>>>
>>>> diff --git a/kernel/futex.c b/kernel/futex.c
>>>> index 577481d..af1fc31 100644
>>>> --- a/kernel/futex.c
>>>> +++ b/kernel/futex.c
>>>> @@ -69,6 +69,63 @@
>>>>  
>>>>  #include "locking/rtmutex_common.h"
>>>>  
>>>> +/*
>>>> + * Basic futex operation and ordering guarantees:
>>>> + *
>>>> + * The waiter reads the futex value in user space and calls
>>>> + * futex_wait(). It computes the hash bucket and acquires the hash
>>>
>>> does                It
>>> refer to "the waiter" or to futex_wait()?
>>> I read it as referring to the waiter, but ISTM that the comments are using It
>>> to refer to futex_wait()... ???
>>>
>>
>> Yes, it refers to futex_wait(), which IMO in a futex context is pretty
>> clear.
> 
> 
> Agreed.
> 
> 

I'll just have to get by with disagreeing with both of you then.
I say that the pronoun's antecedent is ambiguous (unclear).

-- 
~Randy
