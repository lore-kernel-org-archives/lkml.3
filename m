Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaHUPVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:21:41 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56720 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751680AbaHUPVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:21:38 -0400
Date: Thu, 21 Aug 2014 16:21:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 6/9] arm: Tell irq work about self IPI support
Message-ID: <20140821152122.GL30401@n2100.arm.linux.org.uk>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com> <1408632777-3348-7-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408632777-3348-7-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 04:52:54PM +0200, Frederic Weisbecker wrote:
> ARM irq work IPI support depends on SMP support. That information is
> partly known at early boottime. Lets implement
> arch_irq_work_has_own_interrupt() accordingly.

Sorry, this makes no sense on its own.  As there's no context for this
to know whether it's an appropriate change or not, it would be
irresponsible fo me to provide an ack for something I don't understand.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
