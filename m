Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab3GRPxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:53:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28218 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758938Ab3GRPx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:53:29 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=jG05uceuGy4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5uFaiv9cfuIA:10 a=tpLrBSJAl-Xw7xiVS6wA:9 a=QEXdDO2ut3YA:10 a=kp8wrOdlnIwA:10 a=jtmJLpwgqYwA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374162806.6458.238.camel@gandalf.local.home>
Subject: Re: [PATCH 0/3] tracing: more list_empty(perf_events) checks
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Jul 2013 11:53:26 -0400
In-Reply-To: <20130718154403.GA8416@redhat.com>
References: <20130617170142.GA19780@redhat.com>
	 <1374116446.6458.203.camel@gandalf.local.home>
	 <20130718094237.GI27075@twins.programming.kicks-ass.net>
	 <1374158349.6458.237.camel@gandalf.local.home>
	 <20130718154403.GA8416@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 17:44 +0200, Oleg Nesterov wrote:

> Steven, I am starting to think that it would be better to resend this
> series (3-6 in mbox I sent) so that Peter and Frederic can take another
> look. And I'll try to update the changelogs. Will do a bit later today.

Or do you mean 4-6? As I applied 1-3 already, and added Peter's
Acked-by.

I'm guessing 1-3's change logs were good enough.

-- Steve


