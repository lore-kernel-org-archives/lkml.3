Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaEBULn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:11:43 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39336 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaEBULl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:11:41 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 2 May 2014 16:15:11 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu> <20140501150948.GR11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu> <20140502154217.GW11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021218350.22556@vincent-weaver-1.umelst.maine.edu>
 <20140502162234.GX11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021230130.22556@vincent-weaver-1.umelst.maine.edu> <20140502172731.GK30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014, Thomas Gleixner wrote:

> Hmm, and where comes the WARN_ON in _free_event() from? That's not in
> Peters last patch.

ahh, you're right :(  My fault.  I gave the new patch and the previous 
patch similar names and applied the wrong one.

OK the proper patch has been running the quick reproducer for a bit 
without triggering the issue, I'll let it run a bit more and then upgrade 
to full fuzzing.

Vince
