Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaCMKpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:45:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:39360 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753727AbaCMKo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:44:29 -0400
Message-Id: <20140313104414.588331401@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 13 Mar 2014 06:44:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 0/4] Linux 3.4.82-rt103-rc1
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.4.82-rt103-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 3/18/2014.

Enjoy,

-- Steve


To build 3.4.82-rt103-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.82.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.82-rt103-rc1.patch.xz

You can also build from 3.4.82-rt102 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4.82-rt102-rt103-rc1.patch.xz


Changes from 3.4.82-rt102:

---


Marc Kleine-Budde (1):
      net: sched: dev_deactivate_many(): use msleep(1) instead of yield() to wait for outstanding qdisc_run calls

Sebastian Andrzej Siewior (1):
      fs: jbd2: pull your plug when waiting for space

Steven Rostedt (1):
      cpu_chill: Add a UNINTERRUPTIBLE hrtimer_nanosleep

Steven Rostedt (Red Hat) (1):
      Linux 3.4.82-rt103-rc1

----
 fs/jbd2/checkpoint.c    |  2 ++
 kernel/hrtimer.c        | 25 ++++++++++++++++++-------
 localversion-rt         |  2 +-
 net/sched/sch_generic.c |  2 +-
 4 files changed, 22 insertions(+), 9 deletions(-)
