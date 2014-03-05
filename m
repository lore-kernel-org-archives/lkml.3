Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaCEAAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:00:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:32695 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753625AbaCEAAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:00:11 -0500
Date: Tue, 4 Mar 2014 19:00:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Closing on the CR2 leak bug
Message-ID: <20140304190005.4b273410@gandalf.local.home>
In-Reply-To: <5316655A.9060102@zytor.com>
References: <531654D8.5040409@zytor.com>
	<20140304184112.0a3fe811@gandalf.local.home>
	<5316655A.9060102@zytor.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Mar 2014 15:44:26 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 03/04/2014 03:41 PM, Steven Rostedt wrote:
> > 
> > The only other issue is if perf traces from function context and traces
> > the trace_do_page_fault() call. But other than that, sure, take Jiri's
> > patch.
> > 
> 
> Is there a known codepath on which that can happen?

I'm not sure. Jiri, is there a way we can trace userspace from
the ftrace function event? What would be the command to try? I know you
had a patch to prevent it, but is it currently possible?

-- Steve
