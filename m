Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3ALNdx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 08:33:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:34072 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab3ALNdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 08:33:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,456,1355126400"; 
   d="scan'208";a="243109570"
Date: Sat, 12 Jan 2013 05:09:26 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCHv2 00/11] patches against slave dma subsystem
Message-ID: <20130112130926.GY19691@intel.com>
References: <1357807986-4026-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357807986-4026-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 10:52:55AM +0200, Andy Shevchenko wrote:
> Recend to Vinod for review.
> 
> Since v1:
>  - is_slave_xfer renamed to is_slave_direction
>  - changelog fixed for "dma: dw_dmac: clear suspend bit during termination"
>  - typo fixed in the changelog of "dw_dmac: backlink to dw_dma in dw_dma_chan
>    is superfluous"
Applied all, Thanks

--
~Vinod
> 
> Andy Shevchenko (10):
>   dmaengine: introduce is_slave_direction function
>   dma: at_hdmac: check direction properly for cyclic transfers
>   dma: dw_dmac: check direction properly in dw_dma_cyclic_prep
>   dma: ep93xx_dma: reuse is_slave_direction helper
>   dma: ipu_idmac: reuse is_slave_direction helper
>   dma: ste_dma40: reuse is_slave_direction helper
>   dw_dmac: call .probe after we have a device in place
>   dw_dmac: store direction in the custom channel structure
>   dw_dmac: make usage of dw_dma_slave optional
>   dw_dmac: backlink to dw_dma in dw_dma_chan is superfluous
> 
> Heikki Krogerus (1):
>   dma: dw_dmac: clear suspend bit during termination
> 
>  drivers/dma/at_hdmac.c      |   10 +++----
>  drivers/dma/dw_dmac.c       |   62 ++++++++++++++++++++++++++++++-------------
>  drivers/dma/dw_dmac_regs.h  |   17 ++++++------
>  drivers/dma/ep93xx_dma.c    |    3 +--
>  drivers/dma/ipu/ipu_idmac.c |    2 +-
>  drivers/dma/ste_dma40.c     |    2 +-
>  include/linux/dmaengine.h   |    5 ++++
>  7 files changed, 64 insertions(+), 37 deletions(-)
> 
> -- 
> 1.7.10.4
> 
