Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbbAGRKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:10:00 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:37185 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbbAGRJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:09:59 -0500
Date: Wed, 7 Jan 2015 09:09:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/3] Documentation updates for 3.20
Message-ID: <20150107170950.GA30629@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0025-0000-0000-0000079193D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains a few documentation updates:

1.	Updates the sysfs path for rcu_cpu_stall_timeout, courtesy of
	Xie XiuQi.

2.	Records limitations of bitfields and small variables, noting
	among other things that safe concurrent update to adjacent
	non-bitfield scalar variables is required by the C11 standard.

3.	Fix typo in memory-barriers.txt, courtesy of Davidlohr Bueso.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/RCU/stallwarn.txt   |    2 -
 b/Documentation/memory-barriers.txt |   46 +++++++++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 2 deletions(-)

