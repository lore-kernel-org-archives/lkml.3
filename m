Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbaGBROk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:14:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:40509 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756248AbaGBROg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:14:36 -0400
Message-Id: <20140702171414.482562827@goodmis.org>
User-Agent: quilt/0.63-1
Date: Wed, 02 Jul 2014 13:14:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 0/4] Linux 3.12.22-rt35-rc1
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.12.22-rt35-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 7/7/2014.

Enjoy,

-- Steve


To build 3.12.22-rt35-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.12.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.12.22.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.22-rt35-rc1.patch.xz

You can also build from 3.12.22-rt34 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.22-rt34-rt35-rc1.patch.xz


Changes from 3.12.22-rt34:

---


Ben Hutchings (1):
      Fix latency histogram after "hrtimer: Set expiry time before switch_hrtimer_base()"

Sebastian Andrzej Siewior (2):
      Revert "migrate_disable pushd down in atomic_dec_and_spin_lock"
      timer: do not spin_trylock() on UP

Steven Rostedt (Red Hat) (1):
      Linux 3.12.22-rt35-rc1

----
 kernel/hrtimer.c | 10 +++++-----
 kernel/rtmutex.c |  6 +++---
 kernel/timer.c   | 13 +++++++++++++
 localversion-rt  |  2 +-
 4 files changed, 22 insertions(+), 9 deletions(-)
