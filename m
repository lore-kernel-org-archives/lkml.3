Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3I0BTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 21:19:22 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:34792 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3I0BTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 21:19:21 -0400
Message-ID: <5244DD11.30806@linux.vnet.ibm.com>
Date: Fri, 27 Sep 2013 09:19:13 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for wake_affine(.sync=true)
References: <20130925075341.GB3081@twins.programming.kicks-ass.net> <1380099377.8523.9.camel@marge.simpson.net> <20130926095812.GR3081@twins.programming.kicks-ass.net> <52444E3A.5070503@linux.vnet.ibm.com> <20130926154419.GF3657@laptop.programming.kicks-ass.net>
In-Reply-To: <20130926154419.GF3657@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092701-3864-0000-0000-00000A43661B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 11:44 PM, Peter Zijlstra wrote:
> On Thu, Sep 26, 2013 at 11:09:46PM +0800, Michael wang wrote:
>>> +	if (sync)
>>> +		p->se.last_sync_wakeup = sched_clock_cpu(cpu);
>>
>> Forgive me but I'm trying to understand it... why not 'current' but 'p'
>> here? we want the get off speed of waker or the working time of wakee?
> 
> Because I'm an idiot? ;-)

Well, I know you are full of good ideas ;-)

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

