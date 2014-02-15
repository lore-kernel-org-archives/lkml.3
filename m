Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaBOKCC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:02:02 -0500
Received: from gate.crashing.org ([63.228.1.57]:34111 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbaBOKCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:02:00 -0500
Message-ID: <1392458479.10050.26.camel@pasglop>
Subject: Re: [PATCH 39/48] powerpc: Replace __get_cpu_var uses
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>
Date: Sat, 15 Feb 2014 21:01:19 +1100
In-Reply-To: <20140215094239.GF14089@laptop.programming.kicks-ass.net>
References: <20140214201841.826179349@linux.com>
	 <20140214201908.082769265@linux.com> <1392436208.10050.22.camel@pasglop>
	 <20140215094239.GF14089@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-15 at 10:42 +0100, Peter Zijlstra wrote:
> On Sat, Feb 15, 2014 at 02:50:08PM +1100, Benjamin Herrenschmidt wrote:
> > For some reason Im still getting these as attachments instead of inline
> > in the email, which makes reviewing a major PITA. Christoph, I'm not
> > sure what you are doing wrong here but you should consider fixing it :-)
> 
> Yeah, what the others have already said; evolution is a pile of steaming
> crap. Get yourself a real MUA :-)

I yet have to find one that isn't a steaming pile ... :-) Sadly I got
used to evo and transferring all my filters etc... to another one is
something I'm really not looking fwd to, though I suppose it will have
to happen sooner or later.

Plus dwmw2 keeps convincing me that evo doesn't suck as much as I think
it does :-)

Cheers,
Ben.

> For some reason it does absurd things with "Content-Disposition:
> inline".
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


