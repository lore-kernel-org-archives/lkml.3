Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbaBTRqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:46:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:6399 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754932AbaBTRqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:46:14 -0500
Date: Thu, 20 Feb 2014 12:46:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: x86_pmu_start WARN_ON.
Message-ID: <20140220124612.3a387673@gandalf.local.home>
In-Reply-To: <20140220124351.7f920c08@gandalf.local.home>
References: <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
	<20140217152859.GF15586@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
	<20140219101949.GG15586@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
	<20140220100830.GN6835@laptop.programming.kicks-ass.net>
	<20140220112600.2f44874d@gandalf.local.home>
	<20140220170018.GJ9987@twins.programming.kicks-ass.net>
	<20140220124351.7f920c08@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 12:43:51 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> As a disable_trace_on_warning is more of a modification to the kernel,
> I'm leaning to adding a /proc/sys/kernel/ftrace_disable_on_warning
> file. This keeps it in line with ftrace_dump_on_oops, which is the most
> similar feature.

Nevermind. There's a "traceoff_on_warning" already there that does
exactly this :-/

-- Steve

