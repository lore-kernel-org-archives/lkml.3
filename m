Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbaGNUDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:03:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:3129 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756913AbaGNUD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:03:29 -0400
Message-Id: <20140714200314.105504666@goodmis.org>
User-Agent: quilt/0.63-1
Date: Mon, 14 Jul 2014 16:03:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 0/3] Linux 3.12.24-rt38-rc1
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.12.24-rt38-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 7/17/2014.

Enjoy,

-- Steve


To build 3.12.24-rt38-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.12.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.12.24.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.24-rt38-rc1.patch.xz

You can also build from 3.12.24-rt37 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.24-rt37-rt38-rc1.patch.xz


Changes from 3.12.24-rt37:

---


Steven Rostedt (1):
      sched: Do not clear PF_NO_SETAFFINITY flag in select_fallback_rq()

Steven Rostedt (Red Hat) (1):
      Linux 3.12.24-rt38-rc1

Thomas Gleixner (1):
      workqueue: Prevent deadlock/stall on RT

----
 kernel/sched/core.c | 13 +++++-------
 kernel/workqueue.c  | 61 +++++++++++++++++++++++++++++++++++++++++------------
 localversion-rt     |  2 +-
 3 files changed, 54 insertions(+), 22 deletions(-)
