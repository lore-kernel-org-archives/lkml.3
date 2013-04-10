Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934904Ab3DJTxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:53:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38485 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3DJTxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:53:32 -0400
Date: Wed, 10 Apr 2013 15:53:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.9-rc6-tag
Message-ID: <20130410195325.GA31790@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.9-rc6-tag

which has two fixes. One of them is a bootup fix and the other an bug where would
not immediately process the timer interrupts leading to quite delayed time skew on certain
workloads.

 arch/x86/xen/mmu.c   | 12 ++++++++----
 drivers/xen/events.c | 19 +++++++++++++++----
 2 files changed, 23 insertions(+), 8 deletions(-)

Keir Fraser (1):
      xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.

Konrad Rzeszutek Wilk (1):
      xen/mmu: On early bootup, flush the TLB when changing RO->RW bits Xen provided pagetables.

