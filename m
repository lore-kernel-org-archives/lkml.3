Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaEFRCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:02:41 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:63837 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaEFRCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:02:38 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 6 May 2014 13:06:20 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1405060041140.1436@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405061305210.3372@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405021230130.22556@vincent-weaver-1.umelst.maine.edu> <20140502172731.GK30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu>
 <20140505093124.GN17778@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu> <20140505172951.GB7154@gmail.com> <alpine.DEB.2.10.1405060041140.1436@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014, Vince Weaver wrote:

> In any case if we can get the recent patches applied in time for 3.15 I 
> think it will turn out to be a nice release perf-event-stability wise.

I should also mention I have a list of open perf_fuzzer issues here:
	http://web.eece.maine.edu/~vweaver/projects/perf_events/fuzzer/bugs_found.html

It's not organized well but it's how I keep track of the various issues 
after I find and report them.

Vince
