Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab3DTREI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 13:04:08 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:33559 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab3DTREG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 13:04:06 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <5172BB6C.2020002@surriel.com>
References: <CA+icZUVWC+Rgd9wh4Z4CPZkEa9Pm2=2udnY5=UD1nnH0Wot1pQ@mail.gmail.com>
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
	<CA+icZUUG8bzGnnAhGfXA-gRRTin7cDj3-JK438PKepa=mgSJzw@mail.gmail.com>
	<5172BB6C.2020002@surriel.com>
Date: Sat, 20 Apr 2013 19:04:04 +0200
Message-ID: <CA+icZUVEURF4++qCOVrd4SGU8SQ2+r9FxxGAsD8-siDjNRapCQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 18 [ call-trace: drm | x86 | smp | rcu
 related? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Rik van Riel <riel@surriel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
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

On Sat, Apr 20, 2013 at 5:59 PM, Rik van Riel <riel@surriel.com> wrote:
> On 04/20/2013 08:46 AM, Sedat Dilek wrote:
>
>> I have started a new thread "[next-20130419] ipc: sem: BROKEN", please
>> use this one!
>>
>> Thanks for all your feedback!
>>
>> - Sedat -
>>
>> [1] http://marc.info/?l=linux-next&m=136646172915261&w=2
>
>
> I suspect most of us are not subscribed to the linux-next mailing list.
> I know I'm not.
>
> If you need someone on some email thread, you need to CC them on the
> email.
>

I dropped some irrelevant CCs from here in the new thread (as I did
not know from what the root-cause was).

LKML, linux-next, linux-mm MLs should be OK or am I missing someone or
another ML?

- Sedat -

> --
> All rights reversed.
