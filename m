Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaEONrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:47:00 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:59114 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaEONq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:46:58 -0400
Message-ID: <5374C54B.7040408@gmail.com>
Date: Thu, 15 May 2014 15:46:51 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>
CC: mtk.manpages@gmail.com,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Subject: Re: futex(2) man page update help request
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <537407ED.8050606@zytor.com> <CF999CD6.90A93%dvhart@linux.intel.com>
In-Reply-To: <CF999CD6.90A93%dvhart@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 07:21 AM, Darren Hart wrote:
> On 5/14/14, 17:18, "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> On 05/14/2014 09:18 AM, Darren Hart wrote:
>>>
>>> However, unless I'm sorely mistaken, the larger problem is that glibc
>>> removed the futex() call entirely, so these man pages don't describe
>>> something users even have access to anymore. I had to revert to calling
>>> the syscalls directly in the futextest test suite because of this:
>>>
>>>
>>> http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/inc
>>> lu
>>> de/futextest.h#n67
>>>
>>
>> This really comes down to the fact that we should have a libinux which
>> contains the basic system call wrapper machinery for Linux specific
>> things and nothing else.
>>
>> syscall(3) is toxic and breaks randomly on some platforms.
> 
> Peter Z and I have had a good time discussing this in the past.... And
> here it is again. :-)

People have a number of times noted that there are problems
with syscall(), but I'm not knowledgeable on the details.
I'd happily take a patch to the man page (which, for historical
reasons, is actually syscall(2)) that explains the the problems 
(and ideally notes those platforms where there are no problems).

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
