Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaGGWon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:44:43 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53958 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaGGWol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:44:41 -0400
Date: Mon, 7 Jul 2014 15:44:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/3] Torture updates for 3.17
Message-ID: <20140707224434.GA9624@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-9332-0000-0000-0000014D74B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides torture-test updates:

1.	Enable old script versions without CFcommon files to operate
	correctly.

2.	Clean up diagnostics from --buildonly runs.

3.	Avoid format string leak to thead name, courtesy of Kees Cook.

							Thanx, Paul

------------------------------------------------------------------------

 b/kernel/torture.c                                         |    2 -
 b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh    |    8 ++++
 b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh |    9 ++++-
 b/tools/testing/selftests/rcutorture/bin/kvm.sh            |   21 +++++++------
 4 files changed, 27 insertions(+), 13 deletions(-)

