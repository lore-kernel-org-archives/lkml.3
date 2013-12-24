Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3LXPoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 10:44:32 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:59002 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab3LXPob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 10:44:31 -0500
MIME-Version: 1.0
In-Reply-To: <20131224084801.57439ca2@gandalf.local.home>
References: <CAKohpom5JmFamPpOsyPRqXNAqXu6VF_t0zXXhT90MCMutp5FgQ@mail.gmail.com>
	<20131224084801.57439ca2@gandalf.local.home>
Date: Tue, 24 Dec 2013 21:14:31 +0530
Message-ID: <CAKohpokVwMcbBLHdcZiHsce2FPHp5NRQwoUCL2OB6j6Vgm8JFw@mail.gmail.com>
Subject: Re: [Query]: trace-cmd crashing with '-e syscalls' on 3.13-rc1
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 December 2013 19:18, Steven Rostedt <rostedt@goodmis.org> wrote:
> Can you also produce this with just
> "echo 1 > /sys/kernel/debug/tracing/events/syscalls/enable"?

Will do that on 26th..

>> [  299.998874] Unable to handle kernel NULL pointer dereference at
>> virtual address 0000001b
>> [  300.005554] pgd = ed9fc000
>> [  300.008201] [0000001b] *pgd=6eb1e831, *pte=00000000, *ppte=00000000
>> [  300.014428] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
>> [  300.019812] Modules linked in:
>> [  300.022847] CPU: 0 PID: 2172 Comm: is-cpu-isolated Not tainted
>> 3.13.0-rc1-00090-gd6eaf98-dirty #141
>
> Are you running some isolated CPU test? Do you have NO_HZ_FULL enabled
> too?

Yeah, I am using NO_HZ_FULL with CPUSets. Only one task (stress) is running
on CPU1 and CPU0 is running everything else..

> I Cc'd Frederic too.
>
> Note, I'm on PTO for two weeks (coming back Jan 6th), so I wont be
> debugging this any time soon. My wife has me debugging house issues
> (putting in a new floor for laundry room, painting, re-arranging
> furniture, etc). (I have to sneak to the computer in order to goof off
> and respond to this email ;-)

:)
