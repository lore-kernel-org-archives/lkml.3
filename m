Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaGIPkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:40:43 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46278 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaGIPkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:40:41 -0400
Date: Wed, 9 Jul 2014 17:40:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 11/17] rcu: Bind grace-period kthreads to
 non-NO_HZ_FULL CPUs
Message-ID: <20140709154033.GA23881@localhost.localdomain>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772701-8804-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140708152358.GF6571@localhost.localdomain>
 <20140708154723.GN4603@linux.vnet.ibm.com>
 <20140708183846.GJ6571@localhost.localdomain>
 <20140708195837.GS4603@linux.vnet.ibm.com>
 <20140708204008.GA10513@localhost.localdomain>
 <20140708220556.GB4603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708220556.GB4603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 03:05:56PM -0700, Paul E. McKenney wrote:
> Fair point.  This would be a kthread_bind_housekeeping(), then.

Hmm, after all this should only be needed for kthreads so yeah.

> But I need to create an kthread_bind_mask() or some such that acts like
> kthread_bind(), but which takes a cpumask rather than a cpu.  Easy
> enough to do, but sounds like 3.18 material rather than 3.17 material.
> So this is on my 3.18 list.

Ok sounds good.

Thanks!
 
> 							Thanx, Paul
> 
