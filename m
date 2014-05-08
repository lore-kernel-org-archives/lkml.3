Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbaEHQd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:33:56 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:34113 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaEHQdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:33:54 -0400
Date: Thu, 8 May 2014 18:33:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        nicolas.pitre@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/idle: Reflow cpuidle_idle_call()
Message-ID: <20140508163346.GA9330@gmail.com>
References: <tip-cc6vb0snt3sr7op6rlbfeqfh@git.kernel.org>
 <1877683.4pfeUuvFZ2@vostro.rjw.lan>
 <1591569.1rC3xo6G18@vostro.rjw.lan>
 <20140508120826.GT11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508120826.GT11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, May 08, 2014 at 01:56:18PM +0200, Rafael J. Wysocki wrote:
> > The cpuidle patches I have queued up so far are on this separate branch
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-cpuidle
> > 
> > in case you'd like to pull from there.
> 
> Ingo, can you do that? I think the patch I just posted should be 
> enough to fix up the conflict.

Yeah, sounds good to me, I'll pull it into sched/core.

The patch you posted is essentially a replacement for:

    52c324f8a87b cpuidle: Combine cpuidle_enabled() with cpuidle_select()

when it's done on top of sched/core, right? I can construct a merge 
resolution from that.

Thanks,

	Ingo
