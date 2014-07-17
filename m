Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbaGQJlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:41:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54450 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbaGQJk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:40:56 -0400
Date: Thu, 17 Jul 2014 11:40:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-ia64@vger.kernel.org,
        sparse@chrisli.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-tip-commits@vger.kernel.org, akataria@vmware.com,
        anil.s.keshavamurthy@intel.com,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, yrl.pp-manager.tt@hitachi.com,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, rdunlap@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dl9pf@gmx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Re: Re: [PATCH v5 2/2] [BUGFIX] kprobes: Fix "Failed to find
 blacklist" error on ia64 and ppc64
Message-ID: <20140717094045.GC4232@gmail.com>
References: <1404276081.7254.1.camel@concordia>
 <20140702070029.14689.18485.stgit@kbuild-fedora.novalocal>
 <1405394370.17767.7.camel@concordia>
 <1405408602.9343.75.camel@pasglop>
 <53C4FDC8.9050801@hitachi.com>
 <20140716132838.GA18597@gmail.com>
 <53C776ED.3050001@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C776ED.3050001@hitachi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2014/07/16 22:28), Ingo Molnar wrote:
> > 
> > * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> >> (2014/07/15 16:16), Benjamin Herrenschmidt wrote:
> >>> On Tue, 2014-07-15 at 13:19 +1000, Michael Ellerman wrote:
> >>>
> >>>>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> >>>>> Reported-by: Tony Luck <tony.luck@gmail.com>
> >>>>> Tested-by: Tony Luck <tony.luck@intel.com>
> >>>>> Cc: Michael Ellerman <mpe@ellerman.id.au>
> >>>>
> >>>> Tested-by: Michael Ellerman <mpe@ellerman.id.au>
> >>>> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (for powerpc)
> >>>>
> >>>> Ben, can you take this in your tree?
> >>>
> >>> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >>>
> >>> That looks more like generic material. Do we have a kprobes maintainer ?
> >>> Andrew, do you want to take this ?
> >>
> >> Yeah, I usually use Ingo's tip tree for kprobes maintenance.
> >> Ingo, could you pull this as urgent-for-linus patch?
> > 
> > Mind resending it in a separate thread with all acks added, etc?
> 
> OK, I'll resend that soon.
> BTW, I missed Suzuki's Signed-off-by in this version,
> I'd like to recover that since he made a big bugfix on this.

That kind of credit can be added as:

  Fixed-by: Suzuki K. Poulose <suzuki@in.ibm.com>

and by also adding a sentence to the log message (outside of the 
version changelogs which get stripped ususally).

Thanks,

	Ingo
