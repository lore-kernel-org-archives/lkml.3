Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaIKJAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:00:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38971 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbaIKJAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:00:43 -0400
Date: Thu, 11 Sep 2014 10:00:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <Will.Deacon@arm.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 6/8] arm64: Tell irq work about self IPI support
Message-ID: <20140911090037.GK31237@localhost>
References: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
 <1410384808-14760-7-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1410384808-14760-7-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 11 Sep 2014 09:00:38.0860 (UTC) FILETIME=[DB86B8C0:01CFCD9E]
X-MC-Unique: 114091110004103401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:33:26PM +0100, Frederic Weisbecker wrote:
> ARM64 irq work self-IPI support depends on __smp_cross_call to point to
> some relevant IRQ controller operations. This information should be
> available after the call to init_IRQ().
> 
> Lets implement arch_irq_work_has_interrupt() accordingly.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

For the arm64 bits:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

