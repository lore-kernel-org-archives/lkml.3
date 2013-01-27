Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3A0K6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 05:58:53 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:54070 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab3A0K6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 05:58:52 -0500
X-Originating-IP: 217.70.178.135
X-Originating-IP: 150.203.246.47
Date: Sun, 27 Jan 2013 21:58:40 +1100
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/2] v2 Tiny RCU changes for 3.9
Message-ID: <20130127105840.GF3119@leaf>
References: <20130127002328.GA4847@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130127002328.GA4847@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 04:23:28PM -0800, Paul E. McKenney wrote:
> Hello!
> 
> This series provides a couple of tiny-RCU changes:
> 
> 1.	Make Tiny RCU emit RCU CPU stall warnings when RCU_TRACE=y.
> 2.	Allow TREE_PREEMPT_RCU to be used on UP systems.

I replied to patch 1 with a suggestion; with that change,
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
for the whole series.

- Josh Triplett
