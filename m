Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936948Ab3DIHc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:32:29 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:48473 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936592Ab3DIHc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:32:28 -0400
Date: Tue, 9 Apr 2013 09:31:41 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:smp/hotplug] avr32: Use generic idle loop
Message-ID: <20130409073140.GC10261@samfundet.no>
References: <20130321215233.950290809@linutronix.de>
 <tip-01426478df3a8791ff5c8b6b82d409e699cfaf38@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-01426478df3a8791ff5c8b6b82d409e699cfaf38@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 08 Apr 2013 13:20:05 -0700 or thereabout, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  01426478df3a8791ff5c8b6b82d409e699cfaf38
> Gitweb:     http://git.kernel.org/tip/01426478df3a8791ff5c8b6b82d409e699cfaf38
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Thu, 21 Mar 2013 22:49:40 +0100
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Mon, 8 Apr 2013 17:39:24 +0200
> 
> avr32: Use generic idle loop
> 
> Also replace the idle poll enforcement by the generic functionality.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Link: http://lkml.kernel.org/r/20130321215233.950290809@linutronix.de
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/Kconfig                       |  1 +
>  arch/avr32/kernel/process.c              | 13 ++-----------
>  arch/avr32/kernel/time.c                 |  9 +++++++--
>  arch/avr32/mach-at32ap/include/mach/pm.h | 24 ------------------------
>  arch/avr32/mach-at32ap/pm-at32ap700x.S   |  7 -------
>  5 files changed, 10 insertions(+), 44 deletions(-)

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
