Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3IQFsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 01:48:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:42263 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab3IQFsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 01:48:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,920,1371106800"; 
   d="scan'208";a="379309647"
Date: Tue, 17 Sep 2013 10:28:53 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        swarren@wwwdotorg.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH 1/1] dma: tegra20-apb-dma: Staticize
 tegra_dma_prep_dma_cyclic
Message-ID: <20130917045853.GP17188@intel.com>
References: <1378467982-30327-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378467982-30327-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 05:16:22PM +0530, Sachin Kamat wrote:
> tegra_dma_prep_dma_cyclic is referenced only in this file.
> Make it static.
Applied, thanks

~Vinod
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/dma/tegra20-apb-dma.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
> index 5d4986e..67a6752 100644
> --- a/drivers/dma/tegra20-apb-dma.c
> +++ b/drivers/dma/tegra20-apb-dma.c
> @@ -1018,7 +1018,7 @@ static struct dma_async_tx_descriptor *tegra_dma_prep_slave_sg(
>  	return &dma_desc->txd;
>  }
>  
> -struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
> +static struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
>  	struct dma_chan *dc, dma_addr_t buf_addr, size_t buf_len,
>  	size_t period_len, enum dma_transfer_direction direction,
>  	unsigned long flags, void *context)
> -- 
> 1.7.9.5
> 

-- 
