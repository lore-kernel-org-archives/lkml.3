Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbaD1XaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:30:24 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43991 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962AbaD1XaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:30:19 -0400
Date: Mon, 28 Apr 2014 16:30:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/3] Documentation changes for 3.16
Message-ID: <20140428233013.GA10816@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-0928-0000-0000-0000018CDBF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides a few documentation updates:

1.	Update sysfs patch for rcu_cpu_stall_suppress, courtesy of
	Kirill Tkhai.

2.	Add a rcu_dereference.txt file documenting the proper care
	and feeding of rcu_dereference() return values.

3.	Update the list of RCU API members in whatisRCU.txt.

							Thanx, Paul

------------------------------------------------------------------------

 00-INDEX            |    2 
 checklist.txt       |   12 +
 rcu_dereference.txt |  365 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 stallwarn.txt       |    2 
 whatisRCU.txt       |   55 ++++++-
 5 files changed, 420 insertions(+), 16 deletions(-)

