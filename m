Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3CRNSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:18:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27869 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab3CRNSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:18:53 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=l-zTcuvMFTkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=An5aTDfC5mAA:10 a=NDGl0WlkeQbOB3fslLkA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363612730.25967.138.camel@gandalf.local.home>
Subject: Re: [for-next][PATCH 9/9] tracing: Update debugfs README file
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Date: Mon, 18 Mar 2013 09:18:50 -0400
In-Reply-To: <87hak9jewo.fsf@sejong.aot.lge.com>
References: <20130316032412.416651612@goodmis.org>
	 <20130316033143.744766877@goodmis.org> <87hak9jewo.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 17:22 +0900, Namhyung Kim wrote:

> > +	"             example: echo do_fault:traceoff > set_ftrace_filter\n"
> > +	"                      echo do_trap:traceoff:3 > set_ftrace_filter\n"
> > +	"             The first one will disable tracing everytime do_fault is hit\n"
> > +	"             The second will disable tracing at most 3 times whne do_trap is hit\n"
> 
> s/whne/when/
> 
> It's slightly confusing for me to read the "at most" part.  Did you mean
> it by "The second will disable tracing after do_trace is hit 3 times"?

Yeah, I wrote this on little sleep. I'll revise it a little. Thanks!

-- Steve


> 
> > +	"             To remove trigger without count:\n"
> > +	"               echo '!<function>:<trigger> > set_ftrace_filter\n"
> > +	"             To remove trigger with a count:\n"
> > +	"               echo '!<function>:<trigger>:0 > set_ftrace_filter\n"
> > +	"  set_ftrace_notrace\t- echo function name in here to never trace.\n"
> > +	"            accepts: func_full_name, *func_end, func_begin*, *func_middle*\n"
> > +	"            modules: Can select a group via module command :mod:\n"
> > +	"            Does not accept triggers\n"
> > +#endif /* CONFIG_DYNAMIC_FTRACE */


