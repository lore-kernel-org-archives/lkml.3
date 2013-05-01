Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3EASph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 14:45:37 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:47427 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab3EASpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 14:45:16 -0400
Message-ID: <518162B7.6040804@gmail.com>
Date: Wed, 01 May 2013 14:45:11 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 0/7] posix-cpu-timers fixlet
References: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com> <20130501110121.GE28253@dyad.programming.kicks-ass.net>
In-Reply-To: <20130501110121.GE28253@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/1/13 7:01 AM), Peter Zijlstra wrote:
> On Mon, Apr 29, 2013 at 11:17:08PM -0400, kosaki.motohiro@gmail.com wrote:
>> Glibc's posix timer testcase found a lot of bugs in posix timer code. This series, hopefully,
>> fixes all of them. All patches are independent each other logically.
>>
>>
>> [PATCH 1/7] posix-cpu-timers: don't account cpu timer after stopped thread runtime accounting
>> [PATCH 2/7] posix-cpu-timers: fix acounting delta_exec twice
>> [PATCH 3/7] posix-cpu-timers: fix wrong timer initialization
>> [PATCH 4/7] posix-cpu-timers: timer functions must use timer time instead of clock time
>> [PATCH 5/7] posix-cpu-timers: check_thread_timers() uses task_sched_runtime()
>> [PATCH 6/7] sched: task_sched_runtime introduce micro optimization
>> [PATCH 7/7] posix-cpu-timers: cleanup cpu_{clock,timer}_sample{,_group}
> 
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Thanks for doing this Kosaki-San!

Thanks.
I've alread found several spell mistake in changelog. I'll resend patches soon.



