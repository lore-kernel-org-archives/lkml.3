Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaEUE3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:29:55 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:65431 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaEUE3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:29:53 -0400
Message-ID: <1400646590.5158.43.camel@marge.simpson.net>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 21 May 2014 06:29:50 +0200
In-Reply-To: <20140520172033.GE4570@linux.vnet.ibm.com>
References: <1400123931.5175.38.camel@marge.simpson.net>
	 <1400386954.5140.36.camel@marge.simpson.net>
	 <20140518052039.GF4570@linux.vnet.ibm.com>
	 <1400402201.5166.13.camel@marge.simpson.net>
	 <20140518155815.GK4570@linux.vnet.ibm.com>
	 <1400467481.5211.48.camel@marge.simpson.net>
	 <20140519053401.GP4570@linux.vnet.ibm.com>
	 <20140520145350.GC17741@localhost.localdomain>
	 <20140520155324.GD4570@linux.vnet.ibm.com>
	 <20140520162433.GE17741@localhost.localdomain>
	 <20140520172033.GE4570@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 10:20 -0700, Paul E. McKenney wrote: 
> On Tue, May 20, 2014 at 06:24:36PM +0200, Frederic Weisbecker wrote:
> > On Tue, May 20, 2014 at 08:53:24AM -0700, Paul E. McKenney wrote:
> > > On Tue, May 20, 2014 at 04:53:52PM +0200, Frederic Weisbecker wrote:
> 
> [ . . . ]
> 
> > > > We'll probably extend it that way in the future. But likely not in a near future.
> > > 
> > > My guess is that Mike would be OK with making nohz_full choice of CPUs
> > > still at boot time, but that he would like the CPUs that are not to be
> > > in nohz_full state be able to opt out of the context-tracking overhead.
> > 
> > Ok that might be possible. Although still require a bit of complication.
> > Lets wait for Mike input.
> 
> Sounds good!
> 
> Mike, would this do what you need?

I don't _have_ a here and now need at all, I'm just looking at the
possibilities.  For the users I'm aware of here and now, I'm pretty sure
they'd be tickled pink with it as it sits ('course tickled pink will
quickly become "I see a 1.073us perturbation once every three weeks").

-Mike 

