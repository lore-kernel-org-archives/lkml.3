Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaGGWXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:23:53 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49349 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaGGWXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:23:51 -0400
Date: Mon, 7 Jul 2014 15:23:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/4] Documentation changes for 3.17
Message-ID: <20140707222345.GA6320@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-9332-0000-0000-0000014D6C69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides a few documentation updates:

1.	Clarify that if there is nothing awakened, then there is no
	memory barrier.

2.	Fix broken RTFP URL, courtesy of Pranith Kumar.

3.	Add acquire/release barrier to memory-barrier pairing rules.

4.	Add pointer to percpu-ref in rcuref.txt documentation.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/RCU/RTFP.txt        |    4 ++--
 b/Documentation/RCU/rcuref.txt      |    9 +++++++++
 b/Documentation/memory-barriers.txt |   25 +++++++++++++++++++++----
 3 files changed, 32 insertions(+), 6 deletions(-)

