Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3CRUzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:55:00 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56568 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3CRUy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:54:59 -0400
Date: Mon, 18 Mar 2013 13:54:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/2] Documentation changes for 3.9
Message-ID: <20130318205449.GA14393@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031820-5518-0000-0000-00000CA809A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains the following changes to RCU documentation:

1.	Make the bugginess of a code sample more apparent with
	all-caps comments.

2.	RCU documentation update based on review motivated by the
	first commit.

							Thanx, Paul


 b/Documentation/RCU/checklist.txt  |   26 ++++++++++++++++----------
 b/Documentation/RCU/lockdep.txt    |    5 +++++
 b/Documentation/RCU/rcubarrier.txt |   15 ++++++++++++++-
 b/Documentation/RCU/whatisRCU.txt  |    4 ++--
 4 files changed, 37 insertions(+), 13 deletions(-)

