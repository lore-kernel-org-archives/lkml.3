Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab3BFWCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:02:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28700 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084Ab3BFWCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:02:51 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=t-28cO3uvLEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=evC8euxjDUgA:10 a=VwQbUJbxAAAA:8 a=ankguWfssnWlHO32Y0EA:9 a=U62fhAwekXMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130206220210.823160521@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Feb 2013 17:02:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/6] [ANNOUNCE] 3.2.38-rt57-rc1 stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.2.38-rt57-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 2/8/2013.

Enjoy,

-- Steve


To build 3.2.38-rt57-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.38.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.38-rt57-rc1.patch.xz

You can also build from 3.2.38-rt56 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.38-rt56-rt57-rc1.patch.xz


Changes from 3.2.38-rt56:

---


Steven Rostedt (1):
      Linux 3.2.38-rt57-rc1

Thomas Gleixner (5):
      drivers-tty-pl011-irq-disable-madness.patch
      mmci: Remove bogus local_irq_save()
      sched: Init idle->on_rq in init_idle()
      sched: Check for idle task in might_sleep()
      mm: swap: Initialize local locks early

----
 drivers/mmc/host/mmci.c         |    5 -----
 drivers/tty/serial/amba-pl011.c |   15 ++++++++++-----
 kernel/sched.c                  |    4 +++-
 localversion-rt                 |    2 +-
 mm/swap.c                       |   12 +++++++++---
 5 files changed, 23 insertions(+), 15 deletions(-)
