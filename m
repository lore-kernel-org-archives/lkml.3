Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbaBFWkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:40:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48250 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137AbaBFWke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:40:34 -0500
Message-ID: <52F40F21.8070200@zytor.com>
Date: Thu, 06 Feb 2014 14:39:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave.hansen@intel.com>, Andrey Panin <pazke@donpac.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-visws-devel@lists.sf.net
Subject: Re: [patch 1/4] x86, apic: Only use default_wait_for_init_deassert
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com> <87txcc57y2.fsf@tassilo.jf.intel.com> <alpine.DEB.2.02.1402061430420.29446@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402061430420.29446@chino.kir.corp.google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 02:31 PM, David Rientjes wrote:
> 
> How do we usually do that?  Do we add a big fat warning for anyone who is 
> using it for a few releases or just yank support out entirely and see if 
> we're surprised?
> 

We don't really *have* a good way of deprecation, this is the problem.
Usually it doesn't happen until we find out that a bug snuck its way in
and "X hasn't worked for N releases now, and noone has noticed."
Voyager was finally killed off because the maintainer of the port was
unwilling to keep up with the mainstream kernel flux.  The i386 explicit
deprecation was definitely one of the more high-profile removals of a
largely working port, and was a (brief) Kernel Summit topic.

I would love to see NumaQ, VisWS, Summit and ES7000 just nuked.  In
fact, I'm thinking that unless someone steps up and explicitly claims
ownership of those platforms by adding their name to MAINTAINERS (or
reiterating them in the case of VisWS, which MAINTAINERS entry says "for
2.6") we should just rip them all out.

Anyone who wants to disagree?

	-hpa

