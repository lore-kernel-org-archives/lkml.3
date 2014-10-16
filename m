Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaJPJjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:39:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:61048 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaJPJjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:39:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,731,1406617200"; 
   d="scan'208";a="606337440"
Date: Thu, 16 Oct 2014 14:33:46 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] dmaengine: Cleanup chancnt
Message-ID: <20141016090346.GE1638@intel.com>
References: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 11:00:52AM +0200, Maxime Ripard wrote:
> Hi everyone,
> 
> As pointed out in the documentation thread [1], the chancnt variable
> is filled during the driver registration in dma_async_device_register,
> from the liste of channels that has been set.
> 
> This serie removes the occurences of the drivers that set it in their
> probe function.
Barring the typos in the cover letter, series looks fine.


Thanks
-- 
~Vinod
> 
> Maxime
> 
> 
> 1: http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/292941.html
> 
> Maxime Ripard (11):
>   dmaengine: pl08x: Remove chancnt affectations
>   dmaengine: bcm2835: Remove chancnt affectations
>   dmaengine: jz4740: Remove chancnt affectations
>   dmaengine: fsldma: Remove chancnt affectations
>   dmaengine: k3: Remove chancnt affectations
>   dmaengine: mpc512x: Remove chancnt affectations
>   dmaengine: omap: Remove chancnt affectations
>   dmaengine: sa11x0: Remove chancnt affectations
>   dmaengine: sh: Remove chancnt affectations
>   dmaengine: sirf: Remove chancnt affectations
>   dmaengine: sun6i: Remove chancnt affectations
> 
>  drivers/dma/amba-pl08x.c      |  2 --
>  drivers/dma/bcm2835-dma.c     |  2 --
>  drivers/dma/dma-jz4740.c      |  3 +--
>  drivers/dma/fsldma.c          |  1 -
>  drivers/dma/k3dma.c           |  1 -
>  drivers/dma/mpc512x_dma.c     | 12 +++++++-----
>  drivers/dma/omap-dma.c        |  2 --
>  drivers/dma/sa11x0-dma.c      |  3 +--
>  drivers/dma/sh/rcar-audmapp.c |  2 --
>  drivers/dma/sh/rcar-hpbdma.c  |  2 --
>  drivers/dma/sh/shdma-base.c   |  2 +-
>  drivers/dma/sh/shdmac.c       |  2 --
>  drivers/dma/sh/sudmac.c       |  2 --
>  drivers/dma/sirf-dma.c        |  3 +--
>  drivers/dma/sun6i-dma.c       |  1 -
>  15 files changed, 11 insertions(+), 29 deletions(-)
> 
> -- 
> 2.1.1
> 

-- 
