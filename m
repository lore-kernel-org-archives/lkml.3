Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967948Ab3HIPhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:37:55 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39401 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965056Ab3HIPhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:37:53 -0400
Date: Fri, 9 Aug 2013 17:37:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 3/7] nohz_full: Add per-CPU idle-state
 tracking
Message-ID: <20130809153747.GA13339@somewhere>
References: <20130726231848.GA12967@linux.vnet.ibm.com>
 <1374880764-14248-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1374880764-14248-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374880764-14248-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 04:19:20PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> This commit adds the code that updates the rcu_dyntick structure's
> new fields to track the per-CPU idle state based on interrupts and
> transitions into and out of the idle loop (NMIs are ignored because NMI
> handlers cannot cleanly read out the time anyway).  This code is similar
> to the code that maintains RCU's idea of per-CPU idleness, but differs
> in that RCU treats CPUs running in user mode as idle, where this new
> code does not.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
