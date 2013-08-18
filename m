Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3HRCZD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:25:03 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57355 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3HRCZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:25:01 -0400
Date: Sat, 17 Aug 2013 19:24:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/5] rcutorture updates for 3.12
Message-ID: <20130818022453.GA3475@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081802-1542-0000-0000-0000009B50E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides some rcutorture updates:

1.	Add a debug_object option to rcutorture to allow testing
	of RCU's debug-objects facilities.

2.	Increase rcutorture test coverage by concurrently testing
	synchronous, asynchronous, and expedited grace periods.

3.	Sort the extensive list of rcutorture module parameters.

4.	Remove the unused "oldbatch" variable.

5.	Emit CPU-online failure message to the console.

							Thanx, Paul


 b/Documentation/RCU/torture.txt |   10 +
 b/kernel/rcutorture.c           |  341 ++++++++++++++++------------------------
 2 files changed, 151 insertions(+), 200 deletions(-)

