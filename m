Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3HaUbY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:31:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15696 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3HaUbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:31:23 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=ScsRa3LQXiAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=oRCXbKhWxsoA:10 a=VnNF1IyMAAAA:8 a=xa5-QLw5uhaX3KhGc6EA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Subject: Re: [RFC][PATCH 08/18 v2] ftrace/rcu: Do not trace
 debug_lockdep_rcu_enabled()
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
In-Reply-To: <20130831192101.GG3871@linux.vnet.ibm.com>
References: <20130831051117.884125230@goodmis.org>
	 <20130831051701.767976027@goodmis.org>
	 <20130831192101.GG3871@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Aug 2013 16:31:14 -0400
Message-ID: <1377981074.26624.0.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-31 at 12:21 -0700, Paul E. McKenney wrote:
> On Sat, Aug 31, 2013 at 01:11:25AM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > The function debug_lockdep_rcu_enabled() is part of the RCU lockdep
> > debugging, and is called very frequently. I found that if I enable
> > a lot of debugging and run the function graph tracer, this
> > function can cause a live lock of the system.
> > 
> > We don't usually trace lockdep infrastructure, no need to trace
> > this either.
> > 
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Or I can just take it, if you would rather.  (If so, 3.12 or 3.13?)
> 

Feel free to take it and I'll remove it from my queue. 3.12 please.

I'll just need to remember to turn off function graph tracing when
testing these patches again.

-- Steve


