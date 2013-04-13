Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab3DMACI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 20:02:08 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49833 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3DMACH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 20:02:07 -0400
X-Originating-IP: 173.246.103.110
Date: Fri, 12 Apr 2013 17:01:46 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, sasha.levin@oracle.com,
        paul.gortmaker@windriver.com, paulus@au1.ibm.com
Subject: Re: [PATCH tip/core/rcu 0/7] RCU fixes for 3.11
Message-ID: <20130413000146.GB8140@jtriplet-mobl1>
References: <20130412231846.GA20038@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412231846.GA20038@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 04:18:47PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series contains the following fixes for RCU:
> 
> 1-2.	Convert remaining printk() calls to pr_*().
> 
> 3.	Kick adaptive-ticks CPUs that are holding up RCU grace periods.
> 
> 4.	Don't allocate bootmem from rcu_init(), courtesy of Sasha Levin.
> 
> 5.	Remove "Experimental" flags from old RCU Kconfig options.
> 
> 6.	Automatically tune defaults for delays between attempts to
> 	force quiescent states.
> 
> 7.	Merge adjacent identical #ifdefs.

For 1-5 and 7:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Responded to 6 separately.

- Josh Triplett
