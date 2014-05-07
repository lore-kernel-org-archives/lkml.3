Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaEGTLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:11:50 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55939 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaEGTLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:11:49 -0400
Date: Wed, 7 May 2014 21:11:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140507191142.GA23040@gmail.com>
References: <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu>
 <20140505093124.GN17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu>
 <20140505172951.GB7154@gmail.com>
 <alpine.DEB.2.10.1405060041140.1436@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405060041140.1436@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vincent.weaver@maine.edu> wrote:

> On Mon, 5 May 2014, Ingo Molnar wrote:
> > 
> > I'm also thinking about waiting a bit before applying anything even 
> > borderline intrusive to the perf core, to make sure there's enough 
> > fuzz time to declare stable state (at least as far into the ABI as the 
> > fuzzing is able to reach). Future bisection efforts could use that 
> > kind of known-stable release.
> 
> That does sound like a good idea.  It is nice finally getting to the 
> state where you can fuzz for hours (rather than minutes) without 
> hitting a bug.
> 
> Of course that might change.  Development of the fuzzer has more or 
> less stalled for the past 6 months as I was spending all of my time 
> reporting/chasing bugs rather than enhancing the fuzzer.
> 
> In any case if we can get the recent patches applied in time for 
> 3.15 I think it will turn out to be a nice release 
> perf-event-stability wise.

Yeah, I'm trying to get them all into v3.15 - and if they prove out 
fine they might be backportable further as well.

Thanks,

	Ingo
