Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3HZTDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 15:03:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4987 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3HZTDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 15:03:08 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=4YNYSHFQjk8A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jyE81Idm5WYA:10 a=20KFwNOVAAAA:8 a=8Q5PjHOKA_jmC8kFctUA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 26 Aug 2013 15:03:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: suspicious RCU usage (perf)
Message-ID: <20130826150304.090a1025@gandalf.local.home>
In-Reply-To: <20130826182907.GB25202@redhat.com>
References: <20130826145838.GA8377@redhat.com>
	<20130826162928.GQ3871@linux.vnet.ibm.com>
	<20130826133041.3d750b1b@gandalf.local.home>
	<20130826175012.GA25202@redhat.com>
	<20130826141814.54dcaa89@gandalf.local.home>
	<20130826182907.GB25202@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013 14:29:07 -0400
Dave Jones <davej@redhat.com> wrote:

> On Mon, Aug 26, 2013 at 02:18:14PM -0400, Steven Rostedt wrote:
>  > On Mon, 26 Aug 2013 13:50:12 -0400
>  > Dave Jones <davej@redhat.com> wrote:
>  > > 
>  > > This was triggered as a regular user fwiw.
>  > > I had not been running perf, or any other tracing. It was just left
>  > > fuzzing over the weekend with no interaction at all.
>  > 
>  > So you are telling me that ftrace was enabled by a regular user? If so,
>  > that's a huge issue.
>  
> quite.
> 
>  > So my question to you. If you were not running perf or any other
>  > tracing, and this is all just non-root user. How the hell did perf
>  > function tracing get started on your box????
> 
> What mechanisms are available that would trigger it being enabled ?
> 
> Is there some path through sys_perf_open_event that might be
> missing a capability check perhaps ?
> 

That's a question for Ingo, Peter or Jiri.

-- Steve
