Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaAUKUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:20:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49016 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaAUKUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:20:33 -0500
Date: Tue, 21 Jan 2014 11:20:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH v8 6/6] MCS Lock: Allow architecture specific asm files
 to be used for contended case
Message-ID: <20140121102000.GT31570@twins.programming.kicks-ass.net>
References: <cover.1390239879.git.tim.c.chen@linux.intel.com>
 <1390267479.3138.40.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390267479.3138.40.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 05:24:39PM -0800, Tim Chen wrote:
> diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
> index f01fb50..14cbbbc 100644
> --- a/arch/alpha/include/asm/Kbuild
> +++ b/arch/alpha/include/asm/Kbuild
> @@ -4,3 +4,4 @@ generic-y += clkdev.h
>  generic-y += exec.h
>  generic-y += trace_clock.h
>  generic-y += preempt.h
> +generic-y += mcs_spinlock.h

m < p

> --- a/arch/ia64/include/asm/Kbuild
> +++ b/arch/ia64/include/asm/Kbuild
> @@ -4,4 +4,4 @@ generic-y += exec.h
>  generic-y += kvm_para.h
>  generic-y += trace_clock.h
>  generic-y += preempt.h
> -generic-y += vtime.h
> \ No newline at end of file
> +generic-y += vtime.hgeneric-y += mcs_spinlock.h

EOL fail
