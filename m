Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbbAWRG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:06:28 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53254 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbbAWRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:06:25 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUV+WFzb+1OAF5Va=qZNyozYj9-UYdRB=RwsRjrLKOiSqg@mail.gmail.com>
References: <CA+icZUV+WFzb+1OAF5Va=qZNyozYj9-UYdRB=RwsRjrLKOiSqg@mail.gmail.com>
Date: Fri, 23 Jan 2015 18:06:15 +0100
Message-ID: <CA+icZUXZ8UBB5P=rUd71g9ihfvwFqXdQH+HGa-cOW3k2qZcb4g@mail.gmail.com>
Subject: Re: [PATCH 0/2] sched: Preemption fixlet and cleanup
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 1:48 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> Hi,
>
> I am following the "frequent lockups in 3.18rc4" thread (see [0]).
>
> So, people still work on it, and one fixlet was going towards the sched/x86.
> Is there an update of your patchset [1] (especially of patch 2/2 [2]) around?
>
> One good thing in the discussion of [0] would be a short summarize and
> config-parameters to test with.
>
> Thanks in advance.
>
> Regards,
> - Sedat -
>
> [0] http://marc.info/?t=141600075000006&r=1&w=1
> [1] http://marc.info/?l=linux-kernel&m=141861029214340&w=1
> [2] http://marc.info/?t=141861036000004&r=1&w=1
>
> P.S.: I have applied the 3 patches of Linux on top of Linux v3.18.1
> and testing with that.
>
> Linus Torvalds (3):
>       x86: mm: move mmap_sem unlock from mm_fault_error() to caller
>       x86: mm: consolidate VM_FAULT_RETRY handling
>       x86: mm: fix VM_FAULT_RETRY handling

Hi Frederic,

OK, I have seen you pushed a fix called "sched: Fix missing preemption
check in cond_resched()" [1] in your linux-dynticks.git#sched/urgent
branch and Peter took it [2].

Can you please CC me if you have some material for testing.

Thanks.

Regards,
- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/frederic/linux-dynticks.git/commit/?h=sched/urgent&id=4ccbe99852951957419bc616f888e297a478e50b
[2] http://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git/commit/?h=sched/core&id=15789208c0c1a032d7e5392692e25d8c15e501ba
