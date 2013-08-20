Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab3HTCux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:50:53 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58731 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3HTCuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:50:52 -0400
Date: Mon, 19 Aug 2013 19:50:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/5] v2 rcutorture updates for 3.12
Message-ID: <20130820025046.GA32071@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-4834-0000-0000-00000A50FC0F
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

Changes since v1 (https://lkml.org/lkml/2013/8/17/118):

o	Interleave variable and corresponding module-parameter
	declarations, as suggested by Josh Triplett.

o	Fix comparison to zero and in-function #ifdef, again as
	suggested by Josh Triplett.

							Thanx, Paul


 b/Documentation/RCU/torture.txt |   10 +
 b/kernel/rcutorture.c           |  382 +++++++++++++++++-----------------------
 2 files changed, 174 insertions(+), 218 deletions(-)

