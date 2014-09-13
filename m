Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaIMQrJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 12:47:09 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:59706 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaIMQrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 12:47:08 -0400
Date: Sat, 13 Sep 2014 18:47:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <Will.Deacon@arm.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 6/8] arm64: Tell irq work about self IPI support
Message-ID: <20140913164700.GA12358@lerouge>
References: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
 <1410384808-14760-7-git-send-email-fweisbec@gmail.com>
 <20140911090037.GK31237@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911090037.GK31237@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 10:00:37AM +0100, Catalin Marinas wrote:
> On Wed, Sep 10, 2014 at 10:33:26PM +0100, Frederic Weisbecker wrote:
> > ARM64 irq work self-IPI support depends on __smp_cross_call to point to
> > some relevant IRQ controller operations. This information should be
> > available after the call to init_IRQ().
> > 
> > Lets implement arch_irq_work_has_interrupt() accordingly.
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> For the arm64 bits:
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks a lot!
