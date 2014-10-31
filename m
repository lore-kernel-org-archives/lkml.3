Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422710AbaJaBKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:10:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:45913 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161392AbaJaBKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:10:11 -0400
Message-Id: <20141031010945.211059309@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 30 Oct 2014 21:09:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 0/2] Linux 3.2.63-rt93-rc1
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.2.63-rt93-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 11/3/2014.

Enjoy,

-- Steve


To build 3.2.63-rt93-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.63.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.63-rt93-rc1.patch.xz

You can also build from 3.2.63-rt92 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.63-rt92-rt93-rc1.patch.xz


Changes from 3.2.63-rt92:

---


Steven Rostedt (Red Hat) (2):
      lockdep: Fix backport of "Correctly annotate hardirq context in irq_exit()"
      Linux 3.2.63-rt93-rc1

----
 kernel/softirq.c | 5 +++--
 localversion-rt  | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)
