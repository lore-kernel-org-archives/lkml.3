Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaGVQ34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:29:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59455 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbaGVQ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:29:54 -0400
Date: Tue, 22 Jul 2014 18:29:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: John Stultz <john.stultz@linaro.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
Message-ID: <20140722162940.GH3935@laptop>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
 <20140718191338.GF3935@laptop>
 <CALAqxLX4ia_dBO-oNY1XMnSrJdDZc87EneHj9WcxtOZaupZaCg@mail.gmail.com>
 <20140718193417.GG3935@laptop>
 <53C97995.2090500@linaro.org>
 <20140718202250.GR9918@twins.programming.kicks-ass.net>
 <20140718224100.GV3588@twins.programming.kicks-ass.net>
 <1406045843.25343.71.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406045843.25343.71.camel@hornet>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 05:17:23PM +0100, Pawel Moll wrote:
> > Now, I already mentioned max error bounds, and I've not yet looked at
> > your actual control loop, but that is something to keep in mind, we want
> > something that's limited.
> 
> Indeed. Richard has already expressed concerns that my coefficients
> won't work everywhere (as in with different clock rate ratios) and he's
> most likely right. My money is on a more advanced, "self-tuning"
> solution, where we definitely need an escape condition.

I was wanting to look up software PLLs, as I seem to remember that's
what NTP and PTP use, but Richard should know I think.

Its not really a subject I've looked at before.
