Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab3A0FQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 00:16:18 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51291 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3A0FQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 00:16:05 -0500
Date: Sat, 26 Jan 2013 16:23:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/2] v2 Tiny RCU changes for 3.9
Message-ID: <20130127002328.GA4847@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012705-5518-0000-0000-00000B0BCA16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides a couple of tiny-RCU changes:

1.	Make Tiny RCU emit RCU CPU stall warnings when RCU_TRACE=y.
2.	Allow TREE_PREEMPT_RCU to be used on UP systems.

Changes since v1:

o	Updated #1 as suggested by Josh Triplett to simplify the
	#if expressions.
o	Added #2.

							Thanx, Paul


 b/init/Kconfig            |   12 +++++++++
 b/kernel/rcu.h            |    7 +++++
 b/kernel/rcupdate.c       |   51 +++++++++++++++++++++++++++++++++++++++++
 b/kernel/rcutiny.c        |    6 +++-
 b/kernel/rcutiny_plugin.h |   56 ++++++++++++++++++++++++++++++++++++++++++++++
 b/kernel/rcutree.c        |   46 ++-----------------------------------
 b/kernel/rcutree.h        |    5 ----
 b/lib/Kconfig.debug       |    2 -
 8 files changed, 133 insertions(+), 52 deletions(-)

