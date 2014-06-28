Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbaF1STh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:19:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56699 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606AbaF1STf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 14:19:35 -0400
Date: Sat, 28 Jun 2014 20:19:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH 2/6] irq_work: Implement remote queueing
Message-ID: <20140628181931.GB6357@pd.tnic>
References: <20140625051721.GG3588@twins.programming.kicks-ass.net>
 <53AA6E11.1000404@linux.vnet.ibm.com>
 <20140625093657.GN19860@laptop.programming.kicks-ass.net>
 <20140625093944.GV16155@laptop.programming.kicks-ass.net>
 <53AA9B68.4050104@linux.vnet.ibm.com>
 <53AA9C43.3020903@linux.vnet.ibm.com>
 <20140625101915.GO19860@laptop.programming.kicks-ass.net>
 <53AAF779.8060006@wwwdotorg.org>
 <20140625163820.GC3935@laptop>
 <53AAFF74.8090308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53AAFF74.8090308@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:27:24PM +0530, Srivatsa S. Bhat wrote:
> > https://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git/commit/?h=timers/nohz&id=921d8b81281ecdca686369f52165d04fa3505bd7

Just hit it here too. Cherry-picking it ontop of latest tip fixes the
issue, thanks.

Tested-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
