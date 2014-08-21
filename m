Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaHURf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:35:57 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:46612 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbaHURf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:35:56 -0400
Date: Thu, 21 Aug 2014 19:35:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 6/9] arm: Tell irq work about self IPI support
Message-ID: <20140821173547.GD3916@lerouge>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
 <1408632777-3348-7-git-send-email-fweisbec@gmail.com>
 <20140821152122.GL30401@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821152122.GL30401@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 04:21:23PM +0100, Russell King - ARM Linux wrote:
> On Thu, Aug 21, 2014 at 04:52:54PM +0200, Frederic Weisbecker wrote:
> > ARM irq work IPI support depends on SMP support. That information is
> > partly known at early boottime. Lets implement
> > arch_irq_work_has_own_interrupt() accordingly.
> 
> Sorry, this makes no sense on its own.  As there's no context for this
> to know whether it's an appropriate change or not, it would be
> irresponsible fo me to provide an ack for something I don't understand.

Ah you're right, I should have Cc'ed you for all patches in the series.
I didn't because I wanted to avoid spaming you but sending that patch alone
doesn't make much sense.

Let me bounce the rest to you.
