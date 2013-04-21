Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab3DUJFQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 05:05:16 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41010 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab3DUJFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 05:05:14 -0400
Date: Sun, 21 Apr 2013 11:05:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] nohz: Full dynticks timekeeping and RCU improvement
Message-ID: <20130421090510.GC31470@gmail.com>
References: <1366215889-2635-1-git-send-email-fweisbec@gmail.com>
 <CAFTL4hy48=qsSk4wpV=w70iPxoYmE6TJbw4W_4H43vvs+=Oj3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hy48=qsSk4wpV=w70iPxoYmE6TJbw4W_4H43vvs+=Oj3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2013/4/17 Frederic Weisbecker <fweisbec@gmail.com>:
> > Hi Ingo,
> >
> > So with this we are mostly done with the RCU and timekeeping sides.
> > The interface is still a bit spartan:
> >
> > * Need to keep the boot CPU outside full dynticks range.
> > * Need to have nohz_full= be a subset of rcu_nocbs=
> >
> > Note that none of this is thought to be fixed on the rock. It's
> > just a KISS interface settlement so that we can focus on the
> > central things.
> >
> > These constraints will likely be removed in the future.
> >
> > Please pull from:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> >         timers/nohz
> 
> And there is the branch "timers/nohz-reviewed" which contain the exact
> same patches but rebased to add Paul's Reviewed-by: tags.

Pulled, thanks Frederic!

	Ingo
