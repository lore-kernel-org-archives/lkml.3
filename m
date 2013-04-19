Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965161Ab3DSWz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 18:55:59 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64878 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964935Ab3DSWz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 18:55:57 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+55aFxsMRKn8kkMr7Q1vGryR=E-E2hPJfdf2XUh6WLMZ3wLNw@mail.gmail.com>
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
Date: Sat, 20 Apr 2013 00:55:55 +0200
Message-ID: <CA+icZUWhB=BTaQp0XuC8+PocQf3FzxBoytbzYFh=kup0LsapRg@mail.gmail.com>
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

On Sat, Apr 20, 2013 at 12:50 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Apr 19, 2013 at 3:34 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>
>> See attached dmesg.
>
> This still has the bug Davidlohr pointed at:
>
>>> This looks like what Emmanuel was/is running into:
>>> https://lkml.org/lkml/2013/3/30/1
>
> you need to move the "IS_ERR()" check before the sem_lock.
>

Davidlohr pointed to this patch (tested the triplet):

ipc, sem: do not call sem_lock when bogus sma:
https://lkml.org/lkml/2013/3/31/12

Is that what you mean?

- Sedat -

>               Linus
