Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaFYFvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:51:42 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:42322 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaFYFvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:51:35 -0400
Date: Wed, 25 Jun 2014 07:51:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [GIT PULL] nohz: Move nohz kick out of scheduler IPI, v9
Message-ID: <20140625055130.GC7208@gmail.com>
References: <1402935790-19860-1-git-send-email-fweisbec@gmail.com>
 <20140618164841.GA19204@gmail.com>
 <20140623125309.GA19860@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623125309.GA19860@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Jun 18, 2014 at 06:48:41PM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > Please pull the timers/nohz-irq-work-v7 branch that can be found at:
> > > 
> > 
> > Pulled, thanks a lot Frederic!
> 
> Ingo, the previous version had one of your machines fall over, is that
> machine good now?

It appears so. Will let you know if it still goes bad.

Thanks,

	Ingo
