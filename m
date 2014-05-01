Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaEAAuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:50:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3884 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752081AbaEAAuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:50:07 -0400
Message-Id: <20140501004757.583708392@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 30 Apr 2014 20:47:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 0/3] Linux 3.12.15-rt26-rc1
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

The 3.12-rt kernel is entering the stable phase. But instead of
just pulling the last development version into stable, there
were a few bugs that needed to be fixed first. The 3.12.15-rt26
will go through an rc phase before it is officially released as
stable.

This is the RT stable review cycle of patch 3.12.15-rt26-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 5/2/2014.

Enjoy,

-- Steve


To build 3.12.15-rt26-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.12.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.12.15.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.15-rt26-rc1.patch.xz

You can also build from 3.12.15-rt25 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.15-rt25-rt26-rc1.patch.xz


Changes from 3.12.15-rt25:

---


Steven Rostedt (1):
      rt: Move migrate_disable up in trylocks

Steven Rostedt (Red Hat) (2):
      net: gianfar: Fix missing return of gfar_clean_tx_ring()
      Linux 3.12.15-rt26-rc1

----
 drivers/net/ethernet/freescale/gianfar.c |  1 +
 kernel/rt.c                              | 20 ++++++++++++--------
 localversion-rt                          |  2 +-
 3 files changed, 14 insertions(+), 9 deletions(-)
