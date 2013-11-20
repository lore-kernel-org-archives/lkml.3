Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab3KTQIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:08:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab3KTQIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:08:30 -0500
Date: Wed, 20 Nov 2013 17:09:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] uprobes: uprobe_task/arch_uprobe/xol_area cleanups
Message-ID: <20131120160943.GA27228@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core

Another short series. No functional changes, everything was acked.

Oleg Nesterov (5):
      uprobes: Add uprobe_task->dup_xol_work/dup_xol_addr
      uprobes: Don't assume that arch_uprobe->insn/ixol is u8[MAX_UINSN_BYTES]
      uprobes/powerpc: Kill arch_uprobe->ainsn
      uprobes: Cleanup !CONFIG_UPROBES decls, unexport xol_area
      uprobes: Document xol_area and arch_uprobe->insn/ixol

 arch/powerpc/include/asm/uprobes.h |    5 +--
 arch/powerpc/kernel/uprobes.c      |    2 +-
 include/linux/uprobes.h            |   52 ++++++++++++-------------------
 kernel/events/uprobes.c            |   60 +++++++++++++++++++++++++----------
 4 files changed, 66 insertions(+), 53 deletions(-)

