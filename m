Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab3DMS3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 14:29:09 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34758 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3DMS3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 14:29:07 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 13 Apr 2013 11:28:56 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 08/12] rcu: Remove the CONFIG_TINY_RCU
 ifdefs in rcutiny.h
Message-ID: <20130413182856.GB12096@leaf>
References: <20130412234810.GA23678@linux.vnet.ibm.com>
 <1365810511-24811-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1365810511-24811-8-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365810511-24811-8-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 04:48:27PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Now that CONFIG_TINY_PREEMPT_RCU is no more, this commit removes
> the CONFIG_TINY_RCU ifdefs from include/linux/rcutiny.h in favor of
> unconditionally compiling the CONFIG_TINY_RCU legs of those ifdefs.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

The #else branches of these ifdefs ought to disappear in the first patch
of the series, since they cover the CONFIG_TINY_PREEMPT_RCU case.

- Josh Triplett
