Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3IIRqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:46:15 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38069 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3IIRqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:46:12 -0400
Date: Mon, 9 Sep 2013 10:45:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909174542.GE3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130909085504.2ddd7e69@gandalf.local.home>
 <20130909130851.GC16280@somewhere>
 <20130909092142.05780991@gandalf.local.home>
 <20130909134505.GF16280@somewhere>
 <20130909135656.GT3966@linux.vnet.ibm.com>
 <20130909101629.32df27a2@gandalf.local.home>
 <20130909161708.GX3966@linux.vnet.ibm.com>
 <20130909123422.7936e868@gandalf.local.home>
 <20130909165836.GB3966@linux.vnet.ibm.com>
 <20130909130605.29ee8fd6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909130605.29ee8fd6@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090917-7164-0000-0000-0000017B742D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 01:06:05PM -0400, Steven Rostedt wrote:
> On Mon, 9 Sep 2013 09:58:36 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> 
> > > "rcu_is_ignored()" or "rcu_is_not_active()", "rcu_is_watching_you()"
> > 
> > You know, I am strongly tempted by "rcu_is_watching_you()", but I have
> > this feeling that it is too cute for its own good.  ;-)
> 
> Sign of the times...
> 
> s/c/S/
> s/r/N/
> s/u/A/

;-) ;-) ;-)

							Thanx, Paul

