Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023AbaECHd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 03:33:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaECHd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 03:33:28 -0400
Date: Sat, 3 May 2014 09:33:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140503073314.GJ17778@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1405021218350.22556@vincent-weaver-1.umelst.maine.edu>
 <20140502162234.GX11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405021230130.22556@vincent-weaver-1.umelst.maine.edu>
 <20140502172731.GK30445@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 11:02:25PM -0400, Vince Weaver wrote:
> On Fri, 2 May 2014, Vince Weaver wrote:
> 
> > I've been fuzzing without your additional patch for 6 hours and all looks
> > (almost) good.  I can add in your patch and let it fuzz overnight.
> 
> and I applied the additional patch, installed the kernel, hit reboot, and 
> the following happened (this was caused by rebooting while fuzzing
> was ongoing) :(
> 
> I'm remote from the system too so the poor machine is going to be sitting 
> there oopsing away until Monday.

Yeah, my system did the same when I tried to shut it down last night. I
have remote power though (or else I would've been forced to like walk
downstairs) :-)

I suppose that means I'll have something to do come Monday morning.
