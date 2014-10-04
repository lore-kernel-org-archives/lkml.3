Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaJDIwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 04:52:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59610 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaJDIwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 04:52:16 -0400
Date: Sat, 4 Oct 2014 01:50:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, dave@stgolabs.net
Subject: [GIT PULL rcu/next] Additional locktorture commits for 3.18
Message-ID: <20141004085003.GA17523@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100408-8236-0000-0000-000005E70590
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

A few additional commits for locktorture for 3.18.  These were posted
to LKML at https://lkml.org/lkml/2014/9/29/277 and have been exposed to
-next testing.

These changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

for you to fetch changes up to c98fed9fc6a7449affd941d8a8e9fcb0c72977d6:

  locktorture: Cleanup header usage (2014-09-30 00:10:02 -0700)

----------------------------------------------------------------
Davidlohr Bueso (4):
      locktorture: Support rwlocks
      locktorture: Fix __acquire annotation for spinlock irq
      locktorture: Cannot hold read and write lock
      locktorture: Cleanup header usage

 Documentation/locking/locktorture.txt              |   5 +
 kernel/locking/locktorture.c                       | 141 ++++++++++++++++++---
 .../selftests/rcutorture/configs/lock/CFLIST       |   1 +
 .../selftests/rcutorture/configs/lock/LOCK04       |   6 +
 .../selftests/rcutorture/configs/lock/LOCK04.boot  |   1 +
 5 files changed, 137 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK04
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK04.boot

