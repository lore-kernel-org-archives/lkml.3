Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbaEIPK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:10:29 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35569 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaEIPK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:10:27 -0400
Date: Fri, 9 May 2014 17:10:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        khilman@linaro.org, tglx@linutronix.de, axboe@fb.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/nohz] nohz: Move full nohz kick to its own IPI
Message-ID: <20140509151019.GB30010@localhost.localdomain>
References: <20140505133113.GD1429@laptop.programming.kicks-ass.net>
 <20140505150356.GB2099@localhost.localdomain>
 <20140505151228.GR26782@laptop.programming.kicks-ass.net>
 <20140505153405.GD2099@localhost.localdomain>
 <20140507151735.GQ30445@twins.programming.kicks-ass.net>
 <20140507152922.GB16694@localhost.localdomain>
 <20140507153736.GS30445@twins.programming.kicks-ass.net>
 <20140507160504.GC16694@localhost.localdomain>
 <20140507161350.GT30445@twins.programming.kicks-ass.net>
 <20140507190714.GA22890@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507190714.GA22890@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 09:07:14PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, May 07, 2014 at 06:05:08PM +0200, Frederic Weisbecker wrote:
> > > So we can as well zap these commits and replace them with the irq_work_on()
> > > conversion (still preparing that).
> > 
> > I hear you, but I think Ingo doesn't want to rebase the tree because its
> > public, but maybe he can make an exception..
> 
> Since tip:timers/nohz only contains these commits:
> 
>  fc1781cc66b1 Merge branch 'timers/nohz-ipi-for-tip-v3' of git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks into timers/nohz
>  72aacf0259bb nohz: Move full nohz kick to its own IPI
>  55d77c215c74 smp: Non busy-waiting IPI queue
> 
> we can zap them all, or even keep 55d77c215c74.
> 
> Frederic, which one would you prefer?

I think we can zap them all. But since I'm not yet sure how the new solution, based on irq work,
is going to be received, do you mind if we just wait for the new solution to be acked by Peterz?

If that's ok for you, I'll then do a pull request that includes the solution and zaps the old two
commits.

Thanks!
