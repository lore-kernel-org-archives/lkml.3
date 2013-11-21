Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3KURBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:01:23 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:37670 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754209Ab3KURBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:01:18 -0500
Message-Id: <20131121165948.354971355@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 21 Nov 2013 11:59:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/7] Linux 3.8.13.13-rt25-rc1
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.8.13.13-rt25-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 11/25/2013.

Enjoy,

-- Steve


To build 3.8.13.13-rt25-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.8.13.13.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13.13-rt25-rc1.patch.xz

You can also build from 3.8.13.13-rt24 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13.13-rt24-rt25-rc1.patch.xz


Changes from 3.8.13.13-rt24:

---


Mike Galbraith (1):
      hwlat-detector: Don't ignore threshold module parameter

Sebastian Andrzej Siewior (2):
      mm/slub: do not rely on slab_cached passed to free_delayed()
      drm: remove preempt_disable() from drm_calc_vbltimestamp_from_scanoutpos()

Steven Rostedt (Red Hat) (1):
      Linux 3.8.13.13-rt25-rc1

Thomas Pfaff (1):
      genirq: Set the irq thread policy without checking CAP_SYS_NICE

Wolfram Sang (1):
      Kind of revert "powerpc: 52xx: provide a default in mpc52xx_irqhost_map()"

Yang Shi (1):
      mm/memcontrol: Don't call schedule_work_on in preemption disabled context

----
 arch/powerpc/platforms/52xx/mpc52xx_pic.c |  5 ++---
 drivers/gpu/drm/drm_irq.c                 |  7 -------
 drivers/misc/hwlat_detector.c             |  2 +-
 kernel/irq/manage.c                       |  2 +-
 localversion-rt                           |  2 +-
 mm/memcontrol.c                           |  4 ++--
 mm/slub.c                                 | 10 +++++-----
 7 files changed, 12 insertions(+), 20 deletions(-)
