Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaJ1WDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:03:32 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45505 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaJ1WDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:03:31 -0400
Date: Tue, 28 Oct 2014 14:59:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/5] Documentation updates for 3.19
Message-ID: <20141028215937.GA25095@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0033-0000-0000-000000E3F155
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains a few documentation updates:

1.	Records limitations of bitfields and small variables.
	Also rules out pre-EV56 Alpha, which lack 8- and 16-bit
	memory-reference instructions.  Later Alpha CPUs are OK.
	(The official Alpha maintainers have thus far been silent
	on this patch.)

2.	Document the new RCU self-test boot parameters, courtesy of
	Pranith Kumar.

3.	Records that short-circuit boolean evaluation does not necessarily
	defend against control-dependency breakage by compiler optimizations.

4.	Add mention of atomic_long_t to atomic_ops.txt.

5.	Fix an example in memory-barriers.txt, courtesy of Pranith Kumar.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/atomic_ops.txt        |   12 +++--
 b/Documentation/kernel-parameters.txt |    9 ++++
 b/Documentation/memory-barriers.txt   |   71 ++++++++++++++++++++++++++++------
 3 files changed, 77 insertions(+), 15 deletions(-)

