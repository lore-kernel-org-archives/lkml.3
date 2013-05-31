Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab3EaQL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:11:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3EaQLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:11:50 -0400
X-Authority-Analysis: v=2.0 cv=H9pZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=FEvprJy6j1wA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=U_bRVmVwb2QA:10 a=Y-ojLGJI-O_UCMMDQ8gA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370016709.26799.50.camel@gandalf.local.home>
Subject: Re: [PATCH][RFC] tracing/context-tracking: Add
 preempt_schedule_context() for tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 31 May 2013 12:11:49 -0400
In-Reply-To: <20130531160101.GB5910@twins.programming.kicks-ass.net>
References: <1369943981.26799.43.camel@gandalf.local.home>
	 <20130531134319.GE5932@somewhere>
	 <1370013528.26799.49.camel@gandalf.local.home>
	 <20130531160101.GB5910@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-31 at 18:01 +0200, Peter Zijlstra wrote:
> On Fri, May 31, 2013 at 11:18:48AM -0400, Steven Rostedt wrote:
> > I'll rewrite the patch and send it out for another review.
> 
> This is the only part I read in detail and marked the thread read!
> 
> Awaiting v2 :-)

Yeah, it would be a quick send, but I'm running a test that seems to be
hitting every bug currently in the kernel :-p

-- Steve


