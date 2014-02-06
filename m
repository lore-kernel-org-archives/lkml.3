Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaBFDLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 22:11:02 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:20427 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaBFDK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 22:10:59 -0500
Message-ID: <52F2FD2A.1020704@hp.com>
Date: Wed, 05 Feb 2014 22:10:34 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <1390933151-1797-1-git-send-email-Waiman.Long@hp.com> <1390933151-1797-2-git-send-email-Waiman.Long@hp.com> <20140131150832.GG4941@twins.programming.kicks-ass.net> <52EBF871.5020603@hp.com> <20140203114054.GH8874@twins.programming.kicks-ass.net>
In-Reply-To: <20140203114054.GH8874@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 06:40 AM, Peter Zijlstra wrote:
> On Fri, Jan 31, 2014 at 02:24:33PM -0500, Waiman Long wrote:
>> Light contention is the only case where the qspinlock may not perform as
>> good as the ticket spinlock. I know this is the most common case. However, I
>> would argue that the slowdown, if any, will not be really noticeable. This
>> is what I will try to find out.
> Please also explain why things are slower/faster. Thomas tried to get
> you to do so a few months back, but you kept deflecting.

It is not easy to have a test case to test light contention. I am trying 
to create custom test case to get that data.

-Longman
