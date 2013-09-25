Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab3IYBRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:17:11 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44360 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507Ab3IYBRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:17:07 -0400
Date: Tue, 24 Sep 2013 18:16:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/3] Documentation updates for 3.13
Message-ID: <20130925011657.GA29958@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-9332-0000-0000-000001875378
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides a few documentation updates:

1.	Update stall-warning documentation to catch up with recent updates.

2.	Add a reference to the new vmstat-avoidance patch to the
	file describing how to quiet per-CPU kthreads.

3.	Fix a typo in Documentation/RCU/checklist.txt, courtesy of
	Michael Opdenacker.

							Thanx, Paul


 b/Documentation/RCU/checklist.txt           |    2 +-
 b/Documentation/RCU/stallwarn.txt           |   22 +++++++++++++++-------
 b/Documentation/kernel-per-CPU-kthreads.txt |   17 +++++++++++------
 3 files changed, 27 insertions(+), 14 deletions(-)

