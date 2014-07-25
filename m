Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbaGYV1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 17:27:30 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49686 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaGYV1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:27:17 -0400
Date: Fri, 25 Jul 2014 23:27:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 06/10] nohz: Define meaningful symbol for nohz full
 timekeeper
Message-ID: <20140725212705.GB16182@localhost.localdomain>
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
 <1405730661-9355-7-git-send-email-fweisbec@gmail.com>
 <20140721181255.GH8690@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721181255.GH8690@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:12:55AM -0700, Paul E. McKenney wrote:
> On Sat, Jul 19, 2014 at 02:44:17AM +0200, Frederic Weisbecker wrote:
> > The nohz full timekeeper is always CPU 0. Lets add it to the list of
> > special tick_do_timer_cpu symbols for more self explanatory code.
> > 
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Sounds like Nicolas Pitre would like to be able to specify the default,
> perhaps at build time, but aside from that requested enhancement:

Ok. That's outside the scope of this patchset though as it doesn't change much things
in this regard: CPU 0 has been the timekeeper since the early days of nohz full.
And we still need a default timekeeper in any case, whether we can override it or not
in the future. So we still need that patch.

Then if big.LITTLE people are really interested in nohz full, we can still enhance
that in the future.

Thanks!
