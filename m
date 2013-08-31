Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab3HaUyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:54:25 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:44227 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3HaUyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:54:24 -0400
Date: Sat, 31 Aug 2013 13:54:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 15/18 v2] ftrace/rcu: Mark functions that are RCU
 unsafe
Message-ID: <20130831205409.GA3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051702.922659300@goodmis.org>
 <20130831200044.GU3871@linux.vnet.ibm.com>
 <1377981804.26624.7.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377981804.26624.7.camel@pippen.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083120-7606-0000-0000-00000EC1BAE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 04:43:24PM -0400, Steven Rostedt wrote:
> On Sat, 2013-08-31 at 13:00 -0700, Paul E. McKenney wrote:
> > On Sat, Aug 31, 2013 at 01:11:32AM -0400, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > 
> > > Some callbacks of the function tracer use rcu_read_lock(). This means that
> > > there's places that can not be traced because RCU is not tracking the CPU
> > > for various reasons (like NO_HZ_FULL and coming back from userspace).
> > > 
> > > Thes functions need to be marked so that callbacks that use RCU do not
> > > trace them.
> > > 
> > > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Please let me know if you would like me to take this one.  If I don't
> > hear otherwise, I will assume that you are pushing it.
> > 
> 
> These I rather take, as they are all dependent on the previous changes.

Good point, applies to the other one we discussed as well.

							Thanx, Paul

