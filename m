Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab3KZS7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:59:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56005 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab3KZS7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:59:02 -0500
Date: Tue, 26 Nov 2013 19:58:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [patch 4/6] ia64: Use preempt_schedule_irq
Message-ID: <20131126185847.GE789@laptop.programming.kicks-ass.net>
References: <20130917082838.218329307@infradead.org>
 <20130917182350.449685712@linutronix.de>
 <20130917183628.857145384@linutronix.de>
 <CA+8MBbKq1idWt1OSpRM3mWMDAQaEoewrU=h=m_pFoidVy6OA-Q@mail.gmail.com>
 <alpine.DEB.2.02.1311202121340.30673@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1311211230030.30673@ionos.tec.linutronix.de>
 <20131121130605.GE10022@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1311211428450.30673@ionos.tec.linutronix.de>
 <CA+8MBbL4sBZK26O_+VQizNy-5mWtieDBfAy5CDcNBFxvorEp3g@mail.gmail.com>
 <CA+8MBbL3oscq6GpgyTBb6hxdzuG+Gj_ahdu4rpvTTaPvrF+8_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbL3oscq6GpgyTBb6hxdzuG+Gj_ahdu4rpvTTaPvrF+8_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:37:59AM -0800, Tony Luck wrote:
> On Thu, Nov 21, 2013 at 10:57 AM, Tony Luck <tony.luck@gmail.com> wrote:
> > On Thu, Nov 21, 2013 at 5:30 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> On Thu, 21 Nov 2013, Peter Zijlstra wrote:
> >>> Anyway, I don't object to the patch per se, but it might bloat a few
> >>> !ia64 kernels for having to carry the extra text.
> >
> > I tried it out ... if does fix both build & boot for ia64 with
> > PREMPT=n and PREMPT=y
> >
> > Tested-by: Tony Luck <tony.luck@intel.com>
> 
> So - are we going with this patch?  Or still thinking of something better?

I queued it; let me prod Ingo (again) into actually merging it.
