Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3FFNug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:50:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5780 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3FFNuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:50:35 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ldwk5sxjx74A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=d1pqzc9q_nUA:10 a=VdziB3y0tXge-NwQwjsA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370526633.9844.33.camel@gandalf.local.home>
Subject: Re: [PATCH v2][RFC] tracing/context-tracking: Add
 preempt_schedule_context() for tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Thu, 06 Jun 2013 09:50:33 -0400
In-Reply-To: <20130606100752.GG8923@twins.programming.kicks-ass.net>
References: <1369943981.26799.43.camel@gandalf.local.home>
	 <20130531134319.GE5932@somewhere>
	 <1370013528.26799.49.camel@gandalf.local.home>
	 <20130531160101.GB5910@twins.programming.kicks-ass.net>
	 <1370050218.26799.87.camel@gandalf.local.home>
	 <20130604122712.GE14973@somewhere>
	 <1370355416.26799.119.camel@gandalf.local.home>
	 <20130605114559.GE8923@twins.programming.kicks-ass.net>
	 <1370439709.9844.17.camel@gandalf.local.home>
	 <1370486988.9844.24.camel@gandalf.local.home>
	 <20130606100752.GG8923@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-06 at 12:07 +0200, Peter Zijlstra wrote:

> > Are you OK with this?
> 
> Yep, applied.

Ah, so you'll take it. Great! I'll drop it from my queue.

Thanks,

-- Steve


