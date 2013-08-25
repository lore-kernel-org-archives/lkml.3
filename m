Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab3HYL2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 07:28:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:59776 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618Ab3HYL2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 07:28:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,951,1367996400"; 
   d="scan'208";a="391686208"
Date: Sun, 25 Aug 2013 16:14:00 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] dma/Kconfig: TI_EDMA needs to be boolean
Message-ID: <20130825104400.GJ8091@intel.com>
References: <1377205404-16786-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377205404-16786-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 02:03:24PM -0700, Guenter Roeck wrote:
> Fix:
> 
> arch/arm/common/built-in.o: undefined reference to `edma_filter_fn'
> 
> seen with "make ARCH=arm allmodconfig"
> 
> Commit 6cba4355 (ARM: edma: Add DT and runtime PM support to the private EDMA
> API) adds a dependency on edma_filter_fn() into arch/arm/common/edma.c. Since
> this file is always built into the kernel, edma_filter_fn() must be built into
> the kernel as well.
Applied, thanks

~Vinod
