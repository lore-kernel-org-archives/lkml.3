Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab3EPJZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:25:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48819 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3EPJZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 05:25:11 -0400
Date: Thu, 16 May 2013 11:23:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: Re: [patch v6 8/8] sched: remove blocked_load_avg in tg
Message-ID: <20130516092308.GH19669@dyad.programming.kicks-ass.net>
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
 <1368199049-2798-9-git-send-email-alex.shi@intel.com>
 <20130514083148.GD15942@dyad.programming.kicks-ass.net>
 <5192217D.5030706@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5192217D.5030706@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 07:35:25PM +0800, Alex Shi wrote:

> I tested all benchmarks on cover letter maintained, aim7, kbuild etc.
> with autogroup enabled. There is no clear performance change.
> But since the machine just run benchmark without anyother load, that
> doesn't enough.

Back when we started with smp-fair cgroup muck someone wrote a test for it. I
_think_ it ended up in the LTP test-suite.

Now I don't know if that's up-to-date enough to catch some of the cases we've
recently fixed (as in the past few years) so it might want to be updated.

Paul, do you guys at Google have some nice test-cases for all this?
