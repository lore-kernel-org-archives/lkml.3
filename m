Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaEOAl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 20:41:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34826 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaEOAl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 20:41:56 -0400
Message-ID: <53740D1E.6060609@zytor.com>
Date: Wed, 14 May 2014 17:41:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Davidlohr Bueso <davidlohr@hp.com>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Subject: Re: futex(2) man page update help request
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <1400100977.3865.30.camel@buesod1.americas.hpqcorp.net> <53740A30.20807@zytor.com> <CALCETrXzMiS9DwvmZn++wg0x6v-ZR0YP9fAdco4PRST=nTY4nQ@mail.gmail.com>
In-Reply-To: <CALCETrXzMiS9DwvmZn++wg0x6v-ZR0YP9fAdco4PRST=nTY4nQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 05:35 PM, Andy Lutomirski wrote:
>>
>> More fundamentally, futex(2), like clone(2), are things that can be
>> legitimately by user space without automatically breaking all of glibc.
> 
> I'm lost -- I think the missing verb is important :)
> 

... legitimately *used* by user space ...

As in you can use it to implement your own, non-POSIX, synchronization
primitives.

	-hpa

