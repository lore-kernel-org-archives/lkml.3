Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3D1AXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 20:23:15 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58439 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab3D1AXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 20:23:14 -0400
Date: Sat, 27 Apr 2013 17:05:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        bp@alien8.de, arjan@linux.intel.com, khilman@linaro.org, cl@linux.com,
        tglx@linutronix.de, olivier.baetz@novasparks.com,
        rdunlap@infradead.org, bp@suse.de
Subject: [GIT PULL rcu/doc] Reducing OS jitter from per-CPU kthreads
Message-ID: <20130428000500.GA20113@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042800-7606-0000-0000-00000ADE4221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This series includes documentation for reducing OS jitter due to
per-CPU kthreads.  It is available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/doc

for you to fetch changes up to 49717cb40410fe4b563968680ff7c513967504c6:

  kthread: Document ways of reducing OS jitter due to per-CPU kthreads (2013-04-27 16:52:47 -0700)

							Thanx, Paul

----------------------------------------------------------------
Paul E. McKenney (1):
      kthread: Document ways of reducing OS jitter due to per-CPU kthreads

 Documentation/kernel-per-CPU-kthreads.txt | 202 ++++++++++++++++++++++++++++++
 1 file changed, 202 insertions(+)
 create mode 100644 Documentation/kernel-per-CPU-kthreads.txt

