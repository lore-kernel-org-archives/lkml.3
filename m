Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaG3Nqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:46:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:3222 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbaG3Nqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:46:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,764,1400050800"; 
   d="scan'208";a="463154112"
Date: Wed, 30 Jul 2014 19:08:06 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Alexander Popov <a13xp0p0v88@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] dmaengine: of: kconfig: select DMA_ENGINE when
 DMA_OF is selected
Message-ID: <20140730133806.GK8181@intel.com>
References: <1406721531-23635-1-git-send-email-a13xp0p0v88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406721531-23635-1-git-send-email-a13xp0p0v88@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 03:58:51PM +0400, Alexander Popov wrote:
> Select DMA_ENGINE when DMA_OF is selected since
> of_dma_xlate_by_chan_id() from drivers/dma/of-dma.c uses
> dma_get_slave_channel() from drivers/dma/dmaengine.c
>
Please give credit to reporter by adding "Reported-by:" tag in commit

It is also got practice to give error log 
> Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>

Applied, now after adding reported tag and error log

-- 
~Vinod
> ---
>  drivers/dma/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 1eca7b9..f887b19 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -388,6 +388,7 @@ config DMA_ACPI
>  config DMA_OF
>  	def_bool y
>  	depends on OF
> +	select DMA_ENGINE
>  
>  comment "DMA Clients"
>  	depends on DMA_ENGINE
> -- 
> 1.8.4.2
> 

-- 
