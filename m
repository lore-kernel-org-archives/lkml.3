Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaLVQnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:43:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41182 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbaLVQnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:43:05 -0500
Message-ID: <5498498B.90703@oracle.com>
Date: Mon, 22 Dec 2014 09:40:43 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, corbet@lwn.net, mingo@redhat.com,
        hpa@zytor.com, riel@redhat.com, akpm@linux-foundation.org,
        rientjes@google.com, ak@linux.intel.com, mgorman@suse.de,
        raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com,
        avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com,
        athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com,
        daeseok.youn@gmail.com, keescook@chromium.org,
        yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com,
        axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH RESEND v4] sched/fair: Add advisory flag for borrowing
 a timeslice
References: <1418928259-6311-1-git-send-email-khalid.aziz@oracle.com> <20141218222846.GH30905@twins.programming.kicks-ass.net> <54935842.5020507@oracle.com> <alpine.DEB.2.11.1412182355020.17382@nanos> <54936562.5070502@oracle.com> <alpine.DEB.2.11.1412190045590.17382@nanos> <54949BF0.8030403@oracle.com> <alpine.DEB.2.11.1412200041220.17382@nanos>
In-Reply-To: <alpine.DEB.2.11.1412200041220.17382@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2014 04:57 PM, Thomas Gleixner wrote:
> On Fri, 19 Dec 2014, Khalid Aziz wrote:
>> The queuing problem caused by a task taking a contended lock just before its
>> current timeslice is up which userspace app wouldn't know about, is a real
>> problem nevertheless.
>
> We know that already.
>
>> My patch attempts to avoid the contention in the first
>> place. futex with adaptive spinning is a post-contention solution that tries
>> to minimize the cost of contention but does nothing to avoid the contention.
>
> I never said that adaptive spinning can solve that problem.
>
> If you would have carefuly read what I wrote, you might have noticed,
> that I said:
>
>       a proper futex like spin mechanism
>
> Can you spot the subtle difference between that phrase and 'futex with
> adaptive spinning'?
>
>> Solving this problem using futex can help only if the userspace lock uses
>> futex.
>
> A really fundamentally new and earth shattering insight.
>
> If you would spend your time to actually digest what maintainers are
> telling you, we might make progress on that matter.
>
> But you prefer to spend your time by repeating yourself and providing
> completely useless information.
>
> What you are missing completely here is that neither me nor other
> maintainers involved care about how you spend your time. But we very
> much care about the time WE waste with your behaviour.

I am sorry that you feel the need to continue to resort to personal 
attacks even after I made it clear in my last response that I was not 
going to pursue this patch. There is no possibility of a productive 
discussion of a solution at this point. I hope someone else can find a 
solution you find acceptable.

Thanks,
Khalid

