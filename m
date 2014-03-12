Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaCLPrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:47:22 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50736 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaCLPrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:47:20 -0400
Date: Wed, 12 Mar 2014 16:47:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Archs <linux-arch@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 6/6] arch: Remove stub cputime.h headers
Message-ID: <20140312154715.GB12280@localhost.localdomain>
References: <1394590202-772-1-git-send-email-fweisbec@gmail.com>
 <1394590202-772-7-git-send-email-fweisbec@gmail.com>
 <20140312094447.GP30956@twins.programming.kicks-ass.net>
 <20140312152323.GA12280@localhost.localdomain>
 <20140312152644.GF27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312152644.GF27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 04:26:44PM +0100, Peter Zijlstra wrote:
> On Wed, Mar 12, 2014 at 04:23:28PM +0100, Frederic Weisbecker wrote:
> > On Wed, Mar 12, 2014 at 10:44:47AM +0100, Peter Zijlstra wrote:
> > > On Wed, Mar 12, 2014 at 03:10:02AM +0100, Frederic Weisbecker wrote:
> > > > diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
> > > > index a73a8e2..1a81a8b 100644
> > > > --- a/arch/alpha/include/asm/Kbuild
> > > > +++ b/arch/alpha/include/asm/Kbuild
> > > > @@ -5,3 +5,4 @@ generic-y += exec.h
> > > >  generic-y += trace_clock.h
> > > >  generic-y += preempt.h
> > > >  generic-y += hash.h
> > > > +generic-y += cputime.h
> > > > \ No newline at end of file
> > > 
> > > That's a double fail there, not sorted and no EOL.
> > > 
> > > Please run the script from commit: b119fa61d440f after you touch the
> > > asm/Kbuild files.
> > 
> > I don't see why we need to sort them. But I'm running the script anyway.
> > Will resend, thanks.
> 
> sfr gets real grumpy if we don't, at one point I gave in and wrote that
> script, because I sure as hell wasn't going to manually sort all those
> files every time I did a automated addition.

I see, it's to avoid merge conflicts then. Granted.
