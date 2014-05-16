Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbaEPSP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:15:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109AbaEPSPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:15:25 -0400
Message-ID: <53765597.6000400@redhat.com>
Date: Fri, 16 May 2014 14:14:47 -0400
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
References: <20140512190438.314125476@linutronix.de> <20140513035404.GA68181@dvhart-mac01.local> <537313FD.4000306@redhat.com> <20140514092203.GE30445@twins.programming.kicks-ass.net> <5373DD6F.40506@redhat.com> <20140515080753.GB30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140515080753.GB30445@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 04:07 AM, Peter Zijlstra wrote:
> On Wed, May 14, 2014 at 05:17:35PM -0400, Carlos O'Donell wrote:
>>> No, its perfectly fine to have a lock sequence abort with -EDEADLK.
>>> Userspace should release its locks and re-attempt.
>>
>> I agree. If I can prove that it's actually a deadlock, and
>> that unlock/relock will work to fix it, then we can arrange for glibc
>> to return EDEADLK.
> 
> The only reason the kernel would return EDEADLK is because its walked
> the lock graph and determined its well, a deadlock.

Perfect. No further comments from me then.

Cheers,
Carlos.

