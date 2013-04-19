Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3DSTTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 15:19:34 -0400
Received: from shelob.surriel.com ([74.92.59.67]:49822 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3DSTTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 15:19:33 -0400
Message-ID: <517198A7.8020904@surriel.com>
Date: Fri, 19 Apr 2013 15:19:03 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Emmanuel Benisty <benisty.e@gmail.com>
Subject: Re: linux-next: Tree for Apr 18 [ call-trace: drm | x86 | smp | rcu
 related? ]
References: <CA+icZUVWC+Rgd9wh4Z4CPZkEa9Pm2=2udnY5=UD1nnH0Wot1pQ@mail.gmail.com> <CAKMK7uFEaiT_1siQBcp_-S0RwLvy3XSjqLn1ksq70VhNTZSfLw@mail.gmail.com> <CA+icZUWQEiGecR8jgw4P-2YCKyqSDMMP0Ufwn8aBU_-AOf0a-Q@mail.gmail.com> <CA+icZUWcwvFFVesJDoFNT3DbgRMXvDp7QLn+S5Ze_5d8gJRx1g@mail.gmail.com> <CA+icZUXjTGSG+tejOAFgXr8EpKd7dL=-W41ha_-0N=roAxN3eg@mail.gmail.com> <CA+icZUVE-ikxEp65bUHMp0WEPX_MDbA06ykzeSxygJv=9f45ig@mail.gmail.com> <CA+icZUUp84vzF_0n77wsJ6dBOS26vSRCXaFUDbCQi-wG0b-Osg@mail.gmail.com>
In-Reply-To: <CA+icZUUp84vzF_0n77wsJ6dBOS26vSRCXaFUDbCQi-wG0b-Osg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 02:53 PM, Sedat Dilek wrote:
> On Fri, Apr 19, 2013 at 6:43 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
>> I tried to switch from SLUB to SLAB...
>>
>> ...and also from VIRT_CPU_ACCOUNTING_GEN to TICK_CPU_ACCOUNTING.
>>
>> 2x NOPE.
>>
>> In one kernel-build I saw in my console...
>>
>>       semop(1): encountered an error: Identifier removed
>>
>> ...if this says sth. to you.
>>
> [ CC folks from below thread ]
>
> I have found a thread called "Re: ipc,sem: sysv semaphore scalability"
> on LKML with a screenshot that shows the same call-trace.
> I followed it a bit.
> There is a patch in [3]... unconfirmed.
>
> Comments on the rcu read-lock and "sem_lock()" vs "sem_unlock()" from Linus.
>
> What's the status of this discussion?
>
> - Sedat -
>
> [1] https://lkml.org/lkml/2013/3/30/6
> [2] http://i.imgur.com/uk6gmq1.jpg
> [3] https://lkml.org/lkml/2013/3/31/12
> [4] https://lkml.org/lkml/2013/3/31/77
>
I am at a conference right now, but when I get
back I will check linux-next vs. all the fixes from
the semaphore scalability email thread.

I will gather up the not-yet-in-linux-next fixes,
and will send them to Andrew for inclusion.

No guarantee that those fixes are related to
your problem, of course :)
