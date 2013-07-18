Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab3GROjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 10:39:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab3GROjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 10:39:10 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=jG05uceuGy4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5uFaiv9cfuIA:10 a=dCrHwhn5Zh8xi4oE9DwA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374158349.6458.237.camel@gandalf.local.home>
Subject: Re: [PATCH 0/3] tracing: more list_empty(perf_events) checks
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Jul 2013 10:39:09 -0400
In-Reply-To: <20130718094237.GI27075@twins.programming.kicks-ass.net>
References: <20130617170142.GA19780@redhat.com>
	 <1374116446.6458.203.camel@gandalf.local.home>
	 <20130718094237.GI27075@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 11:42 +0200, Peter Zijlstra wrote:
> On Wed, Jul 17, 2013 at 11:00:46PM -0400, Steven Rostedt wrote:
> > Peter,
> > 
> > These have been discussed, and they mostly live in the tracing
> > directory, but are perf related. Can you give me your Acked-by on them.
> 
> I haven't looked in detail, but I trust Oleg. The only thing I can
> remember is that I objected to the changelogs in that it wasn't at all
> clear why we were doing these patches (Oleg did clarify in a separate
> email, not sure the changelogs were ammended).
> 
> Other than that sure, go ahead.

Oleg, did you update the change logs? These patches look the same as
what was in your mbox. Or did Peter have an issues with the change log
of another patch?

-- Steve


