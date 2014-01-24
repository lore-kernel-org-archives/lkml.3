Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaAXRD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:03:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:52832 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaAXRDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:03:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,713,1384329600"; 
   d="scan'208";a="444142740"
Subject: Re: [PATCH v9 6/6] MCS Lock: Allow architecture specific asm files
 to be used for contended case
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
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
In-Reply-To: <20140122183539.GM30183@twins.programming.kicks-ass.net>
References: <cover.1390320729.git.tim.c.chen@linux.intel.com>
	 <1390347382.3138.67.camel@schen9-DESK>
	 <20140122183539.GM30183@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jan 2014 09:03:49 -0800
Message-ID: <1390583029.3138.78.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 19:35 +0100, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 03:36:22PM -0800, Tim Chen wrote:
> > diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
> > index 8b19a80..24027ce 100644
> > --- a/arch/powerpc/include/asm/Kbuild
> > +++ b/arch/powerpc/include/asm/Kbuild
> > @@ -1,6 +1,8 @@
> >  
> > +generic-y += +=
> >  generic-y += clkdev.h
> > +generic-y += mcs_spinlock.h
> >  generic-y += preempt.h
> >  generic-y += rwsem.h
> >  generic-y += trace_clock.h
> > -generic-y += vtime.h
> > +generic-y += vtime.hgeneric-y
> 
> Something went funny there, fixed it.

Thanks for fixing it.  I assume Peter you have picked up
the patch series and merged them?

Tim


