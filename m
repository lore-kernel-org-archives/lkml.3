Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917Ab3EALC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 07:02:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35183
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756263Ab3EALCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 07:02:49 -0400
Date: Wed, 1 May 2013 13:01:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 0/7] posix-cpu-timers fixlet
Message-ID: <20130501110121.GE28253@dyad.programming.kicks-ass.net>
References: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 11:17:08PM -0400, kosaki.motohiro@gmail.com wrote:
> Glibc's posix timer testcase found a lot of bugs in posix timer code. This series, hopefully,
> fixes all of them. All patches are independent each other logically.
> 
> 
> [PATCH 1/7] posix-cpu-timers: don't account cpu timer after stopped thread runtime accounting
> [PATCH 2/7] posix-cpu-timers: fix acounting delta_exec twice
> [PATCH 3/7] posix-cpu-timers: fix wrong timer initialization
> [PATCH 4/7] posix-cpu-timers: timer functions must use timer time instead of clock time
> [PATCH 5/7] posix-cpu-timers: check_thread_timers() uses task_sched_runtime()
> [PATCH 6/7] sched: task_sched_runtime introduce micro optimization
> [PATCH 7/7] posix-cpu-timers: cleanup cpu_{clock,timer}_sample{,_group}


Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks for doing this Kosaki-San!
