Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaETRUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:20:41 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42328 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaETRUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:20:39 -0400
Date: Tue, 20 May 2014 10:20:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
Message-ID: <20140520172033.GE4570@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520162433.GE17741@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052017-8236-0000-0000-00000277861E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 06:24:36PM +0200, Frederic Weisbecker wrote:
> On Tue, May 20, 2014 at 08:53:24AM -0700, Paul E. McKenney wrote:
> > On Tue, May 20, 2014 at 04:53:52PM +0200, Frederic Weisbecker wrote:

[ . . . ]

> > > We'll probably extend it that way in the future. But likely not in a near future.
> > 
> > My guess is that Mike would be OK with making nohz_full choice of CPUs
> > still at boot time, but that he would like the CPUs that are not to be
> > in nohz_full state be able to opt out of the context-tracking overhead.
> 
> Ok that might be possible. Although still require a bit of complication.
> Lets wait for Mike input.

Sounds good!

Mike, would this do what you need?

							Thanx, Paul

