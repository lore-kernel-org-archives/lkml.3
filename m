Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423740Ab3FUV2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:28:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25535 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423678Ab3FUV2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:28:13 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BUyC4VmaGVwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5V7bKCsQ6TsA:10 a=rxLUQMSaNUCQszBDhbMA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371850091.18733.136.camel@gandalf.local.home>
Subject: Re: [PATCH][GIT PULL] trace,x86: Move creation of irq tracepoints
 from apic.c to irq.c
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Fri, 21 Jun 2013 17:28:11 -0400
In-Reply-To: <51C4C215.2040705@linux.intel.com>
References: <1371835898.18733.122.camel@gandalf.local.home>
	 <1371848976.18733.130.camel@gandalf.local.home>
	 <51C4C215.2040705@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 14:13 -0700, H. Peter Anvin wrote:
> On 06/21/2013 02:09 PM, Steven Rostedt wrote:
> > Call Trace:
> >  [<ffffffff8103539d>] do_fork+0xa8/0x260
> >  [<ffffffff810ca7b1>] ? trace_preempt_on+0x2a/0x2f
> >  [<ffffffff812afb3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> 
> This bit of the call chain seems a little odd, no?

Doesn't the "?" mean its just in the stack but not part of the call
frame that was used. CONFIG_FRAME_POINTER is set in the config.

With lockdep and preempt tracing enabled, why would this seem strange?

-- Steve


