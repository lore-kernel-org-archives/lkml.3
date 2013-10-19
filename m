Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3JSQF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 12:05:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39744 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3JSQF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 12:05:26 -0400
Date: Sat, 19 Oct 2013 18:05:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 4/5] sched: Refactor iowait accounting
Message-ID: <20131019160517.GB2490@laptop.programming.kicks-ass.net>
References: <1382195841-6558-1-git-send-email-fweisbec@gmail.com>
 <1382195841-6558-5-git-send-email-fweisbec@gmail.com>
 <20131019153535.GA2490@laptop.programming.kicks-ass.net>
 <20131019160235.GA13534@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131019160235.GA13534@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 06:02:37PM +0200, Frederic Weisbecker wrote:
> > I just had a look at delayacct; wth wrote that crap; that too uses
> > gtod.
> 
> I can't find where it does that. kernel/delayacct.c doesn't seem to at least.

Look for do_posix_clock_monotonic_gettime() ;-)
