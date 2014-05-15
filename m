Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaEOFVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:21:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:36456 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaEOFVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:21:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1057,1389772800"; 
   d="scan'208";a="532204362"
User-Agent: Microsoft-MacOutlook/14.4.1.140326
Date: Wed, 14 May 2014 22:21:52 -0700
Subject: Re: futex(2) man page update help request
From: Darren Hart <dvhart@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>
CC: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Message-ID: <CF999CD6.90A93%dvhart@linux.intel.com>
Thread-Topic: futex(2) man page update help request
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <537407ED.8050606@zytor.com>
In-Reply-To: <537407ED.8050606@zytor.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/14, 17:18, "H. Peter Anvin" <hpa@zytor.com> wrote:

>On 05/14/2014 09:18 AM, Darren Hart wrote:
>> 
>> However, unless I'm sorely mistaken, the larger problem is that glibc
>> removed the futex() call entirely, so these man pages don't describe
>> something users even have access to anymore. I had to revert to calling
>> the syscalls directly in the futextest test suite because of this:
>> 
>> 
>>http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/inc
>>lu
>> de/futextest.h#n67
>> 
>
>This really comes down to the fact that we should have a libinux which
>contains the basic system call wrapper machinery for Linux specific
>things and nothing else.
>
>syscall(3) is toxic and breaks randomly on some platforms.

Peter Z and I have had a good time discussing this in the past.... And
here it is again. :-)


-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



