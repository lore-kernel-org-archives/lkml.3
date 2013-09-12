Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3ILRl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:41:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48309 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab3ILRl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:41:27 -0400
Message-ID: <5231FCA1.4090803@oracle.com>
Date: Thu, 12 Sep 2013 13:40:49 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v5 0/9] liblockdep: userspace lockdep
References: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com> <20130626122408.GJ28407@twins.programming.kicks-ass.net> <20130626155325.GB7399@gmail.com> <51CB4328.7010006@oracle.com> <20130627090722.GC4398@gmail.com> <51CC4461.50207@oracle.com> <51DA127E.3040706@oracle.com> <20130708083914.GB3948@gmail.com>
In-Reply-To: <20130708083914.GB3948@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 04:39 AM, Ingo Molnar wrote:
>
> * Sasha Levin <sasha.levin@oracle.com> wrote:
>
>>>> The other issue is that with lock classes disabled you have to hit an
>>>> actual deadlock to trigger any output.
>>>>
>>>> I.e. much of the power of lockdep is diminished :-/ When actual
>>>> deadlocks are triggered then it's not particularly complex to debug
>>>> user-space apps: gdb the hung task(s) and look at the backtraces.
>>>
>>> Lock classes are disabled only if you're using the LD_PRELOAD method
>>> of testing. If you actually re-compile your code with the library (by
>>> just including the header and setting a #define to enable it) you will
>>> have lock classes.
>>
>> Hi Ingo,
>>
>> Just wondering if you're planning on pushing it over to Linus from your
>> tree, or should I go ahead and do it on my own?
>
> PeterZ is in favor as well so I'll apply them after the merge window, for
> v3.12.

Hi Ingo,

Do you intend to send liblockdep in this merge window as planned?


Thanks,
Sasha

