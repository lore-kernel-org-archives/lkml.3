Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaD0Oey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 10:34:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:10188 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750740AbaD0Oew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 10:34:52 -0400
Message-Id: <20140427143430.589333461@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 27 Apr 2014 10:34:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 0/3] Linux 3.8.13.14-rt31-rc1
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.8.13.14-rt31-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 4/30/2014.

Enjoy,

-- Steve


To build 3.8.13.14-rt31-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.8.13.14.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13.14-rt31-rc1.patch.xz

You can also build from 3.8.13.14-rt30 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13.14-rt30-rt31-rc1.patch.xz


Changes from 3.8.13.14-rt30:

---


Sebastian Andrzej Siewior (2):
      net: gianfar: do not disable interrupts
      rcu: make RCU_BOOST default on RT

Steven Rostedt (Red Hat) (1):
      Linux 3.8.13.14-rt31-rc1

----
 drivers/net/ethernet/freescale/gianfar.c         | 16 ++++++++--------
 drivers/net/ethernet/freescale/gianfar_ethtool.c |  8 ++++----
 drivers/net/ethernet/freescale/gianfar_sysfs.c   | 24 ++++++++++++------------
 init/Kconfig                                     |  2 +-
 localversion-rt                                  |  2 +-
 5 files changed, 26 insertions(+), 26 deletions(-)
