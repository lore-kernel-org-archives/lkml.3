Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab3DTMqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 08:46:25 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63311 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab3DTMqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 08:46:23 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWJRRLtrKU+pP9svYvX=V8mAbFBx+ufENWLq3rnGO63hw@mail.gmail.com>
References: <CA+icZUVWC+Rgd9wh4Z4CPZkEa9Pm2=2udnY5=UD1nnH0Wot1pQ@mail.gmail.com>
	<CAKMK7uFEaiT_1siQBcp_-S0RwLvy3XSjqLn1ksq70VhNTZSfLw@mail.gmail.com>
	<CA+icZUWQEiGecR8jgw4P-2YCKyqSDMMP0Ufwn8aBU_-AOf0a-Q@mail.gmail.com>
	<CA+icZUWcwvFFVesJDoFNT3DbgRMXvDp7QLn+S5Ze_5d8gJRx1g@mail.gmail.com>
	<CA+icZUXjTGSG+tejOAFgXr8EpKd7dL=-W41ha_-0N=roAxN3eg@mail.gmail.com>
	<CA+icZUVE-ikxEp65bUHMp0WEPX_MDbA06ykzeSxygJv=9f45ig@mail.gmail.com>
	<CA+icZUUp84vzF_0n77wsJ6dBOS26vSRCXaFUDbCQi-wG0b-Osg@mail.gmail.com>
	<517198A7.8020904@surriel.com>
	<1366402328.5317.9.camel@buesod1.americas.hpqcorp.net>
	<CA+icZUVjx7pDJWo3tGxX3ANXtiTP0_Q1YyOowANhn1wzcSgWaA@mail.gmail.com>
	<CA+55aFzU5C9UQGNFx+wQ_Rp0gZAAwLj77qO7fH7LEduD7bk1Kg@mail.gmail.com>
	<CA+icZUV+Y90uuEoBXQWGsZTYT5h4HXqWvAW_fU4vxL-N2TmXhQ@mail.gmail.com>
	<CA+icZUVuU9Cbx+d=uyDk=csH01re56NsvBo-wHjjLg1gOt5uzw@mail.gmail.com>
	<CA+55aFxsMRKn8kkMr7Q1vGryR=E-E2hPJfdf2XUh6WLMZ3wLNw@mail.gmail.com>
	<CA+icZUWhB=BTaQp0XuC8+PocQf3FzxBoytbzYFh=kup0LsapRg@mail.gmail.com>
	<CA+55aFx0ogTF9F6wsk2ECkB41Ufd1SzcTYWE0aW3RQ2ijdsJ3A@mail.gmail.com>
	<CA+icZUUb6sWo0MvgdOXYGBBfJqZ5QeUtQDDPVxGb70sZ6JyG4A@mail.gmail.com>
	<CA+icZUWJRRLtrKU+pP9svYvX=V8mAbFBx+ufENWLq3rnGO63hw@mail.gmail.com>
Date: Sat, 20 Apr 2013 14:46:21 +0200
Message-ID: <CA+icZUUG8bzGnnAhGfXA-gRRTin7cDj3-JK438PKepa=mgSJzw@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 18 [ call-trace: drm | x86 | smp | rcu
 related? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Rik van Riel <riel@surriel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>,
        Emmanuel Benisty <benisty.e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 20, 2013 at 2:19 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Sat, Apr 20, 2013 at 2:06 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Sat, Apr 20, 2013 at 1:02 AM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> On Fri, Apr 19, 2013 at 3:55 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>>
>>>> Davidlohr pointed to this patch (tested the triplet):
>>>>
>>>> ipc, sem: do not call sem_lock when bogus sma:
>>>> https://lkml.org/lkml/2013/3/31/12
>>>>
>>>> Is that what you mean?
>>>
>>> Yup.
>>>
>>
>> Davidlohr Bueso (1):
>>       ipc, sem: do not call sem_lock when bogus sma
>>
>> Linus Torvalds (1):
>>       crazy rcu double free debug hack
>>
>> With ***both*** patches applied I am able to build a Linux-kernel with
>> 4 parallel-make-jobs again.
>> David's or your patch alone are not sufficient!
>>
>
> [ Still both patches applied ]
>
> To correct myself... The 1st run was OK.
>
> The 2nd run shows a NULL-pointer-deref (excerpt):
>
> [  178.490583] BUG: spinlock bad magic on CPU#1, sh/8066
> [  178.490595]  lock: 0xffff88008b53ea18, .magic: 6b6b6b6b, .owner:
> make/8068, .owner_cpu: 3
> [  178.490599] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [  178.490608] IP: [<ffffffff812bacd0>] update_queue+0x70/0x210
> [  178.490610] PGD 0
> [  178.490612] Oops: 0000 [#1] SMP
> ...
>
> See attached full dmesg!
>
> Hope this helps.
>
> - Sedat -
>
>
>> - Sedat -
>>
>>>     Linus

I have started a new thread "[next-20130419] ipc: sem: BROKEN", please
use this one!

Thanks for all your feedback!

- Sedat -

[1] http://marc.info/?l=linux-next&m=136646172915261&w=2
