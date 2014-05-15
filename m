Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaEONte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:49:34 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:41485 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaEONtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:49:31 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140515132235.GM30445@twins.programming.kicks-ass.net>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com> <20140515081444.GD11096@twins.programming.kicks-ass.net>
 <5374BE9E.8080408@redhat.com> <20140515132235.GM30445@twins.programming.kicks-ass.net>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 15 May 2014 15:49:10 +0200
Message-ID: <CAKgNAkjrS8WWMoQzsiOkMVn1_Bf06uFCL6ECU7z=mv0fszg+gQ@mail.gmail.com>
Subject: Re: futex(2) man page update help request
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Carlos O'Donell" <carlos@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 3:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, May 15, 2014 at 09:18:22AM -0400, Carlos O'Donell wrote:
>> On 05/15/2014 04:14 AM, Peter Zijlstra wrote:
>> > On Wed, May 14, 2014 at 04:23:38PM -0400, Carlos O'Donell wrote:
>> >> There are other syscalls like gettid() that have a:
>> >> NOTE: There is no glibc wrapper for this system call; see NOTES.
>> >
>> > Yes, can we finally fix that please? It gets tedious having to endlessly
>> > copy/paste that thing around.
>>
>> What exactly would you like fixed?
>
> Not having gettid() in glibc.

Get in the line ;-).
http://sourceware.org/bugzilla/show_bug.cgi?id=6399

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
