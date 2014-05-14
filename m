Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaENDQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:16:59 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:43183 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaENDQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:16:58 -0400
Message-ID: <5372E020.3020501@linux.vnet.ibm.com>
Date: Wed, 14 May 2014 11:16:48 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <537192D3.5030907@linux.vnet.ibm.com> <20140513094737.GU30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140513094737.GU30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051403-5140-0000-0000-0000051CF639
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 05:47 PM, Peter Zijlstra wrote:
> On Tue, May 13, 2014 at 11:34:43AM +0800, Michael wang wrote:
>> During our testing, we found that the cpu.shares doesn't work as
>> expected, the testing is:
>>
> 
> /me zaps all the kvm nonsense as that's non reproducable and only serves
> to annoy.
> 
> Pro-tip: never use kvm to report cpu-cgroup issues.

Make sense.

> 
[snip]
> for i in A B C ; do ps -deo pcpu,cmd | grep "${i}\.sh" | awk '{t += $1} END {print t}' ; done

Enjoyable :)

> 639.7
> 629.8
> 1127.4
> 
> That is of course not perfect, but it's close enough.

Yeah, for cpu intensive work load, the share do work very well, the
issue only appeared when workload start to become some kind of...sleepy.

I will use the tool you mentioned for the following investigation,
thanks for the suggestion.

> 
> Now you again.. :-)

And here I am ;-)

Regards,
Michael Wang

> 

