Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbaGRTGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:06:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40494 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbaGRTGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:06:18 -0400
Date: Fri, 18 Jul 2014 21:06:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
Message-ID: <20140718190602.GE3935@laptop>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
 <53C95E97.2020805@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C95E97.2020805@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 10:51:19AM -0700, John Stultz wrote:
> Very cool work! I've not been able to review it carefully, but one good
> stress test would be to pick a system where the hardware used for
> sched_clock is different from the hardware used for timekeeping.
> 
> Probably easily done on x86 hardware that normally uses the TSC, but has
> HPET/ACPI PM hardware available. After the system boots, change the
> clocksource via:
> /sys/devices/system/clocksource/clocksource0/current_clocksource

Note that x86 uses none of the code patched.
