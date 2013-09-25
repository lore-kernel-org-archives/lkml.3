Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750826Ab3IYEIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 00:08:24 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48776 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3IYEIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 00:08:23 -0400
X-Originating-IP: 50.43.39.152
Date: Tue, 24 Sep 2013 21:08:10 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/6] Idle entry/exit changes for 3.13
Message-ID: <20130925040809.GD2016@leaf>
References: <20130925014954.GA32109@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925014954.GA32109@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 06:49:55PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series updates RCU's idle entry/exit processing:
> 
> 1.	Remove redundant code from rcu_cleanup_after_idle().
> 
> 2.	Throttle rcu_try_advance_all_cbs() execution to avoid kbuild
> 	slowdowns.
> 
> 3.	Throttle non-lazy-callback-induced invoke_rcu_core() invocations.
> 
> 4.	Add primitive to determine whether it is safe to enter an RCU
> 	read-side critical section.
> 
> 5.	Upgrade EXPORT_SYMBOL() to EXPORT_SYMBOL_GPL().
> 
> 6.	Change rcu_is_cpu_idle() function to __rcu_is_watching() for
> 	naming consistency.

For all six:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
