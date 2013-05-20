Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab3ETOtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:49:49 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35107 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab3ETOtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:49:46 -0400
Date: Mon, 20 May 2013 07:49:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/2] Documentation changes for 3.11
Message-ID: <20130520144934.GA29947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-5518-0000-0000-00000ED06D3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

A pair of documentation changes.  These are not directly related to RCU,
but if no one adopts them, I will send them up with the RCU commits.  The
patches are as follows:

1.	Changes to the new Documentation/timers/NO_HZ.txt documentation
	based on review comments from Sedat Dilek.

2.	Document ways of turning off the scheduling-clock tick even when
	there is more than one runnable task on a given CPU.

3.	Document ways of avoiding OS jitter form the kworker workqueue
	kthreads.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/kernel-per-CPU-kthreads.txt |   47 ++++++++++++++++
 b/Documentation/timers/NO_HZ.txt            |   79 +++++++++++++++++++++++-----
 2 files changed, 114 insertions(+), 12 deletions(-)

