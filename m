Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3KUI77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 03:59:59 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:53327 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3KUI76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 03:59:58 -0500
Date: Thu, 21 Nov 2013 09:59:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: uprobe_task/arch_uprobe/xol_area cleanups
Message-ID: <20131121085953.GA17197@gmail.com>
References: <20131120160943.GA27228@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120160943.GA27228@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Ingo, please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> 
> Another short series. No functional changes, everything was acked.
> 
> Oleg Nesterov (5):
>       uprobes: Add uprobe_task->dup_xol_work/dup_xol_addr
>       uprobes: Don't assume that arch_uprobe->insn/ixol is u8[MAX_UINSN_BYTES]
>       uprobes/powerpc: Kill arch_uprobe->ainsn
>       uprobes: Cleanup !CONFIG_UPROBES decls, unexport xol_area
>       uprobes: Document xol_area and arch_uprobe->insn/ixol
> 
>  arch/powerpc/include/asm/uprobes.h |    5 +--
>  arch/powerpc/kernel/uprobes.c      |    2 +-
>  include/linux/uprobes.h            |   52 ++++++++++++-------------------
>  kernel/events/uprobes.c            |   60 +++++++++++++++++++++++++----------
>  4 files changed, 66 insertions(+), 53 deletions(-)

Pulled, thanks a lot Oleg!

	Ingo
