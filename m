Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3KPAKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:10:19 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:42849 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab3KPAKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:10:11 -0500
Date: Fri, 15 Nov 2013 16:10:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/4] Documentation changes for 3.14
Message-ID: <20131116001005.GA28191@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-9332-0000-0000-0000022BB696
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains documentation updates:

1.	Fix a typo in Documentation/RCU/trace.txt.

2.	Fix formatting blows in kernel-parameters.txt.

3.	Fix memory barrier usage in the circular-buffer example.

4.	Replace some memory barriers in the circular-buffer example
	with load-acquire and store-release to reduce memory-barrier
	overhead while still keeping things safe.

							Thanx, Paul

 b/Documentation/RCU/trace.txt         |    2 -
 b/Documentation/circular-buffers.txt  |   57 +++++++++++++++++++---------------
 b/Documentation/kernel-parameters.txt |    9 ++---
 3 files changed, 37 insertions(+), 31 deletions(-)

