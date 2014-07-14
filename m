Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbaGNUFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:05:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:10540 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757261AbaGNUFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:05:46 -0400
Message-Id: <20140714200535.671192970@goodmis.org>
User-Agent: quilt/0.63-1
Date: Mon, 14 Jul 2014 16:05:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 0/4] Linux 3.4.97-rt121-rc1
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.4.97-rt121-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 7/17/2014.

Enjoy,

-- Steve


To build 3.4.97-rt121-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.97.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.97-rt121-rc1.patch.xz

You can also build from 3.4.97-rt120 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4.97-rt120-rt121-rc1.patch.xz


Changes from 3.4.97-rt120:

---


Steven Rostedt (1):
      sched: Do not clear PF_NO_SETAFFINITY flag in select_fallback_rq()

Steven Rostedt (Red Hat) (1):
      Linux 3.4.97-rt121-rc1

Thomas Gleixner (1):
      workqueue: Prevent deadlock/stall on RT

Zhao Hongjiang (1):
      hrtimer:fix the miss of hrtimer_peek_ahead_timers in nort code

----
 kernel/hrtimer.c    |  6 +++++-
 kernel/sched/core.c | 13 +++++--------
 kernel/workqueue.c  | 41 +++++++++++++++++++++++++++++++++++------
 localversion-rt     |  2 +-
 4 files changed, 46 insertions(+), 16 deletions(-)
