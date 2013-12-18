Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3LRLjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:39:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:51158 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab3LRLi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:38:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,507,1384329600"; 
   d="scan'208";a="446265331"
Date: Wed, 18 Dec 2013 19:38:55 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: kbuild-all@01.org, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [mlankhorst:rebase-wip 10/28] Warning(drivers/base/fence.c:35):
 cannot understand function prototype: 'atomic_t fence_context_counter =
 ATOMIC_INIT(0); '
Message-ID: <20131218113855.GB19223@localhost>
References: <52b18253.C1XVcqO/ULIDYfu4%fengguang.wu@intel.com>
 <52B183C3.80306@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B183C3.80306@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 12:15:15PM +0100, Maarten Lankhorst wrote:
> op 18-12-13 12:09, kbuild test robot schreef:
> > tree:   git://people.freedesktop.org/~mlankhorst/linux rebase-wip
> > head:   f4860763bb15e72067344fdf961be339d029f9a6
> > commit: 57c3e34f8e55cc2c909daa88ce4eefdf97372f9b [10/28] fence: dma-buf cross-device synchronization (v15)
> > reproduce: make htmldocs
> >
> > All warnings:
> >
> >    Warning(include/linux/wait.h:305): No description found for parameter 'cmd1'
> >    Warning(include/linux/wait.h:305): No description found for parameter 'cmd2'
> >    Warning(kernel/sys.c): no structured comments found
> >    Warning(kernel/rcu/srcu.c:496): No description found for parameter 'sp'
> >    Warning(drivers/base/dd.c:60): No description found for parameter 'work'
> >>> Warning(drivers/base/fence.c:35): cannot understand function prototype: 'atomic_t fence_context_counter = ATOMIC_INIT(0); '
> >    Warning(drivers/base/reservation.c): no structured comments found
> >    Warning(include/linux/reservation.h): no structured comments found
> >    Warning(drivers/base/power/main.c:1108): No description found for parameter 'info'
> >    Warning(drivers/acpi/scan.c): no structured comments found
> >    Warning(include/linux/spi/spi.h:650): No description found for parameter 'frame_length'
> >    Warning(drivers/spi/spi.c:638): No description found for parameter 'master'
> >    Warning(drivers/spi/spi.c:638): No description found for parameter 'master'
> >
> > ---
> > 0-DAY kernel build testing backend              Open Source Technology Center
> > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> >
> htmldocs seems to be wrong here. This is not a function prototype. Can I silence the bot somehow about it?

Maarten, sorry I'm not sure how to quiet the warning. CC the list for
possible solutions.

Thanks,
Fengguang
