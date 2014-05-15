Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaEOEww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:52:52 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34133 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaEOEwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:52:50 -0400
Message-ID: <53744767.8090307@gmail.com>
Date: Thu, 15 May 2014 06:49:43 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Carlos O'Donell" <carlos@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: mtk.manpages@gmail.com, Darren Hart <dvhart@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: futex(2) man page update help request
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com> <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de> <537430B5.2060001@redhat.com>
In-Reply-To: <537430B5.2060001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 05:12 AM, Carlos O'Donell wrote:
> On 05/14/2014 07:34 PM, Thomas Gleixner wrote:
>> On Wed, 14 May 2014, Carlos O'Donell wrote:
>>
>>> On 05/14/2014 03:03 PM, Michael Kerrisk (man-pages) wrote:
>>>>> However, unless I'm sorely mistaken, the larger problem is that glibc
>>>>> removed the futex() call entirely, so these man pages don't describe
>>>>
>>>> I don't think futex() ever was in glibc--that's by design, and
>>>> completely understandable: no user-space application would want to
>>>> directly use futex(). (BTW, I mispoke in my earlier mail when I said I
>>>> wanted documentation suitable for "writers of library functions" -- I
>>>> meant suitable for "writers of *C library*".)
>>>
>>> I fully agree with Michael here.
>>>
>>> The futex() syscall was never exposed to userspace specifically because
>>> it was an interface we did not want to support forever with a stable ABI.
>>> The futex() syscall is an implementation detail that is shared between
>>> the kernel and the writers of core runtimes for Linux.
>>
>> Nonsense. 
> 
> What is nonsense?

I suspect there's a misunderstanding between worlds here. Thomas means
that the kernel ABI is stable. You mean, glibc does not want to have to
export an ABI that you have to support.

> I do not want to be responsible for the futex API by having glibc provide
> wrappers. That can't be nonsense since it's a glibc community decision to
> make.

See my above.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
