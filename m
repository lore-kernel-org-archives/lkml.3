Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaBOPpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 10:45:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37359 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaBOPpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 10:45:17 -0500
Date: Sat, 15 Feb 2014 16:45:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 39/48] powerpc: Replace __get_cpu_var uses
Message-ID: <20140215154502.GK14089@laptop.programming.kicks-ass.net>
References: <20140214201841.826179349@linux.com>
 <20140214201908.082769265@linux.com>
 <1392436208.10050.22.camel@pasglop>
 <20140215094239.GF14089@laptop.programming.kicks-ass.net>
 <1392458479.10050.26.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392458479.10050.26.camel@pasglop>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 09:01:19PM +1100, Benjamin Herrenschmidt wrote:
> On Sat, 2014-02-15 at 10:42 +0100, Peter Zijlstra wrote:
> > On Sat, Feb 15, 2014 at 02:50:08PM +1100, Benjamin Herrenschmidt wrote:
> > > For some reason Im still getting these as attachments instead of inline
> > > in the email, which makes reviewing a major PITA. Christoph, I'm not
> > > sure what you are doing wrong here but you should consider fixing it :-)
> > 
> > Yeah, what the others have already said; evolution is a pile of steaming
> > crap. Get yourself a real MUA :-)
> 
> I yet have to find one that isn't a steaming pile ... :-) Sadly I got
> used to evo and transferring all my filters etc... to another one is
> something I'm really not looking fwd to, though I suppose it will have
> to happen sooner or later.
> 
> Plus dwmw2 keeps convincing me that evo doesn't suck as much as I think
> it does :-)

There's a good solution there; make dwmw2 fix it ;-)

David; in particular; quilt mail adds "Content-Disposition: inline"
headers and Evo, in its infinite wisdom, makes the entire body into an
attachment.

