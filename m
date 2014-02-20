Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaBTTEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:04:35 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32023 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754166AbaBTTEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:04:34 -0500
Date: Thu, 20 Feb 2014 14:04:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Vince Weaver <vincent.weaver@maine.edu>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: x86_pmu_start WARN_ON.
Message-ID: <20140220140426.6d17001c@gandalf.local.home>
In-Reply-To: <20140220181538.GK9987@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
	<20140217152859.GF15586@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
	<20140219101949.GG15586@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
	<20140220100830.GN6835@laptop.programming.kicks-ass.net>
	<87r46xdbw4.fsf@tassilo.jf.intel.com>
	<20140220155416.GH9987@twins.programming.kicks-ass.net>
	<87mwhld72w.fsf@tassilo.jf.intel.com>
	<20140220181538.GK9987@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 19:15:38 +0100
Peter Zijlstra <peterz@infradead.org> wrote:


> I think by using the /debug/tracing/events/ftrace/function event, but
> I'm not actually sure, I've never used it nor did I write the code to do
> it. Jolsa did all that IIRC.
> 
> All I know is that we had some 'fun' bugs around there sometime back.

Note, the function tracer now has a lot better recursion protection than
it use to.

-- Steve
