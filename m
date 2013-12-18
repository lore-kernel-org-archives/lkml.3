Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3LRRTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:19:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:16686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3LRRTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:19:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,508,1384329600"; 
   d="scan'208";a="426725941"
Date: Wed, 18 Dec 2013 21:41:07 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Alexander Popov <a13xp0p0v88@gmail.com>
Cc: Gerhard Sittig <gsi@denx.de>, Dan Williams <dan.j.williams@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        Anatolij Gustschin <agust@denx.de>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] dmaengine: fix incorrect kernel-doc comment for
 struct dma_slave_config
Message-ID: <20131218161107.GI16227@intel.com>
References: <1387181537-3254-1-git-send-email-a13xp0p0v88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387181537-3254-1-git-send-email-a13xp0p0v88@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 12:12:17PM +0400, Alexander Popov wrote:
> The 'direction' member of 'struct dma_slave_config' is of data
> type 'enum dma_transfer_direction', so update the kernel-doc comment
> for 'struct dma_slave_config' to refer to appropriate values.
> 
> Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>

Applied, thanks

--
~Vinod

> ---
>  include/linux/dmaengine.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 41cf0c3..bd6b882 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -305,9 +305,8 @@ enum dma_slave_buswidth {
>  /**
>   * struct dma_slave_config - dma slave channel runtime config
>   * @direction: whether the data shall go in or out on this slave
> - * channel, right now. DMA_TO_DEVICE and DMA_FROM_DEVICE are
> - * legal values, DMA_BIDIRECTIONAL is not acceptable since we
> - * need to differentiate source and target addresses.
> + * channel, right now. DMA_MEM_TO_DEV and DMA_DEV_TO_MEM are
> + * legal values.
>   * @src_addr: this is the physical address where DMA slave data
>   * should be read (RX), if the source is memory this argument is
>   * ignored.
> -- 
> 1.8.4.2
> 

-- 
