Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934653Ab3BNOcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:32:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:34593 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760462Ab3BNOcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:32:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,665,1355126400"; 
   d="scan'208";a="202357461"
Date: Thu, 14 Feb 2013 20:01:19 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH v2 0/6] dma: various fixes in different DMAC drivers
Message-ID: <20130214143119.GG29960@intel.com>
References: <1360832420-6349-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360832420-6349-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 11:00:14AM +0200, Andy Shevchenko wrote:
> This is a patcset of independent fixes of the DMAC drivers. They are simple and
> being understandable in their context.
all applied, thanks

--
~Vinod
> 
> Since v1:
>  - address all comments
>  - add ACKs
>  - rebase on top of recent Vinod's next branch
> 
> Andy Shevchenko (6):
>   dma: of-dma: protect list write operation by spin_lock
>   dmaengine.h: remove redundant else keyword
>   dma: coh901318: avoid unbalanced locking
>   dma: coh901318: set residue only if dma is in progress
>   edma: do not waste memory for dma_mask
>   dma: tegra20-apb-dma: remove unnecessary assignment
> 
>  drivers/dma/coh901318.c       |    4 +++-
>  drivers/dma/coh901318_lli.c   |    2 +-
>  drivers/dma/edma.c            |    6 ++++--
>  drivers/dma/of-dma.c          |    2 ++
>  drivers/dma/tegra20-apb-dma.c |    1 -
>  include/linux/dmaengine.h     |    4 ++--
>  6 files changed, 12 insertions(+), 7 deletions(-)
> 
> -- 
> 1.7.10.4
> 
