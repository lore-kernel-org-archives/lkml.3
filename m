Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962AbaEFErx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 00:47:53 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:54177 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933937AbaEFErw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 00:47:52 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 6 May 2014 00:51:33 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Ingo Molnar <mingo@kernel.org>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140505172951.GB7154@gmail.com>
Message-ID: <alpine.DEB.2.10.1405060041140.1436@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405021230130.22556@vincent-weaver-1.umelst.maine.edu> <20140502172731.GK30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu>
 <20140505093124.GN17778@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu> <20140505172951.GB7154@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2014, Ingo Molnar wrote:
> 
> I'm also thinking about waiting a bit before applying anything even 
> borderline intrusive to the perf core, to make sure there's enough 
> fuzz time to declare stable state (at least as far into the ABI as the 
> fuzzing is able to reach). Future bisection efforts could use that 
> kind of known-stable release.

That does sound like a good idea.  It is nice finally getting to the state 
where you can fuzz for hours (rather than minutes) without hitting a bug.

Of course that might change.  Development of the fuzzer has more or less
stalled for the past 6 months as I was spending all of my time 
reporting/chasing bugs rather than enhancing the fuzzer.  

In any case if we can get the recent patches applied in time for 3.15 I 
think it will turn out to be a nice release perf-event-stability wise.

Vince
