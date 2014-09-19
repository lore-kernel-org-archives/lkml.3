Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbaISPyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:54:23 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42296 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbaISPyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:54:22 -0400
Date: Fri, 19 Sep 2014 08:54:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu 0/17] RCU-tasks implementation for 3.18
Message-ID: <20140919155413.GC4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140828191929.GA31795@linux.vnet.ibm.com>
 <20140918222246.GD2832@worktop.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918222246.GD2832@worktop.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091915-7164-0000-0000-000004BD8C6C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 12:22:46AM +0200, Peter Zijlstra wrote:
> 
> Looks ok I suppose, Thanks for the last two patches. I started one that
> moved the local_irq_disable() around, but this is nicer.

Glad you like them!  ;-)

Longer term, I am thinking in terms of building on your earlier idle-loop
patches to make RCU-tasks handle idle tasks in a nice way.

And I do have a commit queued to reduce the idle wakeups caused by
synchronize_sched_expedited(), hopefully for 3.19.

							Thanx, Paul

