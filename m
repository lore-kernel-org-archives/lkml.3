Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbaGQNNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:13:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:18521 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757297AbaGQNNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:13:00 -0400
Date: Thu, 17 Jul 2014 09:12:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [patch V2 64/64] ftrace: Provide trace clocks monotonic
Message-ID: <20140717091255.486b5556@gandalf.local.home>
In-Reply-To: <20140717085535.782e1fc1@gandalf.local.home>
References: <20140716205018.175419210@linutronix.de>
	<20140716205057.643948282@linutronix.de>
	<20140717085535.782e1fc1@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014 08:55:35 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 16 Jul 2014 21:05:25 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
 
> I'm not sure I like the name "mono" because all the clocks listed are
> considered monolithic (with the view of tracing). What about calling it

Peter nicely informed me on IRC that I just confused monotonic with
monolithic. I think this is an improvement over my usual embarrassing
moments when I confuse the words generic with genetic.

-- Steve


> "user" as I believe this clock is the one that will be used to
> synchronize userspace times with the kernel. Right?
> 
> -- Steve
> 
> >  	ARCH_TRACE_CLOCKS
> >  };
> >  
> > 
> 

