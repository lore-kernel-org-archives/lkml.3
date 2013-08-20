Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab3HTCh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:37:27 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42216 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab3HTChZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:37:25 -0400
Date: Mon, 19 Aug 2013 19:37:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/3] v2 Documentation updates for 3.12
Message-ID: <20130820023717.GA29357@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-5806-0000-0000-0000227AC918
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides a few documentation updates:

1.	Update rcu_barrier() documentation to note that it no longer is
	guaranteed to wait for a full grace period.  This guarantee was
	a victim of energy efficiency.

2.	Update RTFP documentation.

3.	Fix a control-dependency example in the memory-barriers
	documentation.

Changes from v1 (https://lkml.org/lkml/2013/8/17/94):

o	Apply Josh Triplett review comments.

							Thanx, Paul


 b/Documentation/RCU/RTFP.txt        |  858 +++++++++++++++++++++++-------------
 b/Documentation/RCU/rcubarrier.txt  |   12 
 b/Documentation/memory-barriers.txt |   10 
 3 files changed, 567 insertions(+), 313 deletions(-)

