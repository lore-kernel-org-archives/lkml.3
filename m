Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaILNkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:40:40 -0400
Received: from relay.parallels.com ([195.214.232.42]:35543 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaILNkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:40:39 -0400
Message-ID: <1410529233.3569.22.camel@tkhai>
Subject: [PATCH 0/5] sched: Misc cleanups
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        <tkhai@yandex.ru>
Date: Fri, 12 Sep 2014 17:40:33 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a series of scheduler-related cleanups which I were collecting
for some time.

Nothing interesting, just boring cleanups...

---

Kirill Tkhai (5):
      cleanup, treewide: Remove set_current_state(TASK_RUNNING) after schedule
      sched/fair: cleanup: Remove useless assignment in select_task_rq_fair()
      sched/core: Use put_prev_task() accessor where possible.
      sched/rt: Remove useless if from cleanup pick_next_task_rt()
      sched/dl: Simplify pick_dl_task()


 arch/cris/arch-v10/drivers/sync_serial.c           |    1 -
 arch/cris/arch-v32/drivers/sync_serial.c           |    1 -
 arch/um/drivers/random.c                           |    1 -
 drivers/gpu/vga/vgaarb.c                           |    1 -
 drivers/md/dm-bufio.c                              |    1 -
 drivers/parisc/power.c                             |    1 -
 drivers/s390/net/claw.c                            |    2 --
 drivers/scsi/fcoe/fcoe.c                           |    1 -
 drivers/scsi/qla2xxx/qla_os.c                      |    1 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |    3 ---
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |    1 -
 drivers/staging/lustre/lustre/libcfs/fail.c        |    1 -
 drivers/tty/bfin_jtag_comm.c                       |    1 -
 fs/afs/vlocation.c                                 |    1 -
 fs/jfs/jfs_logmgr.c                                |    2 --
 fs/jfs/jfs_txnmgr.c                                |    3 ---
 fs/nfs/blocklayout/blocklayoutdev.c                |    1 -
 fs/nfs/blocklayout/blocklayoutdm.c                 |    1 -
 fs/nfsd/nfs4recover.c                              |    1 -
 kernel/sched/core.c                                |    8 ++++----
 kernel/sched/deadline.c                            |    4 +---
 kernel/sched/fair.c                                |    7 ++-----
 kernel/sched/rt.c                                  |    3 +--
 kernel/time/hrtimer.c                              |    1 -
 kernel/trace/ring_buffer_benchmark.c               |    3 ---
 25 files changed, 8 insertions(+), 43 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>


