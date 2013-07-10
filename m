Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab3GJOsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:48:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29016 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3GJOsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:48:19 -0400
Message-ID: <51DD740C.5090000@oracle.com>
Date: Wed, 10 Jul 2013 10:47:40 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Tejun Heo <tj@kernel.org>, tglx@linutronix.de,
        LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org
Subject: Re: timer: lockup in run_timer_softirq()
References: <51DC902F.3070403@oracle.com> <20130710095459.GE17211@twins.programming.kicks-ass.net>
In-Reply-To: <20130710095459.GE17211@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 05:54 AM, Peter Zijlstra wrote:
> On Tue, Jul 09, 2013 at 06:35:27PM -0400, Sasha Levin wrote:
>> While going through the NMI dump, I noticed that it's very incomplete, and full of:
>>
>> [ 2536.500130] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler)
>> took too long to run: 697182.008 msecs
>
> Now I would actually expect arch_trigger_all_cpu_backtrace_handler() to
> issue this warning, that said, ~700 seconds is a bit long, I'm fairly
> sure it didn't actually take that long, you'd have noticed your vm being
> 'away' for 10+ minutes I'd think, no?
>
>
> There's something entirely fishy with that stuff, let me to stare at it.

Yeah, it didn't actually hang that long - that number is bogus.


Thanks,
Sasha

