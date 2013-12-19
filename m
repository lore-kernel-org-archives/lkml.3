Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3LSPkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:40:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27670 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3LSPkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:40:31 -0500
Message-ID: <52B3134D.2010203@oracle.com>
Date: Thu, 19 Dec 2013 10:39:57 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: lockdep: BUG: MAX_LOCKDEP_ENTRIES too low!
References: <52B289F4.7060205@oracle.com> <20131219103401.GE30183@twins.programming.kicks-ass.net> <52B2FC66.9010309@oracle.com> <20131219152002.GK16438@laptop.programming.kicks-ass.net>
In-Reply-To: <20131219152002.GK16438@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 10:20 AM, Peter Zijlstra wrote:
> On Thu, Dec 19, 2013 at 09:02:14AM -0500, Sasha Levin wrote:
>> On 12/19/2013 05:34 AM, Peter Zijlstra wrote:
>>> On Thu, Dec 19, 2013 at 12:53:56AM -0500, Sasha Levin wrote:
>>>> Hi all,
>>>>
>>>> I think that my bloated kernel managed to create way too many entries in the
>>>> dependency table. If that sounds right, I can send a patch to increase those.
>>>>
>>>> Attached /proc/lock_stat as requested as well.
>>>
>>> /proc/lockdep_stats not lock_stat :-)
>>>
>>> Do you still happen to have that?
>>
>> Is the BUG message intentional ("Please attach the output of /proc/lock_stat to the bug report")?
>
> It does? This happened when I wasn't looking..
>
> Commit 199e371f59d31 did that; and the Changelog fails to mention why or
> what. Ingo, Dave?
>
> So the thing I referred to was from Documentation/lockdep-design.txt:

[snip]

That discusses lockdep classes, which is actually fine in my case. I ran out of
MAX_LOCKDEP_ENTRIES, which isn't mentioned anywhere in Documentation/ .


Thanks,
Sasha
