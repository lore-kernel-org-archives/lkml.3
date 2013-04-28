Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3D1ABk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 20:01:40 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36891 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3D1ABj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 20:01:39 -0400
Date: Sat, 27 Apr 2013 17:01:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        bp@alien8.de, arjan@linux.intel.com, khilman@linaro.org, cl@linux.com,
        peterz@infradead.org, tglx@linutronix.de, olivier.baetz@novasparks.com,
        rdunlap@infradead.org, bp@suse.de
Subject: [GIT PULL tip/timers/nohz] Documentation for adaptive ticks
Message-ID: <20130428000130.GA19985@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042800-3620-0000-0000-000002390F3A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This change adds documentation for CONFIG_NO_HZ_IDLE and CONFIG_NO_HZ_FULL.
It is available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/nohz

for you to fetch changes up to 0c87f9b5ca5bdda1a868b0d7df4bec92e41a468d:

  nohz_full: Add documentation. (2013-04-27 16:41:43 -0700)

							Thanx, Paul

----------------------------------------------------------------
Paul E. McKenney (1):
      nohz_full: Add documentation.

 Documentation/timers/NO_HZ.txt | 273 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 273 insertions(+)
 create mode 100644 Documentation/timers/NO_HZ.txt

