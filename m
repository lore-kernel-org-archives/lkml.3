Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaA0WL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:11:26 -0500
Received: from toro.web-alm.net ([62.245.132.31]:51012 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbaA0WLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:11:25 -0500
Message-ID: <52E6D74B.80401@osadl.org>
Date: Mon, 27 Jan 2014 23:01:47 +0100
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: pavel@pavlinux.ru
CC: Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.8-rt11
References: <20140125134519.GA9845@linutronix.de>	<52E57D42.60206@pavlinux.ru>	<52E61C52.6070104@linutronix.de>	<52E62A05.7080802@pavlinux.ru> <20140127132411.6f420c8f@gandalf.local.home>
In-Reply-To: <20140127132411.6f420c8f@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 07:24 PM, Steven Rostedt wrote:
> On Mon, 27 Jan 2014 13:42:29 +0400
> Pavel Vasilyev <pavel@pavlinux.ru> wrote:
>
>> 27.01.2014 12:44, Sebastian Andrzej Siewior пишет:
>>> On 01/26/2014 10:25 PM, Pavel Vasilyev wrote:
>>>> 25.01.2014 17:45, Sebastian Andrzej Siewior пишет:
>>>>> Dear RT folks!
>>>>
>>>>
>>>> Gentlemen, let's have a month of stress testing! Divide tasks
>>>> testing subsystem: USB, NET, MM, ACPI, AUDIO, VIDEO By CPUs:
>>>> ARM/PPC/X86/X86_64...
>>>>
>>>> Purely on observations noted that in September 2013, the quality
>>>> and stability of the code has deteriorated dramatically.
>>>
>>> By September 2k13, do you mean a specific v3.10-RT release?
>>>
>>
>> Any after 3.2.x-rt
>>
>> Maybe I'm doing something wrong, but:
>>
>> 1) All kernels (3.2, 3.8, 3.12, 3.13,...) are working normally without patches;
>>
>> 2) 3.2 works fine in CONFIG_PREEMPT_RT_BASE or CONFIG_PREEMPT_RT_FULL modes;
>>
>> 3) 3.10 not works at all, even without -RT patches;
>
> Please report the problems here to LKML (linux-kernel@vger.kernel.org)
> to the appropriate maintainers. As well as the stable@vger.kernel.org
> mailing list.
>
>>
>> 4) 3.12 work only as CONFIG_PREEMPT_RT_BASE or CONFIG_PREEMPT_RT_FULL in
>> uniprocessor mode (maxcpus=0, nosmp).  Newer patches (Oct.-Dec.) did not work,
>> even in RT_BASE mode.
>
> Does 3.12 work without the -rt patches?
>
>>
>> Varia hardware: One Opteron 285, 2-cpus (4 cores). Six Intel Atoms devices
>> kernels compiled as x86_32.
>
> I have an intel atom dev board hanging around somewhere. I'll see if I
> can test this. Can you send me your config privately.
I can offer help as well. And I am most curious to learn what prevents 
your systems from booting. Please send me your config as well - I'll run 
(or at least try to run) it on a couple of spare farm systems.

	-Carsten.
