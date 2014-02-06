Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbaBFWwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:52:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:38578 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaBFWwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:52:44 -0500
Date: Thu, 6 Feb 2014 23:52:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Andrey Panin <pazke@donpac.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-visws-devel@lists.sf.net
Subject: Re: [patch 1/4] x86, apic: Only use default_wait_for_init_deassert
In-Reply-To: <52F40F21.8070200@zytor.com>
Message-ID: <alpine.DEB.2.02.1402062342190.21991@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com> <87txcc57y2.fsf@tassilo.jf.intel.com> <alpine.DEB.2.02.1402061430420.29446@chino.kir.corp.google.com> <52F40F21.8070200@zytor.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, H. Peter Anvin wrote:
> On 02/06/2014 02:31 PM, David Rientjes wrote:
> > 
> > How do we usually do that?  Do we add a big fat warning for anyone who is 
> > using it for a few releases or just yank support out entirely and see if 
> > we're surprised?
> > 
> 
> We don't really *have* a good way of deprecation, this is the problem.
> Usually it doesn't happen until we find out that a bug snuck its way in
> and "X hasn't worked for N releases now, and noone has noticed."
> Voyager was finally killed off because the maintainer of the port was
> unwilling to keep up with the mainstream kernel flux.  The i386 explicit
> deprecation was definitely one of the more high-profile removals of a
> largely working port, and was a (brief) Kernel Summit topic.
> 
> I would love to see NumaQ, VisWS, Summit and ES7000 just nuked.  In
> fact, I'm thinking that unless someone steps up and explicitly claims
> ownership of those platforms by adding their name to MAINTAINERS (or
> reiterating them in the case of VisWS, which MAINTAINERS entry says "for
> 2.6") we should just rip them all out.
> 
> Anyone who wants to disagree?

Anyone who disagrees is automatically appointed to fill in the vacancy
in that section of the maintainers file:

PALEONTOLOGICAL SYSTEMS
M:      vacant@paleontological.systems
S:      reanimation

Thanks,

	tglx
