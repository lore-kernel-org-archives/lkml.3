Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3JCQFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:05:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:52762 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab3JCQFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:05:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1026,1371106800"; 
   d="scan'208";a="302739086"
Date: Thu, 3 Oct 2013 20:43:32 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [[PATCH] 0/3] imx-dma: fixes
Message-ID: <20131003151332.GF16684@intel.com>
References: <1379426168-31989-1-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379426168-31989-1-git-send-email-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 03:56:05PM +0200, Michael Grzeschik wrote:
> Hello,
> 
> this series is solving some lockdep issues in the imx-dma code.
> There are some list_head and deadlock issues in the code,
> that is running the implementation into unsafe situations.

Thanks a bunch for doing this. I had similar ones but couldnt test due to lack
of HW. Lets keep improving this driver as it needs bunch of other fixes too...

~Vinod
> 
> Regards,
> Michael
> 
> Michael Grzeschik (3):
>   dma: imx-dma: fix slow path issue in prep_dma_cyclic
>   dma: imx-dma: fix lockdep issue between irqhandler and tasklet
>   dma: imx-dma: fix callback path in tasklet
> 
>  drivers/dma/imx-dma.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> -- 
> 1.8.4.rc3
> 

-- 
