Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbaGVQRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:17:54 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:47767 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756016AbaGVQRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:17:18 -0400
Message-ID: <1406045838.25343.70.camel@hornet>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <john.stultz@linaro.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jul 2014 17:17:18 +0100
In-Reply-To: <20140718193417.GG3935@laptop>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
	 <20140718191338.GF3935@laptop>
	 <CALAqxLX4ia_dBO-oNY1XMnSrJdDZc87EneHj9WcxtOZaupZaCg@mail.gmail.com>
	 <20140718193417.GG3935@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 20:34 +0100, Peter Zijlstra wrote:
> On Fri, Jul 18, 2014 at 12:25:48PM -0700, John Stultz wrote:
> > Also, assuming we someday will merge the x86 sched_clock logic into
> > the generic sched_clock code, we'll have to handle cases where they
> > aren't the same.
> 
> I prefer that to not happen. I spend quite a bit of time and effort to
> make the x86 code go fast, and that generic code doesn't look like fast
> at all.

Actually one of my long-ish time goals to is to speed it up (withing the
generic framework) for arm64 as well, so we may get back to the
discussion then :-)

Pawel

